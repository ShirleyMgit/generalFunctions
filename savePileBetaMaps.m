function savePileBetaMaps(mROI_dat,vD,nSub,nameDir,ROI,nameAnaOf,onlyZ)
anaDir = [nameDir,'/',nameAnaOf];
mkdir(anaDir)

% structure - stimulus:
proHexSs1 = squeeze(mROI_dat(:,:,:,:,5)) - squeeze(mROI_dat(:,:,:,:,13));
proHexSs2 = squeeze(mROI_dat(:,:,:,:,2)) - squeeze(mROI_dat(:,:,:,:,10));
proHexSs = proHexSs1 + proHexSs2;

proClSs1 = squeeze(mROI_dat(:,:,:,:,15)) - squeeze(mROI_dat(:,:,:,:,7));
proClSs2 = squeeze(mROI_dat(:,:,:,:,12)) - squeeze(mROI_dat(:,:,:,:,4));
proClSs = proClSs1 + proClSs2;

proBothSs = proClSs + proHexSs;
% save p, t-maps:
saveImResult(proHexSs,vD,'proHexStrSCol',nSub,anaDir,ROI,onlyZ);
saveImResult(proClSs,vD,'proClStrSCol',nSub,anaDir,ROI,onlyZ);
saveImResult(proBothSs,vD,'proBothStrSCol',nSub,anaDir,ROI,onlyZ);

disp('saved strucutre-stim');

% structure - nothing:
proHexSsNon1 = squeeze(mROI_dat(:,:,:,:,5)) - squeeze(mROI_dat(:,:,:,:,9));
proHexSsNon2 = squeeze(mROI_dat(:,:,:,:,2)) - squeeze(mROI_dat(:,:,:,:,14));
proHexSsNon = proHexSsNon1 + proHexSsNon2;

proClSsNon1 = squeeze(mROI_dat(:,:,:,:,15)) - squeeze(mROI_dat(:,:,:,:,3));
proClSsNon2 = squeeze(mROI_dat(:,:,:,:,12)) - squeeze(mROI_dat(:,:,:,:,8));
proClSsNon = proClSsNon1 + proClSsNon2;

proBothSsNon = proClSsNon + proHexSsNon;
% save p, t-maps:
saveImResult(proHexSsNon,vD,'proHexStrNonCol',nSub,anaDir,ROI,onlyZ);
saveImResult(proClSsNon,vD,'proClStrNonCol',nSub,anaDir,ROI,onlyZ);
saveImResult(proBothSsNon,vD,'proBothStrNonCol',nSub,anaDir,ROI,onlyZ);

disp('saved strucutre-non');

% save Contrast (subject level)
% saveCImResult(proHexSsNon,vD,'proHexStrNonCol',nSub,anaDir,ROI,onlyZ);
% saveCImResult(proClSsNon,vD,'proClStrNonCol',nSub,anaDir,ROI,onlyZ);
% saveCImResult(proBothSsNon,vD,'proBothStronCol',nSub,anaDir,ROI,onlyZ);

% same Map - stimulus:
proHex11st = squeeze(mROI_dat(:,:,:,:,1)) - squeeze(mROI_dat(:,:,:,:,13));
proHex22st = squeeze(mROI_dat(:,:,:,:,6)) - squeeze(mROI_dat(:,:,:,:,10));
proHexsameSt = proHex11st + proHex22st;

proCl11st = squeeze(mROI_dat(:,:,:,:,11)) - squeeze(mROI_dat(:,:,:,:,7));
proCl22st = squeeze(mROI_dat(:,:,:,:,16)) - squeeze(mROI_dat(:,:,:,:,4));
proClsameSt = proCl11st + proCl22st ;

proBothSameSt = proHexsameSt + proClsameSt;
% save p, t-maps:
saveImResult(proBothSameSt,vD,'proBothSameMcolNew',nSub,anaDir,ROI,onlyZ);
saveImResult(proHexsameSt,vD,'proHexsameMcolNew',nSub,anaDir,ROI,onlyZ);
saveImResult(proClsameSt,vD,'proClsameMcolNew',nSub,anaDir,ROI,onlyZ);

disp('saved same Map - stimulus');

% save Contrast (subject level)
% saveCImResult(proBothSameSt,vD,'proBothSameMcolNew',nSub,anaDir,ROI,onlyZ);
% saveCImResult(proHexsameSt,vD,'proHexsameMcolNew',nSub,anaDir,ROI,onlyZ);
% saveCImResult(proClsameSt,vD,'proClsameMcolNew',nSub,anaDir,ROI,onlyZ);

% same Map - nothing
proHex11st = squeeze(mROI_dat(:,:,:,:,1)) - squeeze(mROI_dat(:,:,:,:,9));
proHex22st = squeeze(mROI_dat(:,:,:,:,6)) - squeeze(mROI_dat(:,:,:,:,14));
proHexsameSt = proHex11st + proHex22st;


proCl11st = squeeze(mROI_dat(:,:,:,:,11)) - squeeze(mROI_dat(:,:,:,:,3));
proCl22st = squeeze(mROI_dat(:,:,:,:,16)) - squeeze(mROI_dat(:,:,:,:,8));
proClsameSt = proCl11st + proCl22st ;

proBothSameSt = proHexsameSt + proClsameSt;

% all together:
proHex = squeeze(mROI_dat(:,:,:,:,1) + mROI_dat(:,:,:,:,2) + mROI_dat(:,:,:,:,5) + mROI_dat(:,:,:,:,6));
proHexCl = squeeze(mROI_dat(:,:,:,:,9) + mROI_dat(:,:,:,:,10) + mROI_dat(:,:,:,:,13) + mROI_dat(:,:,:,:,14) );
proHex_all = proHex - proHexCl;

proCl = squeeze(mROI_dat(:,:,:,:,11) + mROI_dat(:,:,:,:,12) + mROI_dat(:,:,:,:,15) + mROI_dat(:,:,:,:,16));
proClHex = squeeze(mROI_dat(:,:,:,:,3) + mROI_dat(:,:,:,:,4) + mROI_dat(:,:,:,:,7) + mROI_dat(:,:,:,:,8));
proCl_all = proCl - proClHex;

proBoth_all = proHex_all + proCl_all;

% save p, t-maps:
saveImResult(proBothSameSt,vD,'proBothSameMap_noncol',nSub,anaDir,ROI,onlyZ);
saveImResult(proHexsameSt,vD,'proHexsameMap_noncol',nSub,anaDir,ROI,onlyZ);
saveImResult(proClsameSt,vD,'proClsameMap_noncol',nSub,anaDir,ROI,onlyZ);

disp('saved same Map - non');

saveImResult(proHex_all,vD,'proHex_colallnew',nSub,anaDir,ROI,onlyZ);% on the 26.2 in  the morning I forgot the col
saveImResult(proCl_all,vD,'proCl_allcolnew',nSub,anaDir,ROI,onlyZ);
saveImResult(proBoth_all,vD,'proBoth_allcolnew',nSub,anaDir,ROI,onlyZ);

disp('saved same all');

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