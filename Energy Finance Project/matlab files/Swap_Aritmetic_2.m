function [Fvector] = Swap_Aritmetic_2(t0,T1,T2,a,theta_x,sigma,A,B,C)

t0=0;
t12 = [T1 T2];
N_prods = size(t12, 1);
Fvector = zeros(N_prods, 1);
for pp=1:20


Lambda= @(t,A,B,C) A*sin(2*pi*t)+B+C*t;

%Theta=@(t,T) % eta*quadgk(@(u)arrayfun(@(u)quadgk(@(y) nu(y)*exp(-b*(T-u)).*y.*(exp(theta_y(u)*y)-(y<1)),1e-8,30),u),t,T)...
    %+gamma/b*eta*(1-exp(-b*(T-t)))+sigma*quadgk(@(u)theta_x(u)*exp(-a*(T-u)),t,T);
Theta=@(t,T,a,sigma,theta_x)  sigma*theta_x*(1/a)*(1-exp(a*(t-T))); %% theta solved analitycally with parameters needed

TT1=t12(pp,1);
TT2=t12(pp,2);

X=1;
X_Q=X;
F=@(t,TT1,TT2) quadgk(@(u) Theta(t,u,a,sigma,theta_x),TT1,TT2)+quadgk(@(t)Lambda(t,A,B,C),TT1,TT2)/(TT2-TT1)+X_Q*(exp(-a*TT1)-exp(-a*TT2))/(a*(TT2-TT1));
Fvector(pp)=F(t0,TT1,TT2);


end

end