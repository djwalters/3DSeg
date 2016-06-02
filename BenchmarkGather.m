clear all; close all;

% Set path of .mat files
setpath = 'C:\Users\David\Documents\MSU Research\Doctoral Work\Mechanical Testing\Radiation Recrystallization\PhD Work\Spheres';

% Set specific filelocation for each .mat file
filepath25 = fullfile(setpath,'10run25x25x25 Results.mat');
filepath50 = fullfile(setpath,'10run50x50x50 Results.mat');
filepath75 = fullfile(setpath,'10run75x75x75 Results.mat');
filepath100 = fullfile(setpath,'10run100x100x100 Results.mat');
filepath125 = fullfile(setpath,'10run125x125x125 Results.mat');
filepath150 = fullfile(setpath,'1run150x150x150 Results.mat');

% Open .mat files into structure arrays
st1 = open(filepath25);
st2 = open(filepath50);
st3 = open(filepath75);
st4 = open(filepath100);
st5 = open(filepath125);
st6 = open(filepath150);

% Convert structure arrays to multi-dimensional scalar arrays

for i = 1:6
    eval(['avgFcombo(:,:,i)=st' num2str(i) '.avgF;']);
    eval(['avgFc2ccombo(:,:,i)=st' num2str(i) '.avgFc2c;']);
    eval(['avgMILcombo(:,:,i)=st' num2str(i) '.avgMIL;']);
    eval(['avgTrcombo(:,:,i)=st' num2str(i) '.avgTr;']);
    eval(['avgTrc2ccombo(:,:,i)=st' num2str(i) '.avgTrc2c;']);
    
    eval(['avgFCicombo(:,:,i,1)=st' num2str(i) '.avgFCi(:,:,1);']);
    eval(['avgFCicombo(:,:,i,2)=st' num2str(i) '.avgFCi(:,:,2);']);
    eval(['avgFc2cCicombo(:,:,i,1)=st' num2str(i) '.avgFc2cCi(:,:,1);']);
    eval(['avgFc2cCicombo(:,:,i,2)=st' num2str(i) '.avgFc2cCi(:,:,2);']);
    eval(['avgMILCicombo(:,:,i,1)=st' num2str(i) '.avgMILCi(:,:,1);']);
    eval(['avgMILCicombo(:,:,i,2)=st' num2str(i) '.avgMILCi(:,:,2);']);
    eval(['avgTrCicombo(:,:,i,1)=st' num2str(i) '.avgTrCi(:,:,1);']);
    eval(['avgTrCicombo(:,:,i,2)=st' num2str(i) '.avgTrCi(:,:,2);']);
    eval(['avgTrc2cCicombo(:,:,i,1)=st' num2str(i) '.avgTrc2cCi(:,:,1);']);
    eval(['avgTrc2cCicombo(:,:,i,2)=st' num2str(i) '.avgTrc2cCi(:,:,2);']);
    
    eval(['stdFcombo(:,:,i)=st' num2str(i) '.stdF;']);
    eval(['stdFc2ccombo(:,:,i)=st' num2str(i) '.stdFc2c;']);
    eval(['stdMILcombo(:,:,i)=st' num2str(i) '.stdMIL;']);
    eval(['stdTrcombo(:,:,i)=st' num2str(i) '.stdTr;']);
    eval(['stdTrc2ccombo(:,:,i)=st' num2str(i) '.stdTrc2c;']);
end

idx = 25:25:150;

% Plot values

%% Plot planefit avg contact tensor
% Initialize plot parameters
ebwidth = 5;  % Errorbar cap width
font = 'Palatino Linotype';
fsize = 11;     % Font Size
msize = 5;      % Marker Size

% Initialize figure heading
figure('Name','3-D Tensor Diagonals -- PlaneFit','NumberTitle','off')

% Plot value and confidence interval of contact tensor coefficient F11
hE = errorbar(idx,avgFcombo(1,1,:),avgFcombo(1,1,:)-avgFCicombo(1,1,:,1),...
    avgFCicombo(1,1,:,2)-avgFcombo(1,1,:),'rsquare','MarkerSize',msize);
errorbarwidth(hE,ebwidth);

% Plot value and confidence interval of contact tensor coefficient F22
hold on
hE = errorbar(idx,avgFcombo(2,2,:),avgFcombo(2,2,:)-avgFCicombo(2,2,:,1),...
    avgFCicombo(2,2,:,2)-avgFcombo(2,2,:),'bdiamond','MarkerSize',msize+1);
errorbarwidth(hE,ebwidth);

% Plot value and confidence interval of contact tensor coefficient F33
hold on
hE = errorbar(idx,avgFcombo(3,3,:),avgFcombo(3,3,:)-avgFCicombo(3,3,:,1),...
    avgFCicombo(3,3,:,2)-avgFcombo(3,3,:),'go','MarkerSize',msize);
