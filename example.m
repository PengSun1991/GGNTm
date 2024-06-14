%example
load("modelData.mat");
global modelP1 modelP2 modelP3 modelP4 BL;
lat=45.5;
lon=117.5;
h=1000;
doy=100;
Tm=GGNTm(doy,lat,lon,h);