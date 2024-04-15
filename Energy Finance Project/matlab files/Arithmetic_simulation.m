function [F,MUCI] = Arithmetic_simulation(b1,b2,eta1,eta2,A,B,C,k)

%%simulate O-U
N_sim=10^4;
t=1;
T=3;
dt=T/720;
time_steps=720;
shape=1/k*dt; scale=k;
%%Nu I-G
Lambda= @(t) A*sin(2*pi*t)+B+C*t;
nu=@(y) (y>1e-8)*(1/sqrt(2*pi*k)).*(1./((y).^1.5)).*exp(-y/2*k); %% nu IG case
gamma=quadgk(@(y) nu(y).*y,-1,1);

path1 = gamrnd(shape,scale,N_sim,time_steps).*exp(-b1*((T:-dt:dt)-dt/2)); % To check dt
path2 = gamrnd(shape,scale,N_sim,time_steps).*exp(-b2*((T:-dt:dt)-dt/2)); % To check dt
Y1=1*exp(-b1*t)+eta1*sum(path1,2);
Y2=1*exp(-b2*t)+eta2*sum(path2,2);

%%Simulate Fwd under Q

theta_y=@(t) 0;

Theta=@(t,T) exp(  quadgk(@(u)arrayfun(@(u)quadgk(@(y) nu(y).*(exp(eta1*y*exp(-b1*(T-u))+theta_y(u))-1-(eta1.*exp(-b1*(T-u))+theta_y(u))*y.*(abs(y)<1)),1e-8,30),u),t,T)...
    -quadgk(@(u)arrayfun(@(u)quadgk(@(y) nu(y).*(exp(theta_y(u)*y)-1-theta_y(u)*y*exp(-b1*(T-u)).*(abs(y)<1)),1e-8,30),u),t,T)...
    +gamma/b1*eta1*(1-exp(-b1*(T-t))))+...
    exp(  quadgk(@(u)arrayfun(@(u)quadgk(@(y) nu(y).*(exp(eta2*y*exp(-b2*(T-u))+theta_y(u))-1-(eta2.*exp(-b2*(T-u))+theta_y(u))*y.*(abs(y)<1)),1e-8,30),u),t,T)...
    -quadgk(@(u)arrayfun(@(u)quadgk(@(y) nu(y).*(exp(theta_y(u)*y)-1-theta_y(u)*y*exp(-b2*(T-u)).*(abs(y)<1)),1e-8,30),u),t,T)...
    +gamma/b2*eta2*(1-exp(-b2*(T-t))));

Y_Q_1=Y1-gamma/b1*eta1*(1-exp(-b1*t))-eta1*erfc(1/(sqrt(2*k)))*1/b1*(1-exp(-b1));
Y_Q_2=Y2-gamma/b2*eta2*(1-exp(-b2*t))-eta2*erfc(1/(sqrt(2*k)))*1/b2*(1-exp(-b2));

f=@(t,T,Y_Q_1,Y_Q_2) Lambda(T)+Theta(t,T)+exp(-b1*(T-t))*Y_Q_1+exp(-b2*(T-t))*Y_Q_2;

T1=1;
T2=3;

Times=T1:((T2-T1)/24):T2;
F=0;
for i=2:length(Times)
F=F+f(t,Times(i),Y_Q_1,Y_Q_2)/(T2-T1)*(Times(i)-Times(i-1));
end

[MUHAT,SIGMAHAT,MUCI,SIGMACI]=normfit(F);
F = mean(F);

end


