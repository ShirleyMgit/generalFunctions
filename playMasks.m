close all
clear all
clc

spm_path = fullfile('C:\Users','User','Documents','MATLAB','spm12','spm12');
addpath(spm_path);

areaM = 'Hippocampus_subiculum_R_julichP_T10';
maskFolder = fullfile('ROI_masks');
maskFullPath= fullfile(maskFolder,[areaM,'.nii']);
con_tmp = spm_vol(maskFullPath); % SPM function to get image info
[ROI_dat1,XYZ1] = spm_read_vols(con_tmp,0);
Dm = ROI_dat1(:);

