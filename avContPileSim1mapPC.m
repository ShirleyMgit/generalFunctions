clear all
close all
clc

based = 'C:\Users\User\OneDrive\Documents\MATLAB\';
spm_path = 'C:\Users\User\Documents\MATLAB\spm12\spm12';
data_path = 'C:\Users\User\Documents\MATLAB\searchLightResults';
addpath(spm_path);
addpath(based);
addpath(data_path);


dirT = 'PileNregNativecleaned_MotionCSFonly_newMask';
anaName = 'PileSimSL';
areaM = 'L100dHippocampus_subiculum_R_julichP_T10';
ncon1 = '1';
ncon2 = '2';

vnpar = [51,50,49,48,46,45,44,43,42,40,38:-1:34,32:-1:28,26:-1:24,22:-1:18];
dirAll = fullfile(data_path,dirT,anaName,areaM,'contrast');

for sb = 1:28
    subdir = fullfile(dirAll,['sub',num2str(vnpar(sb))]);   
    Im1 = fullfile(subdir,['map',ncon1,'SpearmanDistCor.nii']);
    Im2 = fullfile(subdir,['map',ncon2,'SpearmanDistCor.nii']);
    fileName = fullfile(subdir,['map',ncon1,'and',ncon2,'SpearmanDistCor.nii']);
    makeAv2images(Im1,Im2,fileName);
end