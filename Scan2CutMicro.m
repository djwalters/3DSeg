%Enter as many iterations of Scan2Cut as you want! Implements the
%microcracking scheme, where every broken bond voxel is added to an array
%of broken bonds (brokbondfinal)
clear
clc

scale=14.88e-6;
initsize=[50,50,100]; %Initial Size of Image to Compute. First 2 values (x and y) should be same?
stepsize=10; %Increment by which to change image size. Note that Z dimension remains constant
finalsize=200; %Final X and Y dimension

row=0; %Row counter for final data table

brokfinal=uint8(zeros(initsize)); %Empty array in which to store all broken bonds

for EdgeLength=initsize(1):stepsize:finalsize
    
[Gcnocrack,brokbond]=Scan2Cut('/home/tonyl/20131213-Rounds-800cube/20131213',scale,281,[EdgeLength,EdgeLength,initsize(3)]);
stlwrite(strcat('EdgeLength',sprintf('%04d',EdgeLength),'.stl'),isosurface(brokbond,0.99));
sprintf('Image Dimensions')
CurrentDims=[EdgeLength,EdgeLength,initsize(3)]
sprintf('Gc: No Microcracking')
Gcnocrack

brokfinal=padarray(brokfinal,size(brokbond)-size(brokfinal),'post');
brokfinal=brokfinal+brokbond;
clear brokbond

brokfinalcalc=logical(brokfinal); %Final value to use for computation in this iteration of for loop
CCbondsum=bwconncomp(brokfinalcalc); 
Totarea=0; %Set total bond area to 0

for i=1:length(CCbondsum.PixelIdxList)
    Area=PlaneFit(i,CCbondsum);
    Totarea=Totarea+Area; %Total area of bonds, in square pixels
end

SampleArea=((EdgeLength-4)*scale)^2;
IceGamma=75.7e-3; %J/m^2
%sprintf('Sample Energy Cost:')
Ecost=Totarea*scale^2*IceGamma*2;
sprintf('Critical Energy Release Rate- With Microcracking')
Gc=Ecost/SampleArea

row=row+1;
FinalData(row,1)=EdgeLength;
FinalData(row,2)=EdgeLength;
FinalData(row,3)=initsize(3);
FinalData(row,4)=Gcnocrack;
FinalData(row,5)=Gc;

end

csvwrite('FinalData.csv',FinalData)