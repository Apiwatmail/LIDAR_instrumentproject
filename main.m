% LiLa LIDAR Landing Spacecraft Instrument Project

% Written by the behalf of LILA Team

% code structure: Object Oriented Programming 
% all distances are in the SI unit, and agles are in degrees

clc,clear,close all 

%% Import Data and set up devices 
% board = arduino(sort,board,{real,real});
% arduBoard = arduino();
% s1=servo(arduBoard,'D7','MinPulseDuration',1000*10^-6,'MaxPulseDuration',2000*10^-6);
% s2=servo(arduBoard,'D8','MinPulseDuration',1000*10^-6,'MaxPulseDuration',2000*10^-6);

% lidar = board.something..;

%% variable
% Public variable
trigger = input('Press any key to start the system'); 

global scanDotResulotion stepNum servosGearing topLever bottomLever scanAltitude 
global angle scannedCount initLoopVar

scanDotResulotion = 50; 
stepNum = 125; 
servosGearing = 50/20; 
topLever = [0 1];
bottomLever = [0 1]; 
scanAltitude = [36000 18000 2700]; % in m
 
%Initial value 
angle = [6 6 20]; 
scannedCount = 0; 
initLoopVar = 1; 

%% Operational class 
[dataCoor,arrangedTable] = runMechnisms(angle,scanAltitude); 
% while scannedCount < 3
%     [landingCoor,scannedCount] = analysis(terrainResponse); 
% end

%% Mechanism class 
function [dataCoor,arrangedTable] = runMechnisms(angle,scanAltitude) 
global servosGearing topLever bottomLever stepNum 
    % create servo position table
    dataCoor = ones(stepNum^2,3); %x coor, y coor, height
    angle2length = 2*scanAltitude*tand(angle(1)/2); 

    subcolPosi = angle2length(1); 
    countBase = linspace(1,subcolPosi,stepNum); flipBase = fliplr(countBase); 
    Posi = ones(stepNum,stepNum); 
    servoPosi = linspace(0,1,stepNum);
    
    % send control to servos ===== beh�ver f�r betyder ============   
    realTopSweep = topLever*servosGearing;
    realBottomSweep = bottomLever*servosGearing; 
    
    for r = 1:stepNum % create column position scan
        for c = 1:stepNum
            if rem(r,2) == 1
                Posi(r,c) = countBase(c); 
                writePosition(s1,servoPosi(r));
                writePosition(s2,servoPosi(c));
%                 dataCoor(count,3) = lidar.height; % get lidar altitude
%                 value <<< tempDataCoor 1st?? 
                pause(.01)
            else
                Posi(r,c) = flipBase(c); 
                writePosition(s1,servoPosi(r));
                writePosition(s2,servoPosi(c));
%                 dataCoor(count,3) = lidar.height; % get lidar altitude value
                pause(.01) 
            end
        end
    end
    Posi = Posi'; Posi = Posi(:); dataCoor(:,2)=Posi;    
    rowPosi = repmat(countBase,c,1); dataCoor(:,1) = rowPosi(:)';

    % ==============================================
    for count = 1:length(dataCoor(:,1))
        dataCoor(count,3) = lidar.height; % get lidar altitude value 
    end

arrangedTable = ones(125,125); 
for localCount = 1:length(dataCoor)
    arrangedTable(dataCoor(localCount,1),dataCoor(localCount,2)) = dataCoor(localCount,3)
end
    
% visualize
figure1 
heatmap(dataCoor(:,1),dataCoor(:,2),dataCoor(:,3))

end

%% Analysis class
function [landingCoor,scannedCount] = analysis(terrainResponse) 
flatPosi = [];
slopePosi = [];
totalLand = False; 

    function [terrainResponse,planeCheck] = terrainAna(terrainResponse)
        planeCheck = abs(avg(surfnorm(terrainResponse))) <= 5; %in deg !Auchtung: the degree might need to be changed 
         
        landChar = gradient(terrainResponse); 
        for rC = 1:length(arrangedTable) % stone check 
            for cC = 1:length(arrangedTable)           
                rockCheck = 0 <= abs(landChar(rC,cC)) && abs(landChar(rC,cC)) <= 5; %in deg !!Samma anteckning som planeCheck 
                terrainResponse(rC,cC,2) = rockCheck(rC,cC); 
            end 
        end    
    end

    % identify the characteristics
    edges = linspace(0,10,2); % Bin edges
    labels = strcat({'Land'},{'Do not Land'}); % Labels for the bins
    categorize = discretize(terrainResponse(:,:,2),'Categorical',labels);
    group = grp2idx(categorize); 
    idxStore = group == 1; 
    landableStore = movsum(idxStore,5,'Endpoints','discard','omitnan'); 
    
    % pick data
    % tba

scannedCount = scannedCount + 1; 
end