function [Tm]=GGNTm(doy,lat,lon,h)
%This is a sample matlab function for calculating Tm using GGNTm model
%contact Peng Sun:sunpcxs@gmail.com if necessary (questons or reporting bugs).
%inputs:
%doy:day of year
%lat:latitude of user site (degree [-90°  90°])
%lon:longitude of user site  (degree [0°  360°))
%h: ellipsoidal height of user site （m）

%output:Tm value of user site （K）

global modelP1 modelP2 modelP3 modelP4 BL;
if rem(lat,1)==0 && rem(lon,1)==0 %at the grid points
    index=floor(90-lat)*360+floor(lon)+1;
else
    if(lon<359)
        index1=floor(90-lat)*360+floor(lon)+1;
        index2=index1+1;
        index3=index1+360;
        index4=index1+361;
    else
        index1=floor(90-lat)*360+floor(lon)+1;
        index2=floor(90-lat)*360+1;
        index3=index1+360;
        index4=index2+360;
    end
    index=[index1 index2 index3 index4];
    Bg=BL(index,1);
    Lg=BL(index,2);
    
    B1=Bg(1);
    L1=Lg(1);
    %weight
    d1=sqrt((lon-L1)^2+(lat-B1)^2);
    d2=sqrt((lon-L1-1)^2+(lat-B1)^2);
    d3=sqrt((lon-L1)^2+(lat-B1+1)^2);
    d4=sqrt((lon-L1-1)^2+(lat-B1+1)^2);
    Q1=(1/d1)/(1/d1+1/d2+1/d3+1/d4);
    Q2=(1/d2)/(1/d1+1/d2+1/d3+1/d4);
    Q3=(1/d3)/(1/d1+1/d2+1/d3+1/d4);
    Q4=(1/d4)/(1/d1+1/d2+1/d3+1/d4);
end

%grid parameter
cosyP1=cos((doy-modelP1(index,3))*2*pi/365.25);
coshyP1=cos((doy-modelP1(index,5))*4*pi/365.25);
P1=modelP1(index,1)+modelP1(index,2).*cosyP1+modelP1(index,4).*coshyP1;

cosyP2=cos((doy-modelP2(index,3))*2*pi/365.25);
coshyP2=cos((doy-modelP2(index,5))*4*pi/365.25);
P2=modelP2(index,1)+modelP2(index,2).*cosyP2+modelP2(index,4).*coshyP2;

cosyP3=cos((doy-modelP3(index,3))*2*pi/365.25);
coshyP3=cos((doy-modelP3(index,5))*4*pi/365.25);
P3=modelP3(index,1)+modelP3(index,2).*cosyP3+modelP3(index,4).*coshyP3;

cosyP4=cos((doy-modelP4(index,3))*2*pi/365.25);
coshyP4=cos((doy-modelP4(index,5))*4*pi/365.25);
P4=modelP4(index,1)+modelP4(index,2).*cosyP4+modelP4(index,4).*coshyP4;
if rem(lat,1)==0 && rem(lon,1)==0 %at the grid points
    p=[P1 P2 P3 P4];
    Tm=polyval(p,h/1000);
else
    for i=1:4
        p=[P1(i) P2(i) P3(i) P4(i)];
        Tmgrid(i)=polyval(p,h/1000);
    end
    Tm=[Q1 Q2 Q3 Q4]*Tmgrid';
end
end