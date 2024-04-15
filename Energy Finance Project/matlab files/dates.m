function [fwd] = dates(fwd,t0)

fwd.T1 = nan(height(fwd),1);
fwd.T2 = nan(height(fwd),1); % initialization
%%Monthly
    fwd.T1(1)=datenum(2022,12,01);
    fwd.T2(1)=datenum(2022,12,31);

    fwd.T1(2)=datenum(2023,01,01);
    fwd.T2(2)=datenum(2023,01,31);

    fwd.T1(3)=datenum(2023,02,01);
    fwd.T2(3)=datenum(2028,02,28);

    fwd.T1(4)=datenum(2023,03,01);
    fwd.T2(4)=datenum(2023,03,31);

    fwd.T1(5)=datenum(2023,04,01);
    fwd.T2(5)=datenum(2023,04,30);

    fwd.T1(6)=datenum(2023,05,01);
    fwd.T2(6)=datenum(2023,05,31);

     fwd.T1(7)=datenum(2023,06,01);
    fwd.T2(7)=datenum(2023,06,30);

%%QUARTERLY
    fwd.T1(8)=datenum(2023,1,01);
    fwd.T2(8)=datenum(2023,3,31);

    fwd.T1(9)=datenum(2023,4,01);
    fwd.T2(9)=datenum(2023,06,30);

    fwd.T1(10)=datenum(2023,07,01);
    fwd.T2(10)=datenum(2023,09,30);

    fwd.T1(11)=datenum(2023,10,01);
    fwd.T2(11)=datenum(2023,12,31);

    fwd.T1(12)=datenum(2024,01,01);
    fwd.T2(12)=datenum(2024,03,31);

    fwd.T1(13)=datenum(2024,04,01);
    fwd.T2(13)=datenum(2024,06,30);

    fwd.T1(14)=datenum(2024,07,01);
    fwd.T2(14)=datenum(2024,09,30);

%%Annually
    fwd.T1(15)=datenum(2023,01,01);
    fwd.T2(15)=datenum(2023,12,31);

    fwd.T1(16)=datenum(2024,01,01);
    fwd.T2(16)=datenum(2024,12,31);

    fwd.T1(17)=datenum(2025,01,01);
    fwd.T2(17)=datenum(2025,12,31);

    fwd.T1(18)=datenum(2026,01,01);
    fwd.T2(18)=datenum(2026,12,31);

    fwd.T1(19)=datenum(2027,01,01);
    fwd.T2(19)=datenum(2027,12,31);

    fwd.T1(20)=datenum(2028,01,01);
    fwd.T2(20)=datenum(2028,12,31);

%%create it with only delta lags

fwd.T1LAG = nan(height(fwd),1);
fwd.T2LAG = nan(height(fwd),1); % initialization

%%Monthly
    fwd.T1LAG(1)=datenum(2022,12,01)-t0;
    fwd.T2LAG(1)=fwd.T1LAG(1)+30;

    fwd.T1LAG(2)=datenum(2023,01,01)-t0;
    fwd.T2LAG(2)=fwd.T1LAG(2)+30;

    fwd.T1LAG(3)=datenum(2023,02,01)-t0;
    fwd.T2LAG(3)=fwd.T1LAG(3)+30;

    fwd.T1LAG(4)=datenum(2023,03,01)-t0;
    fwd.T2LAG(4)=fwd.T1LAG(4)+30;

    fwd.T1LAG(5)=datenum(2023,04,01)-t0;
    fwd.T2LAG(5)=fwd.T1LAG(5)+30;

    fwd.T1LAG(6)=datenum(2023,05,01)-t0;
    fwd.T2LAG(6)=fwd.T1LAG(6)+30;

    fwd.T1LAG(7)=datenum(2023,06,01)-t0;
    fwd.T2LAG(7)=fwd.T1LAG(7)+30;
 %%Quarterly

    fwd.T1LAG(8)=datenum(2023,1,01)-t0;
    fwd.T2LAG(8)=fwd.T1LAG(8)+90;

    fwd.T1LAG(9)=datenum(2023,4,01)-t0;
    fwd.T2LAG(9)=fwd.T1LAG(9)+90;

    fwd.T1LAG(10)=datenum(2023,07,01)-t0;
    fwd.T2LAG(10)=fwd.T1LAG(10)+90;

    fwd.T1LAG(11)=datenum(2023,10,01)-t0;
    fwd.T2LAG(11)=fwd.T1LAG(11)+90;

    fwd.T1LAG(12)=datenum(2024,01,01)-t0;
    fwd.T2LAG(12)=fwd.T1LAG(12)+90;

    fwd.T1LAG(13)=datenum(2024,04,01)-t0;
    fwd.T2LAG(13)=fwd.T1LAG(13)+90;

    fwd.T1LAG(14)=datenum(2024,07,01)-t0;
    fwd.T2LAG(14)=fwd.T1LAG(14)+90;

%%Annually

    fwd.T1LAG(15)=datenum(2023,01,01)-t0;
    fwd.T2LAG(15)=fwd.T1LAG(15)+365;

    fwd.T1LAG(16)=datenum(2024,01,01)-t0;
    fwd.T2LAG(16)=fwd.T1LAG(16)+365;

    fwd.T1LAG(17)=datenum(2025,01,01)-t0;
    fwd.T2LAG(17)=fwd.T1LAG(17)+365;

    fwd.T1LAG(18)=datenum(2026,01,01)-t0;
    fwd.T2LAG(18)=fwd.T1LAG(18)+365;

    fwd.T1LAG(19)=datenum(2027,01,01)-t0;
    fwd.T2LAG(19)=fwd.T1LAG(19)+365;

    fwd.T1LAG(20)=datenum(2028,01,01)-t0;
    fwd.T2LAG(20)=fwd.T1LAG(20)+365;


end











