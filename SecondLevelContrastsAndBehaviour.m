function SecondLevelContrastsAndBehaviour(nameF,conStart,conEnd,Hrat,outF,maxS,addN,addN2)
% Second-level analysis of Distances Regressors Basis set
% experiment

goodP =1;
based = '/home/smark/fMRI_ana';
spm_path = '/data/smark/spm';
data_path = '/data/smark/fmri_sub_preproc_dir/';
cleaned_data_path = '/data/smark/fmri_sub_preproc_dir/fsl2spmFix_BasisSetExp/sub-';
%cd(based)
addpath(spm_path)
addpath(data_path)

fmri_path   = fullfile('/data','smark','fmri_sub_preproc_dir','contrastANDbehaviour');

addpath(fmri_path)

vnpar = [51,50,49,48,46,45,44,43,42,40,38:-1:34,32:-1:28,26:-1:18];
vnparG = [51,50,49,48,46,45,44,43,42,40,38:-1:34,32:-1:28,26:-1:24,22:-1:18];
if goodP ==1
    vnP = vnparG;
    nSub = length(vnparG);
else
    vnP = vnpar;
    nSub = length(vnpar);
end

typeDir =  nameF;
name_analysis = nameF;


area =  '';%'HippoEC';%'';%'EC';%'Hippo';%
name_analysis = [name_analysis,area,'nSub',num2str(nSub)];

switch area
    case 'Hippo'
        maskFile = [data_path,'HippoMask','.nii'];
        
    case 'EC'
        maskFile = [data_path,'broodman28mask','.nii'];
    case 'HippoEC'
        maskFile = [data_path,'rHippocampus_EC_fsl','.nii'];
    otherwise
        maskFile = '';
        
end
second_level_path = fullfile([fmri_path,name_analysis]);
mkdir(second_level_path);

load(fullfile(data_path,'vratCorMHall.mat'));
load(fullfile(data_path,'vratCorMCall.mat'));
adO = '';
if outF>0&&strcmp(addN,'numStep')~=1
    if Hrat==1
        vnP = vnP(vratCorMHall>outF);
        nSub = length(vnP);
        adO = ['H0',num2str(outF*100)];
        vratCorMCall = vratCorMCall(vratCorMHall>outF);
        vratCorMHall = vratCorMHall(vratCorMHall>outF);
    else
        vnP = vnP(vratCorMCall>outF);
        nSub = length(vnP);
        adO = ['0',num2str(outF*100)];
        vratCorMHall = vratCorMHall(vratCorMCall>outF);
        vratCorMCall = vratCorMCall(vratCorMCall>outF);
    end
end
if maxS>0&&strcmp(addN,'numStep')==1
    vnP = vnP(nStep4C<maxS);
    nSub = length(vnP);
    adO = ['mx',num2str(maxS)];
    nStep4H= nStep4H(nStep4C<maxS);
    nStep4C = nStep4C(nStep4C<maxS);
end
% load conrast names
cd(second_level_path)
% contrasts = {'picureMap','picureMapHexClu','pileHex1','distHex1','borderHex1','pileHex2','distHex2','borderHex2','distHex1a2','borderHex1a2','pileCluster1','distCluster1','conNCl1','pileCluster2','distCluster2','conNCl2','distCl1a2','conNCl1a2','distAll','catch','ventricles'};
%conNum = [4:28]
contrasts = {'picureMap_m','picureMapHexClu_m','pileHex1_m','distHex1_m','borderHex1_m','pileHex2_m','distHex2_m','borderHex2_m','distHex1a2_m','borderHex1a2_m', 'dist_borderHex1a2','border_mDistHex1a2','pileCluster1_m','distCluster1_m','conNCl1_m','pileCluster2_m','distCluster2_m','conNCl2_m','distCl1a2_m','distAll','conNCl1a2_m', 'conNdistCl1a2','catch_m','ventricles_m'};

conNum = 1:length(contrasts);

cd(based)

for contrast_loop=conStart:conEnd
    newdir = fullfile(second_level_path,([contrasts{contrast_loop},'behaviour',addN,addN2,adO]));
    %newdir = fullfile(second_level_path,([contrasts{contrast_loop},'behaviour',addN)]);
    mkdir(newdir)
    disp(contrast_loop)
    % delete previous model if existed
    clear matlabbatch
    
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_move.files = cellstr(spm_select('FPList', newdir));
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_move.action.delete = false;
    
    spm_jobman('run', matlabbatch)
    
    fprintf('------------ deleted previous files for %s ------------\n',(contrasts{contrast_loop}))
    
    clear matlabbatch
    
    % specify new contrast
    clear matlabbatch
    
    matlabbatch{1}.spm.stats.factorial_design.dir = {newdir};
    
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans={};
    
    for subj_loop = 1:nSub
        if conNum(contrast_loop)<10
            con_file = cellstr(spm_select('FPList', [data_path,'sub',num2str(vnP(subj_loop)),'/stats/',typeDir,'/'], ['^s6mni_',num2str(vnP(subj_loop)),'con_000',num2str(contrast_loop),'_masked.nii$']));
        else
            con_file = cellstr(spm_select('FPList', [data_path,'sub',num2str(vnP(subj_loop)),'/stats/',typeDir,'/'], ['^s6mni_',num2str(vnP(subj_loop)),'con_00',num2str(contrast_loop),'_masked.nii$']));
        end
        disp('now display contrast files found:')
        disp([data_path,'sub',num2str(vnpar(subj_loop)),'/stats/',typeDir,'/'])
        disp(con_file);
        matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = [matlabbatch{1}.spm.stats.factorial_design.des.t1.scans; con_file];
    end
    
    matlabbatch{1}.spm.stats.factorial_design.cov(1).c = vratCorMHall;
    matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'Hex distance estimation';
    matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
    matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 1;
    matlabbatch{1}.spm.stats.factorial_design.cov(2).c = vratCorMCall;
    matlabbatch{1}.spm.stats.factorial_design.cov(2).cname = 'cluster distance estimation';
    matlabbatch{1}.spm.stats.factorial_design.cov(2).iCFI = 1;
    matlabbatch{1}.spm.stats.factorial_design.cov(2).iCC = 1;
    matlabbatch{1}.spm.stats.factorial_design.multi_cov.files = {};
    matlabbatch{1}.spm.stats.factorial_design.multi_cov.iCFI = 1;
    matlabbatch{1}.spm.stats.factorial_design.multi_cov.iCC = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
    matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
    
    spm_jobman('run', matlabbatch)
    fprintf('------------ specify model done for contrast %d ------------\n',contrast_loop)
    
    
    clear matlabbatch
    
    currdir = newdir;
    
    matlabbatch{1}.spm.stats.fmri_est.spmmat           = {[currdir,'/SPM.mat']};
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
    
    spm_jobman('run', matlabbatch)
    fprintf('------------ estimate done for contrast %d ------------\n',contrast_loop)
    
    
    clear matlabbatch
    
    currdir                                              = newdir;
    matlabbatch{1}.spm.stats.con.spmmat                  = {[currdir,'/SPM.mat']};
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name    = char(contrasts(contrast_loop));
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = 1;
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'repl';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name    = char([contrasts(contrast_loop), 'Hex dist']);
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [0 1];
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'repl';
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.name    = char([contrasts(contrast_loop), 'cluster dist']);
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = [0 0 1];
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'repl';
    matlabbatch{1}.spm.stats.con.delete                  = 1;
    
    spm_jobman('run', matlabbatch)
    fprintf('------------ contrasts done for contrast %d ------------\n',contrast_loop)
    
    
end

fprintf('------------ all done 2nd level mate. ------------\n')