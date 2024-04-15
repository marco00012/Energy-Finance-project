function [Fvector] = Swap_Aritmetic(t0,T1,T2, b1,b2,eta1,eta2,A,B,C,k)

t0=0;
t12 = [T1 T2];
N_prods = size(t12, 1);
Fvector = zeros(N_prods, 1);
for pp=1:20


Lambda= @(t,A,B,C) A*sin(2*pi*t)+B+C*t;
nu=@(y,k) (y>1e-8)*(1/sqrt(2*pi*k)).*(1./((y).^(1.5))).*exp(-y/2*k);
gamma=quadgk(@(y) nu(y,k).*y,-1,1);

% theta_Y1=@(t) 0;
% theta_Y2=@(t) 0;
%Theta=@(t,T)  eta1*(quadgk(@(u)arrayfun(@(u)quadgk(@(y) nu(y)*exp(-b1*(T-u)).*y.*(exp(theta_Y1(u)*y)-(y<1)),1e-8,30),u),t,T))+eta2*(quadgk(@(u)arrayfun(@(u)quadgk(@(y) nu(y)*exp(-b2*(T-u)).*y.*(exp(theta_Y2(u)*y)-(y<1)),1e-8,30),u),t,T))...
     %+gamma/b1*eta1*(1-exp(-b1*(T-t))) + gamma/b2*eta2*(1-exp(-b2*(T-t))) 
%% Theta obtained analitycally from above IG case
Theta=@(t,T,eta1,eta2,b1,b2,k) eta1*erfc(1/(sqrt(2*k)))*1/b1*(1-exp(-b1*(T-t)))+eta2*erfc(1/(sqrt(2*k)))*1/b2*(1-exp(-b2*(T-t)))+gamma/b1*eta1*(1-exp(-b1*(T-t))) + gamma/b2*eta2*(1-exp(-b2*(T-t))) ;

TT1=t12(pp,1);
TT2=t12(pp,2);

Y_Q_1=1-gamma/b1*eta1*(1-exp(-b1*TT1))-eta1*erfc(1/(sqrt(2*k)))*1/b1*(1-exp(-b1));
Y_Q_2=1-gamma/b2*eta2*(1-exp(-b2*TT1))-eta2*erfc(1/(sqrt(2*k)))*1/b2*(1-exp(-b2));
%% Swap prices
F=@(t,TT1,TT2) quadgk(@(u) Theta(t,u,eta1,eta2,b1,b2,k),TT1,TT2)+quadgk(@(t)Lambda(t,A,B,C),TT1,TT2)/(TT2-TT1)+Y_Q_1*(exp(-b1*TT1)-exp(-b1*TT2))/(b1*(TT2-TT1))+Y_Q_2*(exp(-b2*TT1)-exp(-b2*TT2))/(b2*(TT2-TT1));
Fvector(pp)=F(t0,TT1,TT2);


end

end