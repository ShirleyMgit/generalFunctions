function savePileBetaSingMaps(mROI_dat,vD,nSub,nameDir,ROI,nameAnaOf,onlyZ)
anaDir = [nameDir,'/',nameAnaOf];
mkdir(anaDir)


% same Map - stimulus:
% proHex11st = squeeze(mROI_dat(:,:,:,:,1)) - squeeze(mROI_dat(:,:,:,:,13));
% proHex22st = squeeze(mROI_dat(:,:,:,:,6)) - squeeze(mROI_dat(:,:,:,:,10));
% proHexsameSt = proHex11st + proHex22st;
% 
% proCl11st = squeeze(mROI_dat(:,:,:,:,11)) - squeeze(mROI_dat(:,:,:,:,7));
% proCl22st = squeeze(mROI_dat(:,:,:,:,16)) - squeeze(mROI_dat(:,:,:,:,4));
% proClsameSt = proCl11st + proCl22st ;
% 
% proBothSameSt = proHexsameSt + proClsameSt;
% % save p, t-maps:
% saveImResult(proBothSameSt,vD,'proBothSameMcolNew',nSub,anaDir,ROI,onlyZ);
% saveImResult(proHexsameSt,vD,'proHexsameMcolNew',nSub,anaDir,ROI,onlyZ);
% saveImResult(proClsameSt,vD,'proClsameMcolNew',nSub,anaDir,ROI,onlyZ);
% 
% disp('saved same Map - stimulus');

% save Contrast (subject level)
% saveCImResult(proBothSameSt,vD,'proBothSameMcolNew',nSub,anaDir,ROI,onlyZ);
% saveCImResult(proHexsameSt,vD,'proHexsameMcolNew',nSub,anaDir,ROI,onlyZ);
% saveCImResult(proClsameSt,vD,'proClsameMcolNew',nSub,anaDir,ROI,onlyZ);

% same Map - nothing
proHex11st = squeeze(mROI_dat(:,:,:,:,1)) - squeeze(mROI_dat(:,:,:,:,9));
proHex22st = squeeze(mROI_dat(:,:,:,:,6)) - squeeze(mROI_dat(:,:,:,:,14));

proCl11st = squeeze(mROI_dat(:,:,:,:,11)) - squeeze(mROI_dat(:,:,:,:,3));
proCl22st = squeeze(mROI_dat(:,:,:,:,16)) - squeeze(mROI_dat(:,:,:,:,8));

% save p, t-maps:
saveImResult(proHex11st ,vD,'proHex1SameMap_noncol',nSub,anaDir,ROI,onlyZ);
saveImResult(proHex22st ,vD,'proHex2SameMap_noncol',nSub,anaDir,ROI,onlyZ);
saveImResult(proCl11st,vD,'proCl1sameMap_noncol',nSub,anaDir,ROI,onlyZ);
saveImResult(proCl22st,vD,'proCl2sameMap_noncol',nSub,anaDir,ROI,onlyZ);

disp('saved same Map - non');

% saveImResult(proHex_all,vD,'proHex_colallnew',nSub,anaDir,ROI,onlyZ);% on the 26.2 in  the morning I forgot the col
% saveImResult(proCl_all,vD,'proCl_allcolnew',nSub,anaDir,ROI,onlyZ);
% saveImResult(proBoth_all,vD,'proBoth_allcolnew',nSub,anaDir,ROI,onlyZ);
% 
% disp('saved same all');

% save Contrast (subject level)
% saveCImResult(proBothSameSt,vD,'proBothSameMap_noncol',nSub,anaDir,ROI,onlyZ);
% saveCImResult(proHexsameSt,vD,'proHexsameMap_noncol',nSub,anaDir,ROI,onlyZ);
% saveCImResult(proClsameSt,vD,'proClsameMap_noncol',nSub,anaDir,ROI,onlyZ);
% 
% saveCImResult(proHex_all,vD,'proHex_colallnew',nSub,anaDir,ROI,onlyZ);% on the 26.2 in  the morning I forgot the col
% saveCImResult(proCl_all,vD,'proCl_allcolnew',nSub,anaDir,ROI,onlyZ);
% saveCImResult(proBoth_all,vD,'proBoth_allcolnew',nSub,anaDir,ROI,onlyZ);
end

function saveImResult(dataM,vD,nameAnaO,nSub,nameDir,ROI,onlyZ)
nVox = prod(vD);
dataV = reshape(dataM,nVox,nSub);
vT = zeros(nVox,1);
vP = zeros(nVox,1);
vZ = zeros(nVox,1);
for vx = 1:nVox
    if onlyZ==0
        [~,vP(vx),~,stats] = ttest(dataV(vx,:)',0,'tail','right');
        vT(vx)           = stats.tstat;
    end
    
    %mvz = mean(dataV(vx,:));
    vZ(vx) = mean(dataV(vx,:))/(std(dataV(vx,:))/sqrt(nSub));
    %[~,zp,~,vZ(vx)] = ztest(dataV(vx,:)',0,'tail','right');%mvz/std(dataV(vx,:));
end

Z = reshape(vZ,vD);
Vz = ROI;
Vz.fname = fullfile(nameDir,['Zmap_',nameAnaO,'.nii']);
if onlyZ==0
    vP = 1-vP;
    T = reshape(vT,vD);
    P = reshape(vP,vD);
    V = ROI;
    V.fname = fullfile(nameDir,['Ttmap_',nameAnaO,'.nii']);
    Vp = ROI;
    Vp.fname = fullfile(nameDir,['Ptmap_',nameAnaO,'.nii']);

    V2 = spm_write_vol(V,T);
    V3 = spm_write_vol(Vp,P);
end
V4 = spm_write_vol(Vz,Z);
disp(['in save image: ' ,nameAnaO]);
end