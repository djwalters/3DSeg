% SegmentationEvalScript.m
% This script loops through several runs of RandomGeoCreate.m ->
% RUNSEGMENTATION3D.m -> RunContact.m
%   RandomGeoCreate.m is a script which generates randomly sized and
%   positioned spheres in a 3-D space.  It then produces a stack of 2-D
%   binary images of the 3-D object similar to data generated from a
%   micro-CT scan of snow.
%
%   RUNSEGMENTATION3D.m is a wrapper script for running the 3D Watershed
%   segmentation function on image stacks of 2-D binary images containing 
%   data for 3-D objects.  This produces a .csv file containing information
%   on the bond plane surfaces between objects as well as other geometric
%   properties such as bond/grain size and position.
%
%   RunContact.m is a wrapper script for calculating the contact tensor
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

clear all; close all;
% Set number of runs
runs = 20;
addpath('C:\Users\David\Documents\MSU Research\Doctoral Work\GitProjects\FabTens\');
F2 = zeros(3,3,runs);
F2c2c = zeros(3,3,runs);
for n = 1:runs
    % Generate random geometry
    RandomGeoCreate(0, 50, 2, 10, 200);
    !"C:\Users\David\Desktop\Skyscan\CTAn.exe" "C:\Users\David\Documents\MSU Research\Doctoral Work\Mechanical Testing\Radiation Recrystallization\PhD Work\Spheres\Images\S????.bmp" /T"C:\Users\David\Documents\MSU Research\Doctoral Work\Mechanical Testing\Radiation Recrystallization\PhD Work\Spheres\BatchProcessSpheres.ctt" /B /A /C
    RunSeg3D('S0001.bmp','S0050.bmp');
    [idx,PixSize,VolFrac(n),D(:,n),LD(:,n),UD(:,n),E(:,:,n),...
    ~]...
    = CTAnData3(1);
    [F2(:,:,n),F2Ci(:,:,n,:),~]...
        = ContactTensor(1,'planenorm',0,1,'C:\Users\David\Documents\MSU Research\Doctoral Work\Mechanical Testing\Radiation Recrystallization\PhD Work\Spheres\');
    [F2c2c(:,:,n),F2c2cCi(:,:,n,:),~]...
        = ContactTensor(1,'geocenter2center',0,1,'C:\Users\David\Documents\MSU Research\Doctoral Work\Mechanical Testing\Radiation Recrystallization\PhD Work\Spheres\');
    [Tr(:,n),TrCi(:,n,:),MIL(:,:,n),MILCi(:,:,n,:)] = TensorRatio(F2(:,:,n),F2Ci(:,:,n,:),D(:,n),LD(:,n),UD(:,n),E(:,:,n));
    [Trc2c(:,n),Trc2cCi(:,n,:),MILc2c(:,:,n),MILc2cCi(:,:,n,:)] = TensorRatio(F2c2c(:,:,n),F2c2cCi(:,:,n,:),D(:,n),LD(:,n),UD(:,n),E(:,:,n));
    delete('C:\Users\David\Documents\MSU Research\Doctoral Work\Mechanical Testing\Radiation Recrystallization\PhD Work\Spheres\Images\*.txt')
end

avgF11 = mean(F2(1,1,:));
avgF22 = mean(F2(2,2,:));
avgF33 = mean(F2(3,3,:));
avgF11c2c = mean(F2c2c(1,1,:));
avgF22c2c = mean(F2c2c(2,2,:));
avgFF33c2c = mean(F2c2c(3,3,:));
avgMIL11 = mean(MIL(1,1,:));
avgMIL22 = mean(MIL(2,2,:));
avgMIL33 = mean(MIL(3,3,:));
avgTr1 = mean(Tr(1,:));
avgTr2 = mean(Tr(2,:));
avgTr3 = mean(Tr(3,:));
avgTr1c2c = mean(Trc2c(1,:));
avgTr2c2c = mean(Trc2c(2,:));
avgTr3c2c = mean(Trc2c(3,:));

stdF11 = std(F2(1,1,:));
stdF22 = std(F2(2,2,:));
stdF33 = std(F2(3,3,:));
stdF11c2c = std(F2c2c(1,1,:));
stdF22c2c = std(F2c2c(2,2,:));
stdFF33c2c = std(F2c2c(3,3,:));
stdMIL11 = std(MIL(1,1,:));
stdMIL22 = std(MIL(2,2,:));
stdMIL33 = std(MIL(3,3,:));
stdTr1 = std(Tr(1,:));
stdTr2 = std(Tr(2,:));
stdTr3 = std(Tr(3,:));
stdTr1c2c = std(Trc2c(1,:));
stdTr2c2c = std(Trc2c(2,:));
stdTr3c2c = std(Trc2c(3,:));