% LiLa LIDAR Landing Spacecraft Instrument Project

% Written by the behalf of LILA Team

% code structure: Object Oriented
% all lengths are in the SI unit, and agles are in degrees

%% Import Data 
board = arduino(port,board,{,}); 
% lidar = ..;

%% variable
% Public variable
trigger = input('Press any key to start the system'); 
scanDotResulotion = 50; 

% Constant / Initial value 
angle = 0; 
servosGearing = 20/50; 
scannedCount = 0; 
initLoopVar = 1; 

%% Mechanism class 
function runMechnisms(angle) 
topLever = 0;
bottomLever = 0; 
realTopSweep = topLever*servosGearing;
realBottomSweep = bottomLever*servosGearing; 

dataCoor = ones(angle,angle,angle); %height x coor, y coor, height
    
    for i = initLoopVar:angle
%         scan command here
    end 

    function pushCoor = scan(angle,lidarVal)
        angle2length = 2*altitude*atan(angle); 
        xservoPosi = linspace(-angle2length/2,angle2length/2); % [xCoor] (based on angles)
        yservoPosi = linspace(-angle2length/2,angle2length/2); % [yCoor] (based on angles)
        pushCoor = dataCoor(xservoPosi,yservoPosi); 
        
        matchSweep = dataCoor(:,:,lidarVal.height); 
    end

newArrangeTable = dataSim(dataCoor); 
    function comprss = dataSim(matrix)
        comprss = (reshape(matrix,5,4))';
        comprss(2:2:4,:) = fliplr(comprss(2:2:4,:));
    end
    
% visualize
figure1 
heatmap(xServoPosi,yServoPosi,lidarVal.height); 

end

%% Analysis class
function analysis(terrainResponse) 
flatPosi = [];
slopePosi = [];
subValLand = False; 
totalLand = False; 


    function terrainAna()
%         inclinX = diff(dataCoor())/scanDotResulotion
        inclinY = 
        tooSteep = slope > 5 %in deg
        heat3DMap = heatmap(tbl,xvar,yvar);
    end

    function landDecision()
%         tba
    end

end