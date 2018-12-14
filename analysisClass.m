clc,clear 
%% Open the text file.
% fileID = fopen('C:\Users\joe_a\Desktop\Lidar2.txt','r','n','UTF-8');
% fseek(fileID, 3, 'bof');
% dataArray = textscan(fileID,'%f%C%[^\n\r]','Delimiter',' ','MultipleDelimsAsOne',true,'TextType','string','ReturnOnError',false);
% fclose(fileID);
% heightData = table(dataArray{1:end-1}, 'VariableNames', {'VarName1','cm'});
% clearvars fileID dataArray ans;
data=fopen('Lidar2.txt');
heightData=fscanf(data, '%i');

%% ===== table handle  ======== 
%need to be set by user
steps = 50; %steps should be even
scanAngle = 20; %scan angle in degrees
points = steps + 1;
halfAngle = scanAngle/2;
servoAngle=asind((31.5*tand(halfAngle))/10);

% x10 angle = theta, moves lidar sigma degrees about y axis
% x08 angle = alpha, moves lidar beta degrees about x axis
theta = linspace(servoAngle,-servoAngle,points);
alpha = linspace(-servoAngle,servoAngle,points);

%relationship between servo angle and lidar angle
%servo arm 10mm acts 31.5m from lidar pivot
sigma = atand((10*sind(theta))/31.5);
beta = atand((10*sind(alpha))/31.5);

%building matrix of beta values, beta values controlled by small servo, and
%change x coord.
betamatrix = zeros(points,points);

for j = 1:points
    for i = 1:points
        betamatrix(j,i) = beta(i);
    end
end
betamatrix;

%building matrix of sigma values
sigmamatrix = zeros(points,points);

for k=1:points
    for l=1:points
        sigmamatrix(k,l) = sigma(k);
    end
end
sigmamatrix;

%relationship between servo angles and sperical coordinate angles
gamma = asind(sqrt(sind(betamatrix).^2 + sind(sigmamatrix).^2)); 
phi = atand(sind(sigmamatrix)./sind(betamatrix));

%adjusting for changing quardrants
for a=1:points
    for b=1:steps/2
        if phi(b,a)<0
            phi(b,a)= phi(b,a)+180;
        end
    end
end

%adjusting for changing quardrants
for a=1:points
    for b=(points-steps/2):points
        if phi(b,a)>0
            phi(b,a)= phi(b,a)+180;
        end
        if phi(b,a)<0
            phi(b,a)= phi(b,a)+360;
        end
    end
end
phi(((steps/2)+1),((steps/2)+1))=0;
phi(((steps/2)+1),((steps/2)+2):(points))=180;

%building matrix from height data
r=ones(points,points); e=1;
for c=1:points
    for d=1:points
        r(c,d)=heightData(e);
        e=e+1; 
    end
end

%swap order of every second row
for jj=2:2:points
    r(jj,:)=fliplr(r(jj,:));
end
r=r./100;

x=r.*sind(gamma).*cosd(phi);
y=r.*sind(gamma).*sind(phi);
heightTable=r.*cosd(gamma);

%adjust for scanning downwards
heightTable=-heightTable; x=-x;

%fixing error for code tht isnt multiple of 4
if rem(steps,4)~=0
    for ii=(steps/2)+1
        x(ii,:)=fliplr(x(ii,:));
    end
end
% initial feedback as a heatmap
figure
surf(x,y,heightTable,'FaceAlpha',0.8,'EdgeColor','interp')
colorbar

figure
hm = heatmap(heightTable);

%% Analysis class
% Check the average inclination 
planeCheck = abs(mean(surfnorm(heightTable))) <= deg2rad(5);%in deg 
verifyPlanecheck = any(planeCheck(:)); choiceBox1 = ['Pass' 'Fail']; 
fprintf('Landing field inclination check %s\n',choiceBox1(verifyPlanecheck))

% Check the terrain characteristics
landChar = gradient(heightTable); 
rockCheck=ones(11,11);
for rC = 1:length(heightTable) % terrain check 
    for cC = 1:length(heightTable)           
        rockCheck(rC,cC) = deg2rad(0) <= abs(landChar(rC,cC)) && abs(landChar(rC,cC)) <= deg2rad(5); %in deg
    end 
end    

% identify the characteristics
edges = 0:.5:1; % Bin edges
labels = {'Do not Land','Land'}; % Labels for the bins
categorizeLabl = discretize(rockCheck,edges,'Categorical',labels); % Land/not land feedback
% land area calculation 
landableStoreR = movsum(rockCheck,10,1,'Endpoints','discard'); 
[idRow1,idCol1] = find(landableStoreR==10); 
landableStoreC = movsum(rockCheck,10,2,'Endpoints','discard'); 
[idRow2,idCol2] = find(landableStoreC==10); 
index1 = [idRow1+9 idCol1]; % convert to a real index
index2 = [idRow2 idCol2+9]; % convert to a real index
[res,ia,~]=unique(index1,'rows'); 
[res2,ia2,~]=unique(index2,'rows'); 
join=intersect(res,res2,'rows');  
landingCoor=join((join(:,1)>10 & join(:,1)<41),:);
landingCoor=join((join(:,2)>10 & join(:,2)<41),:);

% print coordinates
for finalPrint = 1:length(landingCoor)
    fprintf('Landing Coordinate(s) \n\t(X,Y)\n \t(%d,%d),\n',landingCoor(finalPrint,:))
end