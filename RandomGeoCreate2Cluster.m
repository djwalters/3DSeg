function RandomGeoCreate2Cluster(figflag, dims, mindiam, maxdiam, outdirname)
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
%   fileout: 'NameOfOutputFolder'
%
% OUTPUTS:
%   Produces a stack of 2-D binary images similar to 3-D data produced by
%   Computed Tomography.  These images can be analyzed further using CT
%   analysis software.
%
% Author: David J Walters
%   Montana State University
%
% V1.0 - May 21, 2016

parpool 4 
% Sets Random Number Generator seed to the current PC time clock for a
% different seed on every run
rng('shuffle');
numspheres = 25 * (dims/25)^3;
% Generate vector containning random sphere diameters (integers)
diams = randi([mindiam maxdiam],1,numspheres);

% Randomly locates center of each sphere based on "diams" vector
Center = cell(1,length(diams));
for i = 1:length(diams)
    Center{i} = [randi([1 dims],1,1),randi([1 dims],1,1),randi([1 dims],1,1)];
end

%DATA
[MatX,MatY,MatZ] = meshgrid(0:1:dims,0:1:dims,0:1:dims);
mask1 = false(dims+1,dims+1,dims+1);
parfor i = 1:length(Center)
    %     [mask(:,:,:,i)] = DrawEllipsoid(Center{i}, diams(i), MatX,MatY,MatZ);
    mask = DrawEllipsoid(Center{i}, diams(i), MatX,MatY,MatZ);
    mask1 =  mask1|mask;
    [msgstr, msgid] = lastwarn;
    % turn it off
s = warning('off', msgid);
end
% mask1 = false(dims+1,dims+1,dims+1);
% parfor j = 1:length(mask(1,1,1,:))
%     mask1 =  mask1|mask(:,:,:,j);
% end
% assignin('base','mask1',mask1)

if figflag == 1
%     %Surface PLOT
%     figure('Color', 'w');
%     subplot(1,2,1);
%     
%     %help: Ideally I would like to generate surf plot directly from combined mask= mask1 + mask2;
%     s = surf(x,y,z); hold on;
%     s2 = surf(x2,y2,z2); hold off;
%     title('SURFACE', 'FontSize', 16);
%     view(-78,22)
%     
%     subplot(1,2,2);
figure
    isosurface(mask1,0.99), axis equal,
    camlight, lighting gouraud, title('3D Object')
end

%     delete('C:\Users\David\Documents\MSU Research\Doctoral Work\Mechanical Testing\Radiation Recrystallization\PhD Work\Spheres\Images\*.bmp')
    for i=1:length(mask1(1,1,:))
        % Deletes images in current folder for saving
        Filename=strcat(sprintf('S%04d',i),'.bmp');
        imwrite(mask1(:,:,i),Filename)
    end



workdir = fullfile('/mnt/lustrefs/work/david.walters2',outdirname);
copyfile('S****.bmp',workdir)
parpool close
end

function [mask] = DrawEllipsoid(CenterEllipsoid, diams, MatX, MatY, MatZ)
[Ellipsoid_x, Ellipsoid_y, Ellipsoid_z] =  ellipsoid(CenterEllipsoid(1), CenterEllipsoid(2), CenterEllipsoid(3), diams/2 , diams/2 , diams/2 ,30);
v = [Ellipsoid_x(:), Ellipsoid_y(:), Ellipsoid_z(:)];                       %3D points
%v = [x(:), y(:), z(:)];                                                    %3D points
tri = delaunayTriangulation(v);                                                       %triangulation
SI = pointLocation(tri,MatX(:),MatY(:),MatZ(:));                            %index of simplex (returns NaN for all points outside the convex hull)
mask = ~isnan(SI);                                                          %binary
mask = logical(reshape(mask,size(MatX)));                                            %reshape the mask
end

