%SCRIPT TO MAKE ANIMATED .GIF OF 3D PLOT
%FROM
%http://www.mathworks.com/matlabcentral/answers/86940-animate-3d-plot-view

az = 45;
el = 45;
view([az,el])

degStep = 5;
detlaT = 1;
fCount = 71;
f = getframe(gcf);
[im,map] = rgb2ind(f.cdata,256,'nodither');
im(1,1,1,fCount) = 0;
k = 1;
% % spin 45°
% for i = 0:-degStep:-45
%   az = i;
%   ([az,el])
%   f = getframe(gcf);
%   im(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
%   k = k + 1;
% end
% % tilt down
% for i = 90:-degStep:15
%   el = i;
%   view([az,el])
%   f = getframe(gcf);
%   im(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
%   k = k + 1;
% end
% spin left
for i = az:-degStep:-40
  az = i;
  view([az,el])
  f = getframe(gcf);
  im(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
  k = k + 1;
end
% spin right
for i = az:degStep:90
  az = i;
  view([az,el])
  f = getframe(gcf);
  im(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
  k = k + 1;
end
% % tilt up to original
% for i = el:degStep:90
%   el = i;
%   view([az,el])
%   f = getframe(gcf);
%   im(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
%   k = k + 1;
% end
imwrite(im,map,'Animation.gif','DelayTime',detlaT,'LoopCount',inf)