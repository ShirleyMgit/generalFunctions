function savePileBeta_Blob(sb,nameAna,dirT,numF,nameMask)

% participants number:
vnpar = [51,50,49,48,46,45,44,43,42,40,38:-1:34,32:-1:28,26:-1:24,22:-1:18];

spm_path = '/data/smark/spm';
data_path = '/data/smark/fmri_sub_preproc_dir/';
blob_data_path = fullfile('/data','smark','fmri_sub_preproc_dir','BlobData',['sub',num2str(vnpar(sb))],[nameAna,'_',nameMask],dirT);
if ~exist(blob_data_path)
    mkdir(blob_data_path)
end
maskFolder = fullfile(data_path,'ROI_masks');
addpath(spm_path)

stat_Folder = fullfile(data_path,['sub',num2str(vnpar(sb))],'stats',dirT);
stat_Folder_mask = fullfile(stat_Folder,nameAna,nameMask);
if ~exist(stat_Folder_mask)
    mkdir(stat_Folder_mask);
end
maskFullPath= fullfile(maskFolder,[nameMask,'.nii']);
con_tmp = spm_vol(maskFullPath); % SPM function to get image info
[ROI_dat1,XYZ1] = spm_read_vols(con_tmp,0);
Dm = ROI_dat1(:);
nvoxels = sum(Dm>0);
nameFiles = ['s6mni_',num2str(vnpar(sb)),'beta_0'];

Dblob = zeros(nvoxels,numF);

for f = 1:numF
    fileN1 = num2str(f);
    if f<10
        fileN1 = ['00',num2str(f)];
    else
        if f<100
            fileN1 = ['0',num2str(f)];
        end
    end
    fileName = fullfile(stat_Folder,[nameFiles,fileN1,'.nii']);
    fmaskN   = fullfile(stat_Folder_mask,[nameFiles,fileN1,'.nii']);
    maskImMine(maskFullPath, fileName,fmaskN ,0.5);
    con_tmp = spm_vol(fmaskN); % SPM function to get image info
    [ROI_dat1,XYZ1] = spm_read_vols(con_tmp,0);
    D1 = ROI_dat1(:);
    Dblob(:,f) = D1(Dm>0);
end

save(fullfile(blob_data_path,'Data.mat'),'Dblob');