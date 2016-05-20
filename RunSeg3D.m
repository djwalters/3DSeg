function RunSeg3D(firstim, lastim)
% Wrapper function/script for evaluating Segmentation3D function.
% INPUTS
%   firstim/lastim: string variable which lists the file name of the first
%   and last images of the stack.
%       ex: '0001.tif'  and '0050.tif'
%
% Author: David J Walters
%   Montana State University
% V1.1 - April 1, 2015

FileIO = {'C:\Users\David\Documents\MSU Research\Doctoral Work\Mechanical Testing\Radiation Recrystallization\PhD Work\Spheres\Images\';
    firstim;
    lastim;
    'RandomSpheres'};
sensitivity = .5;
% [Data]=Segmentation3D(runtype,imsize,FileIO,sensitivity,FileOutFlag,figflag) 
[~]=Segmentation3D('terminal',0,FileIO,sensitivity,1,0); 