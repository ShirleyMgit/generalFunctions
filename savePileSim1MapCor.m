function savePileSim1MapCor(sub,mROI_dat,nameDirAll,ROI,DistMs)

sDir = fullfile(nameDirAll,['sub',num2str(sub)]);
if ~exist(sDir)
    mkdir(sDir);
end

[ROI_dat1,XYZ1] = spm_read_vols(ROI,0);
Dm = ROI_dat1(:);
vD = size(ROI_dat1);

nvoxels = length(mROI_dat(:,1));
dataM   = reshape(mROI_dat,nvoxels,100,4);

% make it distance messure:
cm1 = 1 - squeeze(dataM(:,:,1));
cm2 = 1 - squeeze(dataM(:,:,2));
cm3 = 1 - squeeze(dataM(:,:,3));
cm4 = 1 - squeeze(dataM(:,:,4));

mapC1 = zeros(nvoxels,1);
mapC2 = zeros(nvoxels,1);
mapC3 = zeros(nvoxels,1);
mapC4 = zeros(nvoxels,1);
for v = 1:nvoxels 
    mapC1(v) = corr(cm1(v,:)',DistMs.Hex(:),'type','Spearman');
    mapC2(v) = corr(cm2(v,:)',DistMs.Hex(:),'type','Spearman');
    mapC3(v) = corr(cm3(v,:)',DistMs.ClustBig(:),'type','Spearman');
    mapC4(v) = corr(cm4(v,:)',DistMs.ClustSmall(:),'type','Spearman');
end

% map1:
allMap1 = zeros(size(ROI_dat1));
allMap1 = allMap1(:);
allMap1(Dm>0) = mapC1;
allMap1 = reshape(allMap1,vD);
saveCImResultP1a(allMap1,'map1SpearmanDistCor',sDir,ROI)

% map2:
allMap2 = zeros(size(ROI_dat1));
allMap2 = allMap2(:);
allMap2(Dm>0) = mapC2;
allMap2 = reshape(allMap2,vD);
saveCImResultP1a(allMap2,'map2SpearmanDistCor',sDir,ROI)

% map3:
allMap3 = zeros(size(ROI_dat1));
allMap3 = allMap3(:);
allMap3(Dm>0) = mapC3;
allMap3 = reshape(allMap3,vD);
saveCImResultP1a(allMap3,'map3SpearmanDistCor',sDir,ROI)

% map4:
allMap4 = zeros(size(ROI_dat1));
allMap4 = allMap4(:);
allMap4(Dm>0) = mapC4;
allMap4 = reshape(allMap4,vD);
saveCImResultP1a(allMap4,'map4SpearmanDistCor',sDir,ROI)
