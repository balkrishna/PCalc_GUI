function [ yearly_energy ] = calculate_energy(yearly_wind_data,input_wind_direction,power_curve )
%CALCULATE_ENERGY Calculates yearly energy in kWh based on wind distribution and turbine
% power curve.
%   yearly_wind_data is a 365x3 matrix of yearly_wind_data(..,1) ,
%   yearly_wind_data with acceleration(..,2) and measured wind
%   direction(..,3)
%   
%   wind_direction is the input wind direction
%   power curve is the array of power for considered turbine.

%DAYS IN A YEAR
days_in_a_year = 365;

%HOURS IN A DAY
hours_in_a_day = 24;

%% Useful wind speed estimation

%Useful wind speed is the estimated wind speed reaching the turbine. This
%assumes primitive ways to estimate wake losses, blockage,etc.
useful_wind_speed=zeros(days_in_a_year,1);

%This loop estimates the wind reaching the turbine. If the turbine is
%aligned in the favourable direction +/- 45 degrees, maximum wind reaches
%the turbine. Else it is assumed that there is a 25% loss in the wind speed
%reaching the turbine. This loss is accounted for in the loss due to wake
%effects.

%Losses due to wake effects
loss_wake=0.75;

for i=1:days_in_a_year
    if yearly_wind_data(i,3)<input_wind_direction+45 && yearly_wind_data(i,3)>input_wind_direction-45
        useful_wind_speed(i,1)=yearly_wind_data(i,2);
    else
        useful_wind_speed(i,1)=loss_wake*yearly_wind_data(i,1);
    end
end

%% Distribution_matrix
%This matrix categorises the wind speed into different
%bins. Each bin has a range of 1 m/s. 19 bins are considered with the
%following values: 
%bin1 = 0-1 m/s,bin2 = 1-2m/s, bin3 = 3-4m/s, .... , bin19=18m/s+ 
NBINS=19;
distribution_matrix=zeros(days_in_a_year,NBINS);

% Making bins
for i=1:days_in_a_year
    temp_wind_speed=useful_wind_speed(i,1);
    if temp_wind_speed >=0 && temp_wind_speed < 1
        distribution_matrix(i,1)=hours_in_a_day;
    elseif temp_wind_speed >=1 && temp_wind_speed < 2
        distribution_matrix(i,2)=hours_in_a_day;
    elseif temp_wind_speed >=2 && temp_wind_speed < 3
        distribution_matrix(i,3)=hours_in_a_day;
    elseif temp_wind_speed >=3 && temp_wind_speed < 4
        distribution_matrix(i,4)=hours_in_a_day;
    elseif temp_wind_speed >=4 && temp_wind_speed < 5
        distribution_matrix(i,5)=hours_in_a_day;
    elseif temp_wind_speed >=5 && temp_wind_speed < 6
        distribution_matrix(i,6)=hours_in_a_day;
    elseif temp_wind_speed >=6 && temp_wind_speed < 7
        distribution_matrix(i,7)=hours_in_a_day;
    elseif temp_wind_speed >=7 && temp_wind_speed < 8
        distribution_matrix(i,8)=hours_in_a_day;
    elseif temp_wind_speed >=8 && temp_wind_speed < 9
        distribution_matrix(i,9)=hours_in_a_day;
    elseif temp_wind_speed >=9 && temp_wind_speed < 10
        distribution_matrix(i,10)=hours_in_a_day;
    elseif temp_wind_speed >=10 && temp_wind_speed < 11
        distribution_matrix(i,11)=hours_in_a_day;
    elseif temp_wind_speed >=11 && temp_wind_speed < 12
        distribution_matrix(i,12)=hours_in_a_day;
    elseif temp_wind_speed >=12 && temp_wind_speed < 13
        distribution_matrix(i,13)=hours_in_a_day;
    elseif temp_wind_speed >=13 && temp_wind_speed < 14
        distribution_matrix(i,14)=hours_in_a_day;
    elseif temp_wind_speed >=14 && temp_wind_speed < 15
        distribution_matrix(i,15)=hours_in_a_day;
    elseif temp_wind_speed >=15 && temp_wind_speed < 16
        distribution_matrix(i,16)=hours_in_a_day;
    elseif temp_wind_speed >=16 && temp_wind_speed < 17
        distribution_matrix(i,17)=hours_in_a_day;
    elseif temp_wind_speed >=17 && temp_wind_speed < 18
        distribution_matrix(i,18)=hours_in_a_day;
    else
        distribution_matrix(i,19)=hours_in_a_day;
    end
end

%% Calculating Energy (kWh)

% To calculate energy, the wind speed distribution and the turbine power
% curve are taken into account as follows: 
% daily_generated_energy = hours_in_a_day x turbine_power

yearly_energy = zeros(1,365);

for i = 1:days_in_a_year
    daily_generated_energy = 0;
    %loop through the distribution matrix
    for j=1:NBINS
        daily_generated_energy=daily_generated_energy+distribution_matrix(i,j)*power_curve(j);
    end
    yearly_energy(1,i) = daily_generated_energy;
    
end

end

