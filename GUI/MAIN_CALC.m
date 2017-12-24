function [ monthly_energy_dist,direction_max_yearly_energy,angle_max_yearly_energy,max_yearly_energy,success ] = MAIN_CALC(city_wind_data,height,roughness,orientation_id,power_curve,acceleration)
%MAIN_CALC This function calculates expected power output.
%   Get city_wind_data, roughness, and height as input.
%   city_wind_data is a 365x3 array with date,wind_speed,wind_direction
%   as input.
%   Extrapolate the data to get yearly_wind_data
%   Get the turbine power curve
%   Estimate yearly and monthly power outputs.
%   Written by Balkrishna Patankar, (c) IBIS Power 2017 

%% Extrapolate wind data
% Wind data extrapolated as per the profile mentioned in http://wind-data.ch/tools/profile.php
% Assumptions, all measurements done at a height href = 10m at the airport.
% Surface roughness of the airport zref = 0.055
zref=0.055; href=10;
%Uref is second column of city_wind_data
%city_wind_data is in km/h. To convert to m/s it is multiplied by 10/36
uref=city_wind_data{2}*10/36;
%U is the extrapolated wind speed. Only when the height is more than 200m
%is the power law incorporated.For the power law, b=0.8, alpha=0.11
b=0.8; alpha=0.11;
if height < 200
    u=uref.*log((height+roughness)/roughness)/log((href+zref)/zref);
else
    u=uref.*(b*(height/href)^alpha);
end
%Make yearly wind data array
%   yearly_wind_data is a 365x3 matrix of yearly_wind_data(..,1) ,
%   yearly_wind_data with acceleration(..,2) and 
%   measured wind direction(..,3)
yearly_wind_data(:,1)   =   u;
yearly_wind_data(:,2)   =   u.*acceleration;
yearly_wind_data(:,3)   =   city_wind_data{3};
%Correct wind directions
%For wind direction if dirn < 180, dirn else dirn=dirn-360

for i=1:length(yearly_wind_data(:,3))
    if yearly_wind_data(i,3)<180
        yearly_wind_data(i,3)=yearly_wind_data(i,3);
    else
        yearly_wind_data(i,3)=yearly_wind_data(i,3)-360;
    end
end


%% Estimate energy for different directions
%   Calls calculate_energy to calculate daily energy for different
%   directions.

%Angles   N      NE      E        SE         S         NW        W
angles = [0 22.5 45 67.5 90 112.5 135 157.5 180 -22.5 -45 -67.5 -90 -112.5 -135 -157.5];
direction_name={'N','NNE','NE','ENE','E','ESE','SE','SSE','S','NNW','NW','WNW','W','WSW','SW','SSW'};
%Energy calculated assuming turbine is oriented towards the angle
%This array gives the daily output for all angles considered
energy_angles = zeros(16,365);
la=length(angles);

for j=1:la
    energy_angles(j,:) = calculate_energy(yearly_wind_data, angles(j), power_curve);
end

%% Find angle corresponding to max energy
sum_energy_angle=zeros(16,1);

for j=1:la
    sum_energy_angle(j,1)=sum(energy_angles(j,:));
end

[max_yearly_energy, id_max_angle] = max(sum_energy_angle);
angle_max_yearly_energy=angles(id_max_angle);
direction_max_yearly_energy=direction_name(id_max_angle);
%% Monthly distribution corresponding to input angle
monthly_energy_dist=zeros(1,12);
%Total energy per month
monthly_energy_dist(1,1)=sum(energy_angles(orientation_id,1:31));   %January day 1 to 31
monthly_energy_dist(1,2)=sum(energy_angles(orientation_id,32:59));   %February day 32 to 59
monthly_energy_dist(1,3)=sum(energy_angles(orientation_id,60:90));   %March day 60 to 90
monthly_energy_dist(1,4)=sum(energy_angles(orientation_id,91:120));   %April day 91 to 120
monthly_energy_dist(1,5)=sum(energy_angles(orientation_id,121:151));   %May day 121 to 151
monthly_energy_dist(1,6)=sum(energy_angles(orientation_id,152:181));   %June day 152 to 181
monthly_energy_dist(1,7)=sum(energy_angles(orientation_id,182:212));   %July day 182 to 212
monthly_energy_dist(1,8)=sum(energy_angles(orientation_id,213:243));   %August day 213 to 243
monthly_energy_dist(1,9)=sum(energy_angles(orientation_id,244:273));   %September day 244 to 273
monthly_energy_dist(1,10)=sum(energy_angles(orientation_id,274:304));  %October day 274 to 304
monthly_energy_dist(1,11)=sum(energy_angles(orientation_id,305:334));  %November day 305 to 334
monthly_energy_dist(1,12)=sum(energy_angles(orientation_id,335:365));  %December day 335 to 365
       


%% Success or Failure
success=1;

end
