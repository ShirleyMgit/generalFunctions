function runPileBeta_Cor_Melemnts_rsatoolboxCleanedD(nsb,areaM,dirT,nFiles,nameSearchL,dirL,nameOF,runN)
%runN  = 1;

%nameOF = 'corBeta_DistSpN_L200_MelementsNoNan2';%'corBeta_DistSpN_L200_MelementsNewC';%200V';
funPointer = @BetaCor_Pile_LooFixNormMElementsNoNanInf_RSAtoolboxCheckF;
nSess = 4;

% path definitions:
based = '/home/smark/fMRI_ana';
spm_path = '/data/smark/spm';
data_path = '/data/smark/fmri_sub_preproc_dir/';
cleaned_data_path = '/data/smark/fmri_sub_preproc_dir/fsl2spmFix_BasisSetExp/sub-';
addpath(spm_path)
addpath(data_path)
rsa_tool_path = 'rsatoolbox';
addpath(genpath(fullfile(data_path,rsa_tool_path)))

% directory for temporary files:
Datafile = [data_path,'tempFiles/'];
%%participants:
vnpar = [51,50,49,48,46,45,44,43,42,40,38:-1:34,32:-1:28,26:-1:18];

% load SPM.mat:
load([data_path,'sub',num2str(vnpar(nsb)),'/stats/',dirT,'/SPM.mat']);

nameDirO = [data_path,nameOF,'PileBcleanD_All/searchLightAll/',nameSearchL,'sub',num2str(vnpar(nsb)),'/',areaM,'/'];
mkdir(nameDirO);
% the names of the images created by the searchlight:
outFiles = cell(1,nFiles);
for f=1:nFiles
    outFiles{f} = [nameDirO,nameOF,num2str(f),'.nii'];
end

% loading images:
inFiles = [];
for s = 1:nSess
    allfiles = cellstr(spm_select('FPList', [cleaned_data_path,num2str(vnpar(nsb)),'/sess0',num2str(s),'/'], '^r_cleaned_smoothed_.*.nii$'));%not warp!
    inFiles = [inFiles; allfiles];
end
% loading searchlight definitions:
%nameDir = [data_path,'NativeSearchLightDefinitions/',areaM,'/',dirT,'/s',num2str(vnpar(nsb))];
%load([nameDir,'L200.mat']);
nameDir = [data_path,'NativeSearchLightDefinitions/',areaM,'/',dirL,'/s',num2str(vnpar(nsb))];
load([nameDir,'/',nameSearchL,'.mat']);
%runSearchlight_ShirleyRunNtempD(L,inFiles,outFiles,funPointer,nsb,runN,Datafile,'optionalParams',{SPM});comment
%ed on 11/10/20
runSearchlight_ShirleyRunNtempDdifName(L,inFiles,outFiles,funPointer,nsb,runN,Datafile,'optionalParams',{SPM});

