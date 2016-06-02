% SegmentationEvalScript.m
% This script loops through several runs of RandomGeoCreate.m ->
% RUNSEGMENTATION3D.m -> RunContact.m
%   RandomGeoCreate2.m is a script which generates randomly sized and
%   positioned spheres in a 3-D space.  It then produces a stack of 2-D
%   binary images of the 3-D object similar to data generated from a
%   micro-CT scan of snow.
%
%   RunSeg3D.m is contains the 3D Watershed segmentation function. It
%   operates on image stacks of 2-D binary images containing 
%   data for 3-D objects.  This produces a .csv file containing information
%   on the bond plane surfaces between objects as well as other geometric
%   properties such as bond/grain size and position.
%
%   ContactTensor.m is a function for calculating the contact tensor
%   from the .csv file produced by 3-D Watershed Segmentation.
%
% The purpose is to evaluate several runs of randomly created geometry and
% their associated contact tensors.  It is intended to analyze whether a
% truly random distribution of bond contact orientations occurs or whether
% image artifacts bias the results in a particular direction.
%
% Script Author: David J Walters
%       Montana State University
% V1.0 - April 1, 2015
% V2.0 - May 22, 2016

%% Execution Setup
clear all; close all;
% Open parallel processing resources
matlabpool open 4
addpath('C:\Users\David\Documents\MSU Research\Doctoral Work\GitProjects\FabTens\');

%% Set Inputs
% Set number of runs
runs = 1;
dims = 50;
numspheres = 25 * (dims/25)^3;
lastim = sprintf('S%04.0f.bmp',dims+1);
%% Initialize variables
F2 = zeros(3,3,runs);
F2c2c = zeros(3,3,runs);
VolFrac = zeros(1,runs);
D = zeros(3,runs);
LD = zeros(3,runs);
UD = zeros(3,runs);
E = zeros(3,3,runs);
F2Ci = zeros(3,3,runs,2);
F2c2cCi = zeros(3,3,runs,2);
Tr = zeros(3,runs);
Trc2c = zeros(3,runs);
TrCi = zeros(3,runs,2);
Trc2cCi = zeros(3,runs,2);
MIL = zeros(3,3,runs);
MILc2c = zeros(3,3,runs);
MILCi = zeros(3,3,runs,2);
MILc2cCi = zeros(3,3,runs,2);

%% Compute and Analyze Geometry
for n = 1:runs
    % Delete CTAn results file for the next iteration of the loop
    delete('C:\Users\David\Documents\MSU Research\Doctoral Work\Mechanical Testing\Radiation Recrystallization\PhD Work\Spheres\Images\*.txt')
    n
    % Generate random geometry
    RandomGeoCreate2(0, dims, 2, 10, numspheres,1);
    
    % Run CTAn BATch MANager using command prompt script
    !"C:\Users\David\Desktop\Skyscan\CTAn.exe" "C:\Users\David\Documents\MSU Research\Doctoral Work\Mechanical Testing\Radiation Recrystallization\PhD Work\Spheres\Images\S????.bmp" /T"C:\Users\David\Documents\MSU Research\Doctoral Work\Mechanical Testing\Radiation Recrystallization\PhD Work\Spheres\BatchProcessSpheres.ctt" /B /A /C
    
    % Run watershed segmentation routine
    RunSeg3D('S0001.bmp',lastim);
    
    % Analyze CTAn data for MIL Tensor values
    [~,~,VolFrac(n),D(:,n),LD(:,n),UD(:,n),E(:,:,n),~]= CTAnData3(1);
    
    % Analyze contact tensor using planefit routine
    [F2(:,:,n),F2Ci(:,:,n,:),~]...
        = ContactTensor(1,'planenorm',0,1,'C:\Users\David\Documents\MSU Research\Doctoral Work\Mechanical Testing\Radiation Recrystallization\PhD Work\Spheres\');
    
    % Rerun contact tensor using grain center-to-center as bond orientation
    [F2c2c(:,:,n),F2c2cCi(:,:,n,:),~]...
        = ContactTensor(1,'geocenter2center',0,1,'C:\Users\David\Documents\MSU Research\Doctoral Work\Mechanical Testing\Radiation Recrystallization\PhD Work\Spheres\');
    
    % Compute Tensor ratio and MIL Tensor for planefit
    [Tr(:,n),TrCi(:,n,:),MIL(:,:,n),MILCi(:,:,n,:)] ...
        = TensorRatio(F2(:,:,n),F2Ci(:,:,n,:),D(:,n),LD(:,n),UD(:,n),E(:,:,n));
    
    % Compute tensor ratio and MIL tensor for center-to-center bond
    % orientation
    [Trc2c(:,n),Trc2cCi(:,n,:),MILc2c(:,:,n),MILc2cCi(:,:,n,:)] ...
        = TensorRatio(F2c2c(:,:,n),F2c2cCi(:,:,n,:),D(:,n),LD(:,n),UD(:,n),E(:,:,n));
end

%% Collect data and compute average values
% Compute the averages
avgF = zeros(3);
avgFc2c = zeros(3);
avgMIL = zeros(3);
avgTr = zeros(3);
avgTrc2c = zeros(3);
for i = 1:3
    avgF(i,i) = mean(F2(i,i,:));
    avgFc2c(i,i) = mean(F2c2c(i,i,:));
    avgMIL(i,i) = mean(MIL(i,i,:));
    avgTr(i,i) = mean(Tr(i,:));
    avgTrc2c(i,i) = mean(Trc2c(i,:));
end
% Compute averages of confidence intervals
avgFCi = zeros(3,3,2);
avgFc2cCi = zeros(3,3,2);
avgMILCi = zeros(3,3,2);
avgTrCi = zeros(3,3,2);
avgTrc2cCi = zeros(3,3,2);
for i = 1:3
    for j = 1:2
        if j == 1
        avgFCi(i,i,j) = max(F2Ci(i,i,:,j));
        avgFc2cCi(i,i,j) = max(F2c2cCi(i,i,:,j));
        avgMILCi(i,i,j) = max(MILCi(i,i,:,j));
        avgTrCi(i,i,j) = max(TrCi(i,:,j));
        avgTrc2cCi(i,i,j) = max(Trc2cCi(i,:,j));
        else
        avgFCi(i,i,j) = min(F2Ci(i,i,:,j));
        avgFc2cCi(i,i,j) = min(F2c2cCi(i,i,:,j));
        avgMILCi(i,i,j) = min(MILCi(i,i,:,j));
        avgTrCi(i,i,j) = min(TrCi(i,:,j));
        avgTrc2cCi(i,i,j) = min(Trc2cCi(i,:,j));
        end
            
    end
end

% Compute standard deviations
stdF = zeros(3);
stdFc2c = zeros(3);
stdMIL = zeros(3);
stdTr = zeros(3);
stdTrc2c = zeros(3);
for i = 1:3
    stdF(i,i) = std(F2(i,i,:));
    stdFc2c(i,i) = std(F2c2c(i,i,:));
    stdMIL(i,i) = std(MIL(i,i,:));
    stdTr(i,i) = std(Tr(i,:));
    stdTrc2c(i,i) = std(Trc2c(i,:));
end
matlabpool close