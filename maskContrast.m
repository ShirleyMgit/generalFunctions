function maskContrast(sb,dirT,ncon)

spm_path = '/data/smark/spm';
data_path = '/data/smark/fmri_sub_preproc_dir/';

addpath(spm_path)
addpath(data_path)

vnpar = [51,50,49,48,46,45,44,43,42,40,38:-1:34,32:-1:28,26:-1:18];
mask = fullfile(data_path,'masks','mni_mask.nii');
for contrast_loop = 1:ncon
    if contrast_loop<10
        conFile = fullfile(data_path,['sub',num2str(vnpar(sb))],'stats',dirT, ['s6mni_',num2str(vnpar(sb)),'con_000',num2str(contrast_loop),'.nii']);
        conFileMasked = fullfile(data_path,['sub',num2str(vnpar(sb))],'stats',dirT, ['s6mni_',num2str(vnpar(sb)),'con_000',num2str(contrast_loop),'_masked.nii']);
    else
        conFile = fullfile(data_path,['sub',num2str(vnpar(sb))],'stats',dirT, ['s6mni_',num2str(vnpar(sb)),'con_00',num2str(contrast_loop),'.nii']);
        conFileMasked = fullfile(data_path,['sub',num2str(vnpar(sb))],'stats',dirT, ['s6mni_',num2str(vnpar(sb)),'con_00',num2str(contrast_loop),'_masked.nii']);
    end
    MaskIm2fromIm1(mask,conFile,conFileMasked);
    disp(['done contrast: ',num2str(contrast_loop)])
end