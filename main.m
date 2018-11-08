% LiLa Project

%% variable
% public var
trigger = input('Press any key to start the system'); 

board = arduino(port,board,{,}); 
% lidar = ..;

angle = 0; 
servosGearing = 20/50; 
scannedCount = 0; 


%%Mechanism class 
function runMechnisms(angle) 
topLever = 0;
bottomLever = 0; 
realTopSweep = topLever*servosGearing;
realBottomSweep = bottomLever*servosGearing;

    function rotateServos(angle)
        coorInit = 1:250; %[position handle]
        servoPosi = []; % [xCoor; yCoor] (based on angles)
        matchSweep = [coorInit; servoPosi]; 
%         sweep
endtt

    function lidarControl()
%         runLidar
%         tba
    end

end

%% Analysis class
function analysis(terraingResponse) 
flatPosi = [];
slopePosi = [];
subValLand = False; 
totalLand = False; 

    function terrainAna()
        heat3DMap = heatmap(tbl,xvar,yvar);
%         tba
    end

    function landDecision()
%         tba
    end

end