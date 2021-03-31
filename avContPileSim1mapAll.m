function avContPileSim1mapAll(dirT,anaName,areaM,ncon1,ncon2,isAll)

spm_path = '/data/smark/spm';
data_path = '/data/smark/fmri_sub_preproc_dir/';
addpath(spm_path)
addpath(data_path)

dirAll = fullfile(data_path,'contrastANDbehaviour',dirT,anaName,areaM);

if isAll==1
    Im1 = fullfile(dirAll,['map1and2SpearmanDistCor.nii']);
    Im2 = fullfile(dirAll,['map3and4SpearmanDistCor.nii']);
    fileName = fullfile(dirAll,['mapAllSpearmanDistCor.nii']);
else
    Im1 = fullfile(dirAll,['map',ncon1,'SpearmanDistCor'],'spmT_0001.nii');
    Im2 = fullfile(dirAll,['map',ncon2,'SpearmanDistCor'],'spmT_0001.nii');
    fileName = fullfile(dirAll,['map',ncon1,'and',ncon2,'SpearmanDistCor.nii']);
end
makeAv2images(Im1,Im2,fileName)