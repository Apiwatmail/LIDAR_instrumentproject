%% Analysis class
% output:: [landingCoor,scannedCount
terrainResponse = lidarresult;
flatPosi = [];
slopePosi = [];
totalLand = false;   

% ===== table handle  ========
c = 11; r = 11; count = ones(r,c); countOrderBase = 1:c; flipcount = fliplr(countOrderBase); 
dataStore = ones(121,3);

for r = 1:c
    for c = 1:r
        if rem(r,2) == 1
            count(r,c) = countOrderBase(c);
%             disp(count)
        else
            count(r,c) = flipcount(c); 
%             disp(count)
        end
    end
    dataStore(r,1) = r;
end     
count2 = count'; count3 = (count2(:)); 
dataStore(:,2) = count3; 

% use fixCol() to get its interger
repeats = 11;
xCol = repmat(1:11,repeats,1);
xCol = xCol(:); xCol=xCol';
dataStore(:,1) = xCol; 
dataStore(:,3) = lidarresult.VarName1; 
% ===== rearrange ===========
newTable = ones(11,11);
for loc = 1:length(dataStore)
    newTable(dataStore(loc,1),dataStore(loc,2)) = dataStore(loc,3);
end
figure(1)
hm = heatmap(1:11,1:11,newTable);


% ============================
% ======== analysis ===========
% =============================
% [terr ainResponse,planeCheck] = terrainAna(newTable)
X=1:11; Y=1:11; Z = newTable(X,Y);
figure(2)
s = surf(X,Y,Z,'FaceAlpha',0.8,'EdgeColor','interp');
view([-14.0 45.1])
colorbar

function [terrainResponse,planeCheck] = terrainAna(terrainResponse)
    planeCheck = abs(avg(surfnorm(terrainResponse))) <= deg2rad(5); %in deg !Auchtung: the degree might need to be changed 

    landChar = gradient(terrainResponse); 
    for rC = 1:length(arrangedTable) % stone check 
        for cC = 1:length(arrangedTable)           
            rockCheck = 0 <= abs(landChar(rC,cC)) && abs(landChar(rC,cC)) <= 5; %in deg !!Samma anteckning som planeCheck 
            terrainResponse(rC,cC,2) = rockCheck(rC,cC); 
        end 
    end    
end

% % identify the characteristics
% edges = linspace(0,10,2); % Bin edges
% labels = strcat({'Land'},{'Do not Land'}); % Labels for the bins
% categorize = discretize(terrainResponse(:,:,2),'Categorical',labels);
% group = grp2idxCol(categorize); 
% idxColStore = group == 1; 
% landableStore = movsum(idxColStore,5,'Endpoints','discard','omitnan'); 
% 
% % pick data
% % tba 
