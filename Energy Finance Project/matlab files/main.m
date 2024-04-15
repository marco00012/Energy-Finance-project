clear all
clc
%% PUNTO 1
%Driven by Gamma process.
t=1;
dt=t/365;
time_steps=t/dt;
%% Constant Parameters Starting from Nord Pool datacase (PAG 88 BOOK BENTH)
y_0=1;
%b1=0.085;
b2=1.1;
d1=0;
d2=0;
% eta1=0.1;
% eta2=0.1;
A=30;
B=100;
C=0.025;
tt=[t:-dt:dt];
Lambda_tt= A*sin(2*pi*tt)+B+C*tt;
Lambda= @(t) A*sin(2*pi*t)+B+C*t;
plot(tt,Lambda_tt)

%% POINT 1) simulation of S(t) North Pool case
%%y1
scale=1/7.7;
shape=8.06;
Y1=60*gamrnd(shape,scale,1,time_steps);
figure()
plot(tt,Y1)
title('Gamma OU Process Y1(t)')
ylabel('Price') 
xlabel('Time') 

%%y2
k=0.5;
shape2=1/k*dt;
scale2=k;
Y2 = 1000*gamrnd(shape2,scale2,1,time_steps).*exp(-b2*((t:-dt:dt)-dt/2));
figure()
plot(tt,Y2)
title('Spike Process Y2(t)')
ylabel('Price') 
xlabel('Time') 

%%S ARITHMETIC PLOT
S= Lambda(t)+Y1+Y2;
figure()
plot(tt,S)
title('Spot price electricity')
ylabel('Price') 
xlabel('Time') 

%% PUNTO 4 
%%DATES INITIALIZATION
t0 = datenum(2022,11,04); %trading date
file = 'DataFREEX.xlsx';
fwd = readtable(file, 'Sheet','Fwd');
[fwd] = dates(fwd,t0);
%% CALIBRATION 8 params of our Arithmetic model using lsqcurvefit

b1 = [];
b2 = [];
eta1 = [];
eta2 = [];
A = []; 
B = []; 
C = []; 
k = [];

t00=0;
Fwd = @(params, t12) Swap_Aritmetic(t00,t12(:,1), t12(:,2), params(1), params(2), params(3), params(4),params(5), params(6), params(7), params(8));
T12 = [fwd.T1LAG, fwd.T2LAG]/360;
F_mkt = fwd.Price;
% TRY 1) 
% C=0.0017, ETA1 e ETA2 >-10
tic
[params, ~, residual, ~, ~] = lsqcurvefit(Fwd, ...
    [0.085,1.1,0.1,0.1,30,100,0.025,0.5],...
    T12, F_mkt, [eps, eps, -5, -10, eps, eps ,eps , eps ], [+10, +10, +5, +10, +1000,+1000,+100,+10] );
toc
%% TRY 2)
% C=0.53, ETA1 e ETA2 <-40

% tic
% [params, ~, residual, ~, ~] = lsqcurvefit(Fwd, ...
%     [0.085,1.1,0.1,0.1,30,100,0.025,0.5],...
%     T12, F_mkt, [eps, eps, -50, -50, eps, eps ,eps , eps ], [+inf, +inf, +50, +50, +1000,+1000,+100,+10] );
% toc
%% TRY 3) 
%'levenberg-marquardt' method NOT GOOD CALIBRATION

%tic
% [params, ~, residual, ~, ~] = lsqcurvefit(Fwd, ...
%     [0.085,1.1,0.1,0.1,30,100,0.025,0.5],...
%     T12, F_mkt, [eps, eps, -50, -50, eps, eps ,eps , eps ], [+inf, +inf, +50, +50, +1000,+1000,+100,+inf],OPTIONS );
%toc
%% PARAMS VALUE SAVED
b1 = params(1);
b2 = params(2);
eta1 = params(3);
eta2 = params(4);
A = params(5); 
B = params(6); 
C = params(7); 
k = params(8);

%%PRICES OBTAINED
F_fitted = Fwd([ b1,b2,eta1,eta2,A,B,C,k], [(fwd.T1LAG)/360, (fwd.T2LAG)/360]);

%% PLOT 1 
% We plot the fitted forward prices and the market forward prices 1 price
% for every date

