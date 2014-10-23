FileIO = {'/home/david.walters/PhD Work/MicroMechanics/CT Images/BMP Binary/2013-12-13 Shear New/5x5x6 mm Volume/Buried/';
    'buried_rr_rec_tra_bin_0872.bmp';
    'buried_rr_rec_tra_bin_1273.bmp';
    '2013-12-13 Buried'};
sensitivity = 0.5;
% [Data]=Segmentation3D(runtype,imsize,FileIO,sensitivity,FileOutFlag,figflag) 
[Data]=Segmentation3D('terminal',0,FileIO,sensitivity,1,0); 
exit