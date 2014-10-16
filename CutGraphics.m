function [topcut,botcut]=CutGraphics(cut,CCgrains,Graph)

%% Build top and bottom cut graphics
ImageSize=CCgrains.ImageSize;
topcut=zeros(ImageSize); %Empty array for plotting isosurface
botcut=zeros(ImageSize); %Empty array for plotting isosurface
for i=1:CCgrains.NumObjects
    if Graph(i,:)==0
        if Graph(:,i)==0 %If no flow into or out of node i,
            continue %Then do not plot this grain
        end
    end
    
    if cut(i)==1 %If grain i is on top half of cut
    topcut(CCgrains.PixelIdxList{i})=1;
    elseif cut(i)==-1 %If grain i is on bottom of cut
    botcut(CCgrains.PixelIdxList{i})=1;
    end
end


%Plot top of cut
stlwrite('topcut.stl',isosurface(topcut,0.99));

%Plot below of cut
stlwrite('botcut.stl',isosurface(botcut,0.99));

clear topcut
clear botcut


