function [ monthly_solar_energy,total_panels ] = calculate_solar_energy( city_name,side_edges,fb_edges,length_unit,width_unit)
%calculate_solar_energy Calculate Solar Energy from solar data.
%   Read solar data
%   Calculate effective area based on inputs
%   Calculate total solar energy
% Returns
monthly_solar_energy=zeros(1,12);

%% Get Data
%Read file. Assumption that the file data has 12 rows and is named as
%city_name.txt city_name has the name of the city with the first letter in
%capital. This is format sensitive. Take appropriate care.
city_file_name=['./Input/Solar/',city_name,'.txt'];
fcity_name=fopen(city_file_name);
solar_data = textscan(fcity_name,'%f','HeaderLines',1,'Delimiter','\n');
monthly_solar_insolation=solar_data{1,1}'; %1x12 array of monthly solar insolation.

%% Geometric parameters
n_racks = floor(width_unit/3.6);  % Calculate number of racks
n_pv_rows = 6;                % Number of pv rows
n_units = floor(length_unit/7.2);  % Number of units
total_panels = n_units*n_racks*2*n_pv_rows + n_racks*2*side_edges + n_units*4*fb_edges; %Number of panels
single_panel_area=1.64*1;
total_area = total_panels * single_panel_area;

%Days in a month
days=[31 28 31 30 31 30 31 31 30 31 30 31];

%Efficiencies
eta_panel=0.174;    %Panel Efficiency
eta_PF=0.9;         %Solar Power Factor
eta_system=0.956;   %System Efficiency
eta_overall=eta_panel*eta_PF*eta_system; %Overall efficiency as a product of indiv efficiencies

for i=1:length(days)
    monthly_solar_energy(1,i)=monthly_solar_insolation(1,i)*days(i)*total_area*eta_overall;
end


end