errorbarwidth(hE,ebwidth);

% Adjust format and appearance of contact tensor coefficient plot
grid
axis([0 175 0 0.75])
y1 = ylabel('3-D Tensor Diagonals (-)');
x1 = xlabel('Cubic Volume Side Length (pixels)');
set([y1 x1],'FontName',font,'FontSize',fsize)
legend('\it{x}\rm{_1}','\it{x}\rm{_2}','\it{x}\rm{_3}',...
    'Location','Northwest','Orientation','horizontal');
set(gca,'FontName',font,'FontSize',fsize,'XTick',0:25:175)

%% Plot center to center contact values
% Plot planefit avg contact tensor
% Initialize plot parameters
ebwidth = 5;  % Errorbar cap width
font = 'Palatino Linotype';
fsize = 11;     % Font Size
msize = 5;      % Marker Size

% Initialize figure heading
figure('Name','3-D Tensor Diagonals -- C2C','NumberTitle','off')

% Plot value and confidence interval of contact tensor coefficient F11
hE = errorbar(idx,avgFc2ccombo(1,1,:),avgFc2ccombo(1,1,:)-avgFc2cCicombo(1,1,:,1),...
    avgFc2cCicombo(1,1,:,2)-avgFc2ccombo(1,1,:),'rsquare','MarkerSize',msize);
errorbarwidth(hE,ebwidth);

% Plot value and confidence interval of contact tensor coefficient F22
hold on
hE = errorbar(idx,avgFc2ccombo(2,2,:),avgFc2ccombo(2,2,:)-avgFc2cCicombo(2,2,:,1),...
    avgFc2cCicombo(2,2,:,2)-avgFc2ccombo(2,2,:),'bdiamond','MarkerSize',msize+1);
errorbarwidth(hE,ebwidth);

% Plot value and confidence interval of contact tensor coefficient F33
hold on
hE = errorbar(idx,avgFc2ccombo(3,3,:),avgFc2ccombo(3,3,:)-avgFc2cCicombo(3,3,:,1),...
    avgFc2cCicombo(3,3,:,2)-avgFc2ccombo(3,3,:),'go','MarkerSize',msize);
errorbarwidth(hE,ebwidth);

% Adjust format and appearance of contact tensor coefficient plot
grid
axis([0 175 0.2 0.5])
y1 = ylabel('3-D Tensor Diagonals (-)');
x1 = xlabel('Cubic Volume Side Length (pixels)');
set([y1 x1],'FontName',font,'FontSize',fsize)
legend('\it{x}\rm{_1}','\it{x}\rm{_2}','\it{x}\rm{_3}',...
    'Location','Northwest','Orientation','horizontal');
set(gca,'FontName',font,'FontSize',fsize,'XTick',0:25:175)

%% Plot MIL values
% Plot planefit avg contact tensor
% Initialize plot parameters
ebwidth = 5;  % Errorbar cap width
font = 'Palatino Linotype';
fsize = 11;     % Font Size
msize = 5;      % Marker Size

% Initialize figure heading
figure('Name','3-D Tensor Diagonals -- MIL','NumberTitle','off')

% Plot value and confidence interval of contact tensor coefficient F11
hE = errorbar(idx,avgMILcombo(1,1,:),avgMILcombo(1,1,:)-avgMILCicombo(1,1,:,1),...
    avgMILCicombo(1,1,:,2)-avgMILcombo(1,1,:),'rsquare','MarkerSize',msize);
errorbarwidth(hE,ebwidth);

% Plot value and confidence interval of contact tensor coefficient F22
hold on
hE = errorbar(idx,avgMILcombo(2,2,:),avgMILcombo(2,2,:)-avgMILCicombo(2,2,:,1),...
    avgMILCicombo(2,2,:,2)-avgMILcombo(2,2,:),'bdiamond','MarkerSize',msize+1);
errorbarwidth(hE,ebwidth);

% Plot value and confidence interval of contact tensor coefficient F33
hold on
hE = errorbar(idx,avgMILcombo(3,3,:),avgMILcombo(3,3,:)-avgMILCicombo(3,3,:,1),...
    avgMILCicombo(3,3,:,2)-avgMILcombo(3,3,:),'go','MarkerSize',msize);
errorbarwidth(hE,ebwidth);

% Adjust format and appearance of contact tensor coefficient plot
grid
axis([0 175 0.2 0.5])
y1 = ylabel('3-D Tensor Diagonals (-)');
x1 = xlabel('Cubic Volume Side Length (pixels)');
set([y1 x1],'FontName',font,'FontSize',fsize)
legend('\it{x}\rm{_1}','\it{x}\rm{_2}','\it{x}\rm{_3}',...
    'Location','Northwest','Orientation','horizontal');
