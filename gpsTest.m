%% Clean up workspace
clear
clc

%% Access cvs data
% File path and name
filePath = 'FOLDER NAME'; % change foldername and files
fileName1 = 'gpsONLY.csv';
fileName1 = 'gps720.csv';


data = readmatrix(fullfile(filePath, fileName1));
time = data(:, 1);
lat = data(:, 2);
lon = data(:, 3);

lat = dm2degrees([floor(lat/100), rem(lat, 100)]);
lon = dm2degrees([floor(lon/100), rem(lon, 100)]);
figure()
geoplot(lat,lon);


% 90:315 320:650 655:915/885
start2 = [90; 320; 655];
end2 = [315; 650; 915];

figure();
hold on
lld = zeros(3,1);

for j = 1:3
    startEndSample = 5;

    gps_t1 = time(90:315);
    gps_lon1 = lon(90:315);
    gps_lat1 = lat(90:315);

    gps_t2 = time(start2(j):end2(j));
    gps_lon2 = lon(start2(j):end2(j));
    gps_lat2 = lat(start2(j):end2(j));

    

    si = 1;
    ei = 1;
    sDiff = 1000;
    eDiff = 1000;
    
    
    for i = 1:startEndSample
        tempSDiff = (gps_lon1(i) - gps_lon2(i))^2 + (gps_lat1(i) - gps_lat2(i))^2;
        if tempSDiff < sDiff
            si = i;
            sDiff = tempSDiff;
        end
    
        tempEDiff = (gps_lon1(end-i+1) - gps_lon2(end-i+1))^2 + (gps_lat1(end-i+1) - gps_lat2(end-i+1))^2;
        if tempEDiff < eDiff
            ei = i;
            eDiff = tempEDiff;
        end
    end
    
    gps_t1 = gps_t1(si: end-ei+1);
    gps_lon1 = gps_lon1(si: end-ei+1);
    gps_lat1 = gps_lat1(si: end-ei+1);
    gps_t2 = gps_t2(si: end-ei+1);
    gps_lon2 = gps_lon2(si: end-ei+1);
    gps_lat2 = gps_lat2(si: end-ei+1);
    
    gps_lon22 = interp1(gps_t2, gps_lon2, gps_t1 ,'linear','extrap');
    gps_lat22 = interp1(gps_t2, gps_lat2, gps_t1 ,'linear','extrap');
    
    lonlatDiff = 0;
    for i = 1:length(gps_t1)
        lonlatDiff = lonlatDiff + (gps_lon1(i) - gps_lon22(i))^2 + (gps_lat1(i) - gps_lat22(i))^2;
    end
    lld(j) = 1000000*lonlatDiff/length(gps_t1);
    
    plot(gps_lon2,gps_lat2);
    axis([121.084 121.0858 14.6648 14.6664]);
    %plot(gps_lon2(1),gps_lat2(1),'o','MarkerSize', 5, "LineWidth", 2);
    %plot(gps_lon2(end),gps_lat2(end),'o','MarkerSize', 15, "LineWidth", 2);
end
lld
%legend('Path 1', 'Start 1', 'End 1', 'Path 2', 'Start 2', 'End 2','Path 3', 'Start 3', 'End 3');
plot(gps_lon1(1),gps_lat1(1),'o','MarkerSize', 20, "LineWidth", 2)
legend('Path 1', 'Path 2', 'Path 3', 'Start/End point');


