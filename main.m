% LiLa LIDAR Landing Spacecraft Instrument Project

% Written by the behalf of LILA Team

% code structure: Object Oriented
% all lengths are in the SI unit, and agles are in degrees

%% Import Data 
board = arduino(port,board,{,}); 
% lidar = board.something..;

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
function dataCoor = runMechnisms(angle) 
topLever = 0;
bottomLever = 0; 
realTopSweep = topLever*servosGearing;
realBottomSweep = bottomLever*servosGearing; 

dataCoor = ones(angle,angle,angle); %x coor, y coor, height
angle2length = 2*altitude*atand(angle);

subcolPosi = angle2length; countBase = 1:subcolPosi; flipBase = fliplr(countBase); 
Posi = ones(subrowPosi,subcolPosi); 
    for r = 1:subcolPosi % create column position scan
        for c = 1:subcolPosi
            if rem(r,2) == 1
                Posi(r,c) = countBase(c); 
            else
                Posi(r,c) = flipBase(c); 
            end
        end
    end
    rowPosi = repmat(1:subcolPosi,c,1); dataCoor = rowPosi(:)';
    Posi = Posi'; Posi = Posi(:); dataCoor(:,2)=Posi; 
        
    function pushCoor = scan(angle,lidarVal)
         
        xservoPosi = linspace(-angle2length/2,angle2length/2); % [xCoor] (based on angles); act as an counter
        yservoPosi = linspace(-angle2length/2,angle2length/2); % [yCoor] (based on angles); act as an counter
        
        dictateDirection = 
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