set(gca,'FontName',font,'FontSize',fsize,'XTick',0:25:175)

%% Plot Planefit Tensor Ratio values
% Plot planefit avg contact tensor
% Initialize plot parameters
ebwidth = 5;  % Errorbar cap width
font = 'Palatino Linotype';
fsize = 11;     % Font Size
msize = 5;      % Marker Size

% Initialize figure heading
figure('Name','3-D Tensor Diagonals -- Planefit Tensor Ratio','NumberTitle','off')

% Plot value and confidence interval of contact tensor coefficient F11
hE = errorbar(idx,avgTrcombo(1,1,:),avgTrcombo(1,1,:)-avgTrCicombo(1,1,:,1),...
    avgTrCicombo(1,1,:,2)-avgTrcombo(1,1,:),'rsquare','MarkerSize',msize);
errorbarwidth(hE,ebwidth);

% Plot value and confidence interval of contact tensor coefficient F22
hold on
hE = errorbar(idx,avgTrcombo(2,2,:),avgTrcombo(2,2,:)-avgTrCicombo(2,2,:,1),...
    avgTrCicombo(2,2,:,2)-avgTrcombo(2,2,:),'bdiamond','MarkerSize',msize+1);
errorbarwidth(hE,ebwidth);

% Plot value and confidence interval of contact tensor coefficient F33
hold on
hE = errorbar(idx,avgTrcombo(3,3,:),avgTrcombo(3,3,:)-avgTrCicombo(3,3,:,1),...
    avgTrCicombo(3,3,:,2)-avgTrcombo(3,3,:),'go','MarkerSize',msize);
errorbarwidth(hE,ebwidth);

% Adjust format and appearance of contact tensor coefficient plot
grid
axis([0 175 0 2])
y1 = ylabel('Tensor Ratio Coefficients (-)');
x1 = xlabel('Cubic Volume Side Length (pixels)');
set([y1 x1],'FontName',font,'FontSize',fsize)
legend('\it{x}\rm{_1}','\it{x}\rm{_2}','\it{x}\rm{_3}',...
    'Location','Northwest','Orientation','horizontal');
set(gca,'FontName',font,'FontSize',fsize,'XTick',0:25:175)

%% Plot center to center Tensor Ratio Values values
% Plot planefit avg contact tensor
% Initialize plot parameters
ebwidth = 5;  % Errorbar cap width
font = 'Palatino Linotype';
fsize = 11;     % Font Size
msize = 5;      % Marker Size

% Initialize figure heading
figure('Name','3-D Tensor Diagonals -- C2C Tensor Ratio','NumberTitle','off')

% Plot value and confidence interval of contact tensor coefficient F11
hE = errorbar(idx,avgTrc2ccombo(1,1,:),avgTrc2ccombo(1,1,:)-avgTrc2cCicombo(1,1,:,1),...
    avgTrc2cCicombo(1,1,:,2)-avgTrc2ccombo(1,1,:),'rsquare','MarkerSize',msize);
errorbarwidth(hE,ebwidth);

% Plot value and confidence interval of contact tensor coefficient F22
hold on
hE = errorbar(idx,avgTrc2ccombo(2,2,:),avgTrc2ccombo(2,2,:)-avgTrc2cCicombo(2,2,:,1),...
    avgTrc2cCicombo(2,2,:,2)-avgTrc2ccombo(2,2,:),'bdiamond','MarkerSize',msize+1);
errorbarwidth(hE,ebwidth);

% Plot value and confidence interval of contact tensor coefficient F33
hold on
hE = errorbar(idx,avgTrc2ccombo(3,3,:),avgTrc2ccombo(3,3,:)-avgTrc2cCicombo(3,3,:,1),...
    avgTrc2cCicombo(3,3,:,2)-avgTrc2ccombo(3,3,:),'go','MarkerSize',msize);
errorbarwidth(hE,ebwidth);

% Adjust format and appearance of contact tensor coefficient plot
grid
axis([0 175 0 2])
y1 = ylabel('Tensor Ratio Coefficients (-)');
x1 = xlabel('Cubic Volume Side Length (pixels)');
set([y1 x1],'FontName',font,'FontSize',fsize)
legend('\it{x}\rm{_1}','\it{x}\rm{_2}','\it{x}\rm{_3}',...
    'Location','Northwest','Orientation','horizontal');
set(gca,'FontName',font,'FontSize',fsize,'XTick',0:25:175)

%% Plot standard deviations
for i=1:6
MILcombo1(i) = stdMILcombo(1,1,i);
MILcombo2(i) = stdMILcombo(2,2,i);
MILcombo3(i) = stdMILcombo(3,3,i);

