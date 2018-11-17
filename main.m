% LiLa LIDAR Landing Spacecraft Instrument Project

% Written by the behalf of LILA Team

% code structure: Object Oriented
% all lengths are in the SI unit, and agles are in degrees

%% Import Data 
% board = arduino(sort,board,{real,real});
% lidar = board.something..;

%% variable
% Public variable
trigger = input('Press any key to start the system'); 
scanDotResulotion = 50; 
stepNum = input('Insert the number of steps and press enter!')

% Constant / Initial value 
angle = 0; 
servosGearing = 20/50; 
scannedCount = 0; 
initLoopVar = 1; 
topLever = [0 1];
bottomLever = [0 1]; 

%% Operational class 
[dataCoor,arrangedTable] = runMechnisms(angle); 
landingCoor = analysis(arrangedTable); 

%% Mechanism class 


function [dataCoor,arrangedTable] = runMechnisms(angle) 
    % create servo position table
    dataCoor = ones(angle,angle,angle); %x coor, y coor, height
    angle2length = 2*altitude*atand(angle);

    subcolPosi = angle2length; countBase = 1:subcolPosi; flipBase = fliplr(countBase); 
    Posi = ones(subcolPosi,subcolPosi); 
    
    for r = 1:subcolPosi % create column position scan
        for c = 1:subcolPosi
            if rem(r,2) == 1
                Posi(r,c) = countBase(c); 
            else
                Posi(r,c) = flipBase(c); 
            end
        end
    end
    Posi = Posi'; Posi = Posi(:); dataCoor(:,2)=Posi; 
    rowPosi = repmat(1:subcolPosi,c,1); dataCoor(:,1) = rowPosi(:)';

    % send control to servos
    subPosi = linspace(-angle2length/2,angle2length/2,stepNum);
    realTopSweep = topLever*servosGearing;
    realBottomSweep = bottomLever*servosGearing; 

    for count = 1:length(dataCoor(:,1))
        dataCoor(count,3) = scan(realTopSweep,realBottomSweep); % get lidar altitude value 
    end
    
    function pushCoor = scan(topSweep,bottomSweep) %Obs! Behöver att byte 
        lidar(topSweep); % row direction 
        lidar(bottomSweep); % column direction 
        pushCoor = lidar.height; 
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
function landingCoor = analysis(terrainResponse) 
flatPosi = [];
slopePosi = [];
% subValLand = False; 
totalLand = False; 

    function terrainAna(terrainResponse)
        planeCheck = abs(avg(surfnorm(terrainResponse))) < 5; %in deg 

        for rC = 1:length(arrangedTable) % stone check 
            for cC = 1:length(arrangedTable)
                landChar = gradient(terrainResponse(rC,cC)); 
                rockCheck = 0 <= abs(landChar) && abs(landChar) <= 5; %in deg
                terrainResponse(rC,cC,2) = rockCheck; 
            end 
        end 
        
    end

    function landDecision()
%         tba
    end

end