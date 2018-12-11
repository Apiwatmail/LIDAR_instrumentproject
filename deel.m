clear all;close all;clc;

a = arduino();
s1=servo(a,'D7','MinPulseDuration',1000*10^-6,'MaxPulseDuration',2000*10^-6);
s2=servo(a,'D8','MinPulseDuration',1000*10^-6,'MaxPulseDuration',2000*10^-6);

configurePin(a,'D2','DigitalOutput'); 
configurePin(a,'D3','DigitalInput'); 
writeDigitalPin(a,'D2',0); % lidar in
lo=readDigitalPin(a,'D3'); % lidar out 
% lo = pulsewidth(clock2, time2, 'Polarity', 'Positive');

zxcv = 1; 
while zxcv <= 50
%     if(lo ~= 0) % If we get a reading that isn't zero, let's print it
        pulse_width = lo/10; % 10usec = 1 cm of distance for LIDAR-Lite
        fprintf('\t\tDistance (cm): %d',pulse_width);
        pause(.02); 
%     end
    zxcv = zxcv + 1; 
end


%% lidar (i2c) 
% lidar = i2cdev(a,'0x62');
% addr = scanI2CBus(a,1)
% lidarWrite = i2cdev(a,'0xc4');
% lidarRead = i2cdev(a,'0xc5');

%% servos
% for i=0:0.2:1
%     writePosition(s1,i);
%     writePosition(s2,i);
%     pause(0.01);
% end
% 
% for j=1:-0.2:0
%     writePosition(s1,j);
%     writePosition(s2,j);
%     pause(0.01);
% end