Fcombo1(i) = stdFcombo(1,1,i);
Fcombo2(i) = stdFcombo(2,2,i);
Fcombo3(i) = stdFcombo(3,3,i);

Fc2ccombo1(i) = stdFc2ccombo(1,1,i);
Fc2ccombo2(i) = stdFc2ccombo(2,2,i);
Fc2ccombo3(i) = stdFc2ccombo(3,3,i);

Trcombo1(i) = stdTrcombo(1,1,i);
Trcombo2(i) = stdTrcombo(2,2,i);
Trcombo3(i) = stdTrcombo(3,3,i);

Trc2ccombo1(i) = stdTrc2ccombo(1,1,i);
Trc2ccombo2(i) = stdTrc2ccombo(2,2,i);
Trc2ccombo3(i) = stdTrc2ccombo(3,3,i);
end

font = 'Palatino Linotype';
fsize = 11;     % Font Size
msize = 5;      % Marker Size

% Initialize figure heading
figure('Name','STD of Contact Tensor -- Planefit','NumberTitle','off')

% Plot
plot(idx,Fcombo1,idx,Fcombo2,idx,Fcombo3)

% Adjust format and appearance of contact tensor coefficient plot
grid
xlim([0 175])
y1 = ylabel('Standard Deviation (pixels)');
x1 = xlabel('Cubic Volume Side Length (pixels)');
set([y1 x1],'FontName',font,'FontSize',fsize)
legend('\it{x}\rm{_1}','\it{x}\rm{_2}','\it{x}\rm{_3}',...
    'Location','Northwest','Orientation','horizontal');
set(gca,'FontName',font,'FontSize',fsize,'XTick',0:25:175)

% Initialize figure heading
figure('Name','STD of Contact Tensor -- C2C','NumberTitle','off')

% Plot
plot(idx,Fc2ccombo1,idx,Fc2ccombo2,idx,Fc2ccombo3)

% Adjust format and appearance of contact tensor coefficient plot
grid
xlim([0 175])
y1 = ylabel('Standard Deviation (pixels)');
x1 = xlabel('Cubic Volume Side Length (pixels)');
set([y1 x1],'FontName',font,'FontSize',fsize)
legend('\it{x}\rm{_1}','\it{x}\rm{_2}','\it{x}\rm{_3}',...
    'Location','Northwest','Orientation','horizontal');
set(gca,'FontName',font,'FontSize',fsize,'XTick',0:25:175)

% Initialize figure heading
figure('Name','STD of MIL Tensor','NumberTitle','off')

% Plot
plot(idx,MILcombo1,idx,MILcombo2,idx,MILcombo3)

% Adjust format and appearance of contact tensor coefficient plot
grid
xlim([0 175])
y1 = ylabel('Standard Deviation (pixels)');
x1 = xlabel('Cubic Volume Side Length (pixels)');
set([y1 x1],'FontName',font,'FontSize',fsize)
legend('\it{x}\rm{_1}','\it{x}\rm{_2}','\it{x}\rm{_3}',...
    'Location','Northwest','Orientation','horizontal');
set(gca,'FontName',font,'FontSize',fsize,'XTick',0:25:175)

% Initialize figure heading
figure('Name','STD of Tensor Ratio -- Planefit','NumberTitle','off')

% Plot
plot(idx,Trcombo1,idx,Trcombo2,idx,Trcombo3)

% Adjust format and appearance of contact tensor coefficient plot
grid
xlim([0 175])
y1 = ylabel('Standard Deviation (pixels)');
x1 = xlabel('Cubic Volume Side Length (pixels)');
set([y1 x1],'FontName',font,'FontSize',fsize)
legend('\it{x}\rm{_1}','\it{x}\rm{_2}','\it{x}\rm{_3}',...
    'Location','Northwest','Orientation','horizontal');
set(gca,'FontName',font,'FontSize',fsize,'XTick',0:25:175)

% Initialize figure heading
figure('Name','STD of Tensor Ratio -- C2C','NumberTitle','off')

% Plot
plot(idx,Trc2ccombo1,idx,Trc2ccombo2,idx,Trc2ccombo3)

% Adjust format and appearance of contact tensor coefficient plot
grid
xlim([0 175])
y1 = ylabel('Standard Deviation (pixels)');
x1 = xlabel('Cubic Volume Side Length (pixels)');
set([y1 x1],'FontName',font,'FontSize',fsize)
legend('\it{x}\rm{_1}','\it{x}\rm{_2}','\it{x}\rm{_3}',...
    'Location','Northwest','Orientation','horizontal');
set(gca,'FontName',font,'FontSize',fsize,'XTick',0:25:175)