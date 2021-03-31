function makePileBetaMaps(isPC,dirT,nameAna,nSm)


nFiles = 16;%64;%
rsa_tool_path = 'rsatoolbox';
if isPC==0
    based = '/home/smark/fMRI_ana';
    spm_path = '/data/smark/spm';
    data_path = '/data/smark/fmri_sub_preproc_dir/';
    addpath(genpath(fullfile(data_path,rsa_tool_path)))
else
    based = 'C:\Users\smark\Documents\myExperiment\fMRInewExp\';
    spm_path = 'C:\Users\smark\Desktop\spm';
    data_path = 'C:\Users\smark\Documents\myExperiment\fMRInewExp\fmri_sub_preproc_dir\';
    cd(based)
    %addpath(spm_path)
end
addpath(spm_path)
% participants directories:
vnpar = [51,50,49,48,46,45,44,43,42,40,38:-1:34,32:-1:28,26:-1:24,22:-1:18];
vnparAll = [51,50,49,48,46,45,44,43,42,40,38:-1:34,32:-1:28,26:-1:18];
nSub = length(vnpar);
% area mask for searchlight:
areaM = 'wholeBrainMcorrect';%'IIT_MeanT1_2x2x2';%'FrontalTemporalHippoMask';%'temporalLobeHippocampuseEC';%'HippocampuseEC';%'HippocampusMask2';


mROI_dat = zeros(91,109,91,nSub,nFiles);
for sb = 1:nSub
    nameAnaO = ['s',num2str(nSm),nameAna,'nSub',num2str(nSub)];%,'45out'];
        
    nameDir = fullfile(data_path,dirT,'searchLightAllL200',['sub',num2str(vnpar(sb))],areaM);
    
    searchLightResFiles = cell(nFiles,1);
    for f=1:nFiles
        searchLightResFiles{f} = fullfile(nameDir,['s',num2str(nSm),'mni_',num2str(vnpar(sb)),nameAna,num2str(f),'.nii']);
 
        ROI           = spm_vol(searchLightResFiles{f});       % SPM function to get image info
        [ROI_dat,XYZ] = spm_read_vols(ROI,0);     % SPM function to get coordinates et al. based on image info
        mROI_dat(:,:,:,sb,f) = ROI_dat;
    end
end


SD = size(mROI_dat);
vD = SD(1:3);

nameDirAll = fullfile(data_path,dirT,'groupStat','searchLightResults',areaM,nameAna);
%nameDirAll = [data_path,dirT,'All/searchLightResults/',areaM,'/'];
if ~exist(nameDirAll)
    mkdir(nameDirAll);
end

%savePileBetaMaps(mROI_dat,vD,nSub,nameDirAll,ROI,nameAnaO,0);
savePileBetaSingMaps(mROI_dat,vD,nSub,nameDirAll,ROI,nameAnaO,0);

end
