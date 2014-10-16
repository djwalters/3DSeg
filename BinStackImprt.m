%%Code to import a stack of binary snow images
function [bw]= BinStackImprt(filepath,Imname,namedigits,suffix,firstim,imsize,lastim);

%% Filepath is a string variable to location of files and file prefixes
%namedigits is a code for the # of digits in your filenames
%suffix is '.bmp' or '.jpg' etc...be sure to include the period.

filepath=sprintf('%s',filepath); %file path for import

% lastim=firstim+imsize(3)-1; %Last image to use in stack

%% IMPORT-General

for j=firstim:1:lastim
    filename=strcat(filepath,Imname,sprintf(namedigits,j),suffix);
    bwpart=imread(filename);
    if imsize == 0
        bw(:,:,j-firstim+1)=bwpart;
    else
        bw(:,:,j-firstim+1)=bwpart(1:imsize(1),1:imsize(2));
    end
end

end