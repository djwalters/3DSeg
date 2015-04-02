function RandomGeoCreate(figflag, dims, mindiam, maxdiam, numspheres)

% Code to create an image stack of overlapping spheres with a random 3-D
% positions and diameters.  It is intended to be used to evaluate
% performance of segmentation related code.
%
% INPUTS:
%   figflag: Flag determining whether to produce figures or not.
%       0 for no figures.
%       1 for figures.
%
%   dims: image stack dimensions in pixels (cubic)
%   mindiam: Minimum sphere diameter
%   maxdiam: Maximum sphere diameter
%   numspheres: Number of spheres to produce.
%
% OUTPUTS:
%   Produces a stack of 2-D binary images similar to 3-D data produced by
%   Computed Tomography.  These images can be analyzed further using CT
%   analysis software.
%
% Author: David J Walters
%   Montana State University
%
% V1.0 - March 31, 2015


% clear all;
% close all; 
% clc;

% Deletes images in current folder for saving
delete('C:\Users\David\Documents\MSU Research\Doctoral Work\Mechanical Testing\Radiation Recrystallization\PhD Work\Spheres\Images\*.tif')

% Sets Random Number Generator seed to the current PC time clock for a
% different seed on every run
rng('shuffle');

% Generate vector containning random sphere diameters (integers)
diams = randi([mindiam maxdiam],1,numspheres);

% Randomly locates center of each sphere based on "diams" vector
Center = cell(1,length(diams));
for i = 1:length(diams)
    Center{i} = [randi([1 dims],1,1),randi([1 dims],1,1),randi([1 dims],1,1)];
end


% Generate a 3-D array of all zeros to start
D=false(dims,dims,dims); %Blank space (ones are empty space in this binarization)

% Loops which change voxels to 1's if located where a sphere is positioned
for m = 1:length(Center)
    for i = 1:length(D(:,1,1))
        for j = 1:length(D(1,:,1))
            for k = 1:length(D(1,1,:))
                if sqrt((i-Center{m}(1))^2+(j-Center{m}(2))^2+(k-Center{m}(3))^2)<=(diams(m)/2)
                    D(i,j,k)=1;
                end
            end
        end
    end
   
    
end

% Generate a figure of random geometry if figflag == 1
if figflag == 1
    figure
    isosurface(D,0.99), axis equal,
    camlight, lighting gouraud, title('3D Object')
end

% Save 3-D array into a stack of 2-D binary images
for i=1:length(D(1,1,:))
    Filename=strcat('C:\Users\David\Documents\MSU Research\Doctoral Work\Mechanical Testing\Radiation Recrystallization\PhD Work\Spheres\Images\',sprintf('%04d',i),'.tif');
    imwrite(D(:,:,i),Filename)
end
