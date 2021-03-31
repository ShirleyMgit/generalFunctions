function runTimAnaLooNorm_searchLight29subFSLcleanedAllEv(nsb,areaM,dirT,nFiles,nameSearchL,dirL,isPC,sflag)
runN  = 'Tim1';%2;
% path definitions:
rsa_tool_path = 'rsatoolbox';
if isPC==0
    based = '/home/smark/fMRI_ana';
    spm_path = '/data/smark/spm';
    data_path = '/data/smark/fmri_sub_preproc_dir/';
    cleaned_data_path = '/data/smark/fmri_sub_preproc_dir/fsl2spmFix_BasisSetExp/sub-';
    addpath(genpath(fullfile(data_path,rsa_tool_path)))
else
    based = 'C:\Users\smark\Documents\myExperiment\fMRInewExp\';
    data_path  = 'C:\Users\smark\Documents\myExperiment\fMRInewExp\data\';
    cleaned_data_path = '/data/smark/fmri_sub_preproc_dir/fsl2spmFix_BasisSetExp/sub-';
    data_path2 = 'C:\Users\smark\Documents\myExperiment\fMRInewExp\fmri_sub_preproc_dir\';
    spm_path = 'C:\Users\smark\Desktop\spm';
    addpath(genpath(fullfile(based,rsa_tool_path)))
    addpath(data_path2)
end
addpath(spm_path)
addpath(data_path)
% directory for temporary files:
Datafile = [data_path,'tempFiles/'];

% betas to use:
numPile= 10;
nMap = 4;
nSess = 4;
v = ones(1,numPile*nMap);
zeroBetas = 10 + 5 +2 +7;
bn0 =  [zeros(1,5) v zeros(1,zeroBetas)];%[zeros(1,5) v zeros(1,5)];%zeros in the end - betas for 5 maps,the catch, the start and the movement regressors + ventricles regressors
bn = [bn0 bn0 bn0 bn0];
bnb = [bn 0 0 0 0];
nwb = length(bn);
beta_num = sum(bn);
b_idx0 = 1:nwb;
b_idx = b_idx0(bn==1);

% participants number:
vnpar = [51,50,49,48,46,45,44,43,42,40,38:-1:34,32:-1:28,26:-1:18];

% load SPM.mat:
load([data_path,'sub',num2str(vnpar(nsb)),'/stats/',dirT,'/SPM.mat']);

nameDirO = [data_path,dirT,'/searchLightAllEvTim',sflag,'/sub',num2str(vnpar(nsb)),'/',areaM,'/'];
mkdir(nameDirO);
% the names of the images created by the searchlight:
outFiles = cell(1,nFiles);
for f=1:nFiles
    outFiles{f} = [nameDirO,nameSearchL,num2str(f),'.nii'];
end


% loading images:
inFiles = [];
for s = 1:nSess
    allfiles = cellstr(spm_select('FPList', [cleaned_data_path,num2str(vnpar(nsb)),'/sess0',num2str(s),'/'], '^r_cleaned_smoothed_.*.nii$'));%not warp!
    inFiles = [inFiles; allfiles];
end
% loading searchlight definitions:
nameDir = [data_path,'NativeSearchLightDefinitions/',areaM,'/',dirL,'/s',num2str(vnpar(nsb))];
load([nameDir,'/',nameSearchL,'.mat']);
runSearchlight_ShirleyRunNtempDdifName(L,inFiles,outFiles,@TimNormLoo_RSAtoolboxMatrixEoutNanInfAllEv,nsb,runN,Datafile,'optionalParams',{SPM});