T12=unique(sort(datenum(fwd.T1)));

F_fitted_plot=F_fitted(1:2);
F_fitted_plot(3:5)=F_fitted(5:7);
F_fitted_plot(6:10)=F_fitted(9:13);
F_fitted_plot(11:16)=F_fitted(15:20);

F_mkt_plot = F_mkt(1:2);
F_mkt_plot(3:5)  = F_mkt(5:7);
F_mkt_plot(6:10) = F_mkt(9:13);
F_mkt_plot(11:16)= F_mkt(15:20);

fig_fwdfit = figure();
h9 = plot_quotations(T12, F_mkt_plot, fig_fwdfit, 'r-');
hold on
h10 = plot_quotations(T12, F_fitted_plot, fig_fwdfit, 'b-');
title('Swap prices fitting')
ylabel('[€/MWh]')
datetick
grid on
legend([h9(1), h10(1)], 'F_{market}','F_{fitted}')
%% We plot the FWD fitting residuals: we can remark that residuals are smaller
% further in time
figure, bar(residual) 
grid on
title('Swaps fitting: Residuals')
ylabel('[€/MWh]') 

%% POINT 5) SIMULATION OF ARITHMETIC MODEL

% TRY 1 PARAMS 
b1 = 1.09771610219808;
b2 = 1.10642878472344;
eta1 = -4.14319582058300;
eta2 = -9.05174902047426;
A = 366.302657874939; 
B = 442.484258010818; 
C = 0.00170595931845587; 
k = 0.00111962643222655;

% TRY 2 PARAMS
% b1 = 1.10917626986489;
% b2 = 1.09751174635978;
% eta1 = -42.3573159617590;
% eta2 = -49.2585925080214;
% A = 368.062601281903; 
% B = 440.643707073349; 
% C = 0.537147220493738; 
% k = 0.0529749408290142;

[Swap_2y,IC95] = Arithmetic_simulation(b1,b2,eta1,eta2,A,B,C,k)  

%% VALUTARE LA CONVERGENZA IN BASE AL N DI SIMULAZIONI
% 3 paths of simulations increasing every time the number of simulations
% result in same final price with 10^5 simulations.

Swap_2y_simulated=[ 511.6263, 511.6328 , 511.63407, 511.6333  ]';

Swap_2y_simulated_2=[511.6152, 511.6331 , 511.63294, 511.6333  ]';

Swap_2y_simulated_3=[511.6373, 511.6392, 511.63275, 511.6333]';

Nsim=[10^2,10^3,10^4,10^5]';
figure();
semilogx(Nsim,Swap_2y_simulated);
hold on
semilogx(Nsim,Swap_2y_simulated_2);
hold on
semilogx(Nsim,Swap_2y_simulated_3);
title('Swap simulation');
ylabel('€');
xlabel('Number of simulations');


%% PRICING OF EU PLAIN VANILLA PUTS
t=0; T=2;
zero_rate=0.02; % 2%
BB=exp(-zero_rate*(T-t)); %% discount factor
K=[400:10:600]';
Put=(zeros(size(K)));
for ii=1:21
Put(ii)=BB*max(K(ii)-Swap_2y,0);
end

figure();
plot(K,Put,'Marker', '*');
title('Eu Plain Vanilla Puts on Swap 2y Price')
ylabel('Put Prices')
xlabel('Strikes')


%% FACULTATIVE
%%POINT VII)
%Arithmetic model framework p=1, m=1, n=0;
t=1;
dt=t/365;
time_steps=t/dt;
%% Constant Parameters Nord Pool case
a=0.5;
mu=0;
sigma=0.2;
b=1;
x_0=1;
A=30;
B=100;
C=0.025;
%% Seasonality
Lambda=@(t) A*sin(2*pi*t)+B+C*t;
%%Gamma parameter
k=0.5;
shape=1/k*dt; scale=k;
nu=@(y) (y>1e-8)*1/k.*exp(-y/k)./y;
gamma=quadgk(@(y) nu(y).*y,-1,1);

