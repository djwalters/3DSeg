function [Data] = FinalDataArray(CCGrains,CCBonds,GrainBondSets,Area,Normal,GrainRadius)
% FinalDataArray.m organized bond and grain data into a single data array.
% The output column headers are as follows:
% header=['Bond (ID), Bond X (pix), Bond Y (pix), Bond Z (pix)'...
%         ',Grain 1 (ID),Grain 1 X (pix), Grain 1 Y (pix), Grain 1 Z (pix)'...
%         ',Grain 2 (ID),Grain 2 X (pix), Grain 2 Y (pix), Grain 2 Z (pix)'...
%         ',Bond Area (pix^2),Bond Norm X (pix), Bond Norm Y (pix), Bond Norm Z (pix)'];
%
% Author: David J. Walters, Montana State University

GrnStat = regionprops(CCGrains,'Centroid');
GrnCent = zeros(size(GrnStat,1),3);

parfor i=1:size(GrnStat,1)
    GrnCent(i,:) = GrnStat(i).Centroid;
end

BondStat = regionprops(CCBonds,'Centroid');
BondCent = zeros(size(BondStat,1),3);

parfor i=1:size(BondStat,1)
    BondCent(i,:) = BondStat(i).Centroid;
end

Data = zeros(size(GrainBondSets,1),25);
Data(:,1) = GrainBondSets(:,1); %List bond number
Data(:,9) = GrainBondSets(:,2); %List grain number 1 of pair bonded to associated bond
Data(:,17) = GrainBondSets(:,3); %List grain number 2 of pair bonded to associated bond
Data(:,5) = Area;              %List bond area
Data(:,6:8) = Normal;         %List bond noraml unit vector (x,y,z)
Data(:,25) = 1:size(Data,1);    %Generates listing of row number

for i=1:size(Data,1)
    Data(i,2:4) = BondCent(Data(i,1),:);        %Write centroid [x y z] in following columns associated with bond number
    Data(i,10:12) = GrnCent(Data(i,9),:);       %Write centroid [x y z] in following columns associated with grain number 1 of bond
    Data(i,18:20) = GrnCent(Data(i,17),:);      %Write centroid [x y z] in following columns associated with grain number 2 of bond
    Data(i,13) = GrainRadius(Data(i,9),2);      %Write effective grain radius associated with grain number 1 of bond
    Data(i,14:16) = GrainRadius(Data(i,9),3:5); %Write coordinates of center of grain radius [x y z] of grain 1 of bond
    Data(i,21) = GrainRadius(Data(i,17),2);     %Write effective grain radius associated with grain number 2 of bond
    Data(i,22:24) = GrainRadius(Data(i,17),3:5);%Write coordinates of center of grain radius [x y z] of grain 2 of bond
end
% assignin('base','GrnCentDepug',GrnCent)
% assignin('base','BondCentDepug',BondCent)
end