function [F,MUCI] = Arithmetic_simulation_2(a,A,B,C)
sigma=0.1490; %% sigma calibrated
mu=0.1; %% Mu not calibrated
N_sim=10^5;
t=1;
Lambda= @(t) A*sin(2*pi*t)+B+C*t;

%theta_x=@(t) 0;
theta_x=1.7e-06; %% theta_x calibrated

% Theta=@(t,T) exp(  quadgk(@(u)arrayfun(@(u)quadgk(@(y) nu(y).*(exp(eta*y*exp(-b*(T-u))+theta_y(u))-1-(eta.*exp(-b*(T-u))+theta_y(u))*y.*(abs(y)<1)),1e-8,30),u),t,T)...
%     -quadgk(@(u)arrayfun(@(u)quadgk(@(y) nu(y).*(exp(theta_y(u)*y)-1-theta_y(u)*y*exp(-b*(T-u)).*(abs(y)<1)),1e-8,30),u),t,T)...
%     +gamma/b*eta*(1-exp(-b*(T-t))+1/4*sigma^2/a*(1-exp(-2*a*(T-t)))+sigma*quadgk(@(u)theta_x(u)*exp(-a*(T-u)),t,T)));

Theta=@(t,T) exp( +1/4*sigma^2/a*(1-exp(-2*a*(T-t))))+sigma*theta_x*(1/a)*(1-exp(a*(t-T)));; %% THETA SOLVED ANALYTICALLY WITH PARAMETERS TERMS NEEDED

G=randn(N_sim,1);
x_0=1;
X=x_0*exp(-a*t)+mu/a*(1-exp(-a*t))+sigma*sqrt((1-exp(-2*a*t))/2/a)*G;
X_Q=X;

f=@(t,T,X_Q) Lambda(T)+Theta(t,T).*exp(mu/a*(1-exp(-a*(T-t)))+exp(-a*(T-t))*X_Q);

T1=1;
T2=3;
Times=T1:((T2-T1)/24):T2;
F=0;
for i=2:length(Times)
F=F+f(t,Times(i),X_Q)/(T2-T1)*(Times(i)-Times(i-1));
end
format long;
[MUHAT,SIGMAHAT,MUCI,SIGMACI]=normfit(F);
F = mean(F);


end