%%Simulate OU spot
N_sim=10^3;
path = gamrnd(shape,scale,N_sim,time_steps).*exp(-b*((t:-dt:dt)-dt/2)); 
G=randn(N_sim,1);
X=x_0*exp(-a*t)+mu/a*(1-exp(-a*t))+sigma*sqrt((1-exp(-2*a*t))/2/a)*G;
S= Lambda(t)+X;
mean(S)
%% POINT 2) FORWARD PRICE
%%Simulate fwd under Q
theta_x=@(t) 0;
theta_y=@(t) 0;
t=1;
T=2;
Theta=@(t,T) sigma*quadgk(@(u)theta_x(u)*exp(-a*(T-u)),t,T);
X_Q=X;
f=@(t,T,X) Lambda(T)+Theta(t,T)+mu/a*(1-exp(-a*(T-t)))+X_Q*exp(-a*(T-t));
mean(f(t,T,X))
%% POINT 3) SWAP PRICE
%%Simulate swap under Q (Proposition 4.14)
T1=2;
T2=3;
F=@(t,T1,T2,X) quadgk(@(u) arrayfun(@(u)Theta(t,u),u),T1,T2)+quadgk(@(t)Lambda(t),T1,T2)/(T2-T1)+X_Q*(exp(-a*T1)-exp(-a*T2))/(a*(T2-T1));
F(0,T1,T2,1);
mean(F(0,T1,T2,1))
%% 4) CALIBRATION  2 with p=1, m=1, n=0;

a=[];
theta_x= [];
sigma=[];
A = []; 
B = []; 
C = []; 

t00=0;
Fwd = @(params, t12) Swap_Aritmetic_2(t00,t12(:,1), t12(:,2), params(1), params(2), params(3),params(4),params(5),params(6));
T12 = [fwd.T1LAG, fwd.T2LAG]/360;
F_mkt = fwd.Price;

tic
[params, ~, residual, ~, ~] = lsqcurvefit(Fwd, ...
    [0.5,0,0.2,30,100,0.025],...
    T12, F_mkt, [eps,eps,eps, eps, eps, -100 ], [+1,10,10, +500,+600,+1] ); 
toc

a=params(1);
theta_x=params(2);
sigma=params(3);
A=params(4);
B=params(5);
C=params(6); %%C negative

%% PLOT 1 
% We plot the fitted forward prices and the market forward prices, 1 price for every date

T12=unique(sort(datenum(fwd.T1)));
F_fitted_plot=F_fitted(1:2);
F_fitted_plot(3:5)=F_fitted(5:7);
F_fitted_plot(6:10)=F_fitted(9:13);
F_fitted_plot(11:16)=F_fitted(15:20);

F_mkt_plot = F_mkt(1:2);
F_mkt_plot(3:5)  = F_mkt(5:7);
F_mkt_plot(6:10) = F_mkt(9:13);
F_mkt_plot(11:16)= F_mkt(15:20);

fig_fwdfit = figure();
h9 = plot_quotations(T12, F_mkt_plot, fig_fwdfit, 'r-');
hold on
h10 = plot_quotations(T12, F_fitted_plot, fig_fwdfit, 'g-');
title('Forward products fitting')
ylabel('[€/MWh]')
datetick
grid on
legend([h9(1), h10(1)], 'F_{market}','F_{fitted}')
%% PLOT RESIDUALS
%We plot the forward fitting residuals: we can remark that residuals are smaller
% further in time

figure, bar(residual) 
grid on
title('FWD fitting: Residuals')
ylabel('[€/MWh]') 
%% POINT 5 SIMULATION OF SWAP 2Y
a=0.817145436337675;
theta_x=1.7e-06;
sigma=0.149;
A=347.273908960324;
B=510.067097377570;
C=-82.7146763341531;

t=1;
T=3;
[Swap_2y_facultative,IC95_2] = Arithmetic_simulation_2(a,A,B,C)  
%% PUT PRICES 
zero_rate=0.02; % 2%
BB=exp(-zero_rate*(T-t)); % discount factor
K=[300:10:500]';
Put=(zeros(size(K)));
for ii=1:21
Put(ii)=BB*max(K(ii)-Swap_2y_facultative,0);
end
fig_fwdfit = figure();
plot(K,Put,'Marker', '*');
title('Eu Plain Vanilla Puts on Swap 2y Price')
ylabel('Put Prices')
xlabel('Strikes')











