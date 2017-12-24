function [ city_wind_data ] = get_wind_data( city_name )
%get_wind_data Parse from wind data file.
%   This function parses the input data file. The file is located in the
%   ./Input/Wind folder. It returns city_wind_data a 365x3 array with
%   date,wind_speed,wind_direction as its columns.

%Read file. Assumption that the file data has 365 rows and is named as
%city_name.txt city_name has the name of the city with the first letter in
%capital. This is format sensitive. Take appropriate care.
city_file_name=['./Input/Wind/',city_name{1},'.txt'];
fcity_name=fopen(city_file_name);
city_wind_data = textscan(fcity_name,'%s%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%*f%*f%*f%*s%f','HeaderLines',1,'Delimiter',',');

end
