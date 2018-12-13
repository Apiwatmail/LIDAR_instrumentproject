clc,clear 
%% Open the text file.
fileID = fopen('C:\Users\joe_a\Desktop\lidar result.txt','r','n','UTF-8');
fseek(fileID, 3, 'bof');
dataArray = textscan(fileID,'%f%C%[^\n\r]','Delimiter',' ','MultipleDelimsAsOne',true,'TextType','string','ReturnOnError',false);
fclose(fileID);
lidarresult = table(dataArray{1:end-1}, 'VariableNames', {'VarName1','cm'});
clearvars fileID dataArray ans;
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
figure
hm = heatmap(1:11,1:11,newTable);


% ============================
% ======== analysis ===========
% =============================
% [terr ainResponse,planeCheck] = terrainAna(newTable)
X=1:11; Y=1:11; Z = newTable(X,Y);
figure
s = surf(X,Y,Z,'FaceAlpha',0.8,'EdgeColor','interp');
view([-14.0 45.1])
colorbar

% function [terrainResponse,planeCheck] = terrainAna(terrainResponse)
    planeCheck = abs(mean(surfnorm(newTable))) <= deg2rad(5); %in deg  

    landChar = gradient(newTable); 
    rockCheck=ones(11,11);
    for rC = 1:length(newTable) % stone check 
        for cC = 1:length(newTable)           
            rockCheck(rC,cC) = deg2rad(0) <= abs(landChar(rC,cC)) && abs(landChar(rC,cC)) <= deg2rad(5); %in deg
        end 
    end    
% end

% identify the characteristics
edges = 0:.5:1; % Bin edges
labels = {'Do not Land','Land'}; % Labels for the bins
categorizeLabl = discretize(rockCheck,edges,'Categorical',labels);
landableStoreR = movsum(rockCheck,3,1,'Endpoints','discard'); 
[idRow1,idCol1] = find(landableStoreR==3); 
landableStoreC = movsum(rockCheck,3,2,'Endpoints','discard'); 
[idRow2,idCol2] = find(landableStoreC==3); 
index1 = [idRow1 idCol1];
index2 = [idRow2 idCol2];

[res,ia,~]=unique(index1,'rows');
[res2,ia2,~]=unique(index2,'rows');
join=intersect(res,res2,'rows');
landCoor=join((join(:,1)>1),:)

% [C,ia,ic] = unique(col);
% a_counts = accumarray(ic,1);
% value_counts = [C, a_counts]
% 
% [D,ia2,ic2] = unique(row);
% a_counts2 = accumarray(ic2,1);
% value_counts2 = [D, a_counts2]

% refineLandR = sum(idxStore,1);
% refineLandC = sum(idxStore,2);

% pick data 
% [selectLandC,idLandC]=max(refineLandC);
% [selectLandR,idLandR]=max(refineLandR);
% landResult = [idLandR+2 idLandC+2]









