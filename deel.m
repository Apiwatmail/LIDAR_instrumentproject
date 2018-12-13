clear all;close all;clc;

a = arduino();
s1=servo(a,'D7','MinPulseDuration',1200*10^-6,'MaxPulseDuration',1500*10^-6);
s2=servo(a,'D8','MinPulseDuration',1400*10^-6,'MaxPulseDuration',1800*10^-6);
lo = [];
fs=15e3;
configurePin(a,'D2','DigitalOutput'); 
configurePin(a,'D3','DigitalInput'); 
writeDigitalPin(a,'D2',0); % lidar in
asdf=readDigitalPin(a,'D3')
% % lo=readDigitalPin(a,'D3'); % lidar out 
% % width =pulsewidth(readDigitalPin(a,'D3'),fs,'StateLevels',5) 
% % StateLevelslo = pulsewidth(lo, fs, 'StateLevels', 'high')
% 
% zxcv = 1; 
% while zxcv <= 50
%     if(readDigitalPin(a,'D3') ~= 0) % If we get a reading that isn't zero, let's print it
%         pulse_width = pulsewidth(readDigitalPin(a,'D3')) /10; % 10usec = 1 cm of distance for LIDAR-Lite
%         fprintf('\t\tDistance (cm): %d',pulse_width);
%         pause(.02); 
%     end
%     zxcv = zxcv + 1; 
% end


%% lidar (i2c) 
% lidar = i2cdev(a,'0x62');
% addr = scanI2CBus(a,1)
% lidarWrite = i2cdev(a,'0xc4');
% lidarRead = i2cdev(a,'0xc5');

%% servos
% for i=0.3:0.2:.7
%     writePosition(s1,i);
%     writePosition(s2,i);
%     pause(.1);
% end
% 
% for j=.7:-0.2:0.3
%     writePosition(s1,j);
%     writePosition(s2,j);
%     pause(.1);
% end