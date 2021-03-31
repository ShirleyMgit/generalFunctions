function H = TimNormLoo_RSAtoolboxMatrixEoutNanInfAllEv(RowData,SPM)
% RowData: raw data from searchlight
% this is the original Tim analysis with the area under the curve
flagCal = 1;
% take out Nan or inf:
mRowData = mean(RowData);
isNanOrInf = isnan(mRowData) + isinf(mRowData);
RowData2 = RowData(:,isNanOrInf==0);
% pre - whitening and calculate beta whights:
% default: normalize using all runs (overall):
% if wanted to be changed should add in the options: 'normmode':
% 'overall': Does the multivariate noise normalisation overall (default)
% 'runwise': Does the multivariate noise normalisation by run
%disp('in TimNormLOO fun \n');
[a,b]=size(RowData);
[a2,b2]=size(RowData);
if a~=a2||b~=b2
    disp('in TimNormLOO fun \n');
    disp(size(RowData));
    disp(size(RowData2));
end
[betaAll00,resMS,Sw_hat,beta_hat,shrinkage,trRR]=noiseNormalizeBeta(RowData2,SPM);%,varargin);

% which betas: (for later analysis)
numPile= 10;
nMap = 4;
nBlock = 5;
v = ones(1,numPile*nMap);
%v(rem(1:DistPerM*nMap*2,2)==1) = 1;
zeroBetas = 10 + 5 +2 +7;
bn0 =  [zeros(1,5) v zeros(1,zeroBetas)];%[zeros(1,5) v zeros(1,5)];%zeros in the end - betas for map 5,the catch, the start and the movement regressors + ventricles regressors
bn = [bn0 bn0 bn0 bn0];
bnb = [bn 0 0 0 0];
nwb = length(bn);
beta_num = sum(bn);
b_idx0 = 1:nwb;
b_idx = b_idx0(bn==1);

betaAll1 = betaAll00(b_idx,:);
mbeta = mean(betaAll1);
inanb = isnan(mbeta);
iinfb = isinf(mbeta);
isNanOrInf = inanb  + iinfb;
betaAll0 = betaAll1(:,isNanOrInf==0);

if sum(inanb)>0||sum(iinfb)
    disp('in TimNormLOO fun \n');
    disp(['num non inf: ', num2str(um(iinfb))])
    disp(['num non nan: ', num2str(um(inanb))])
    disp(size(betaAll00));
    disp(size(betaAll0));
    flagCal = 0;
end


if flagCal==1% if betas are OK calculate, otherwise put -10000 at that voxel
    np = 10;
    lvvoxels = length(betaAll0(1,:));
    betaAll1 = reshape(betaAll0,[40,4,lvvoxels]);
    betaAllLooAv = zeros(40,4,lvvoxels);
    
    nr = 1:4;
    %% LOO averages:
    for r = 1:4
        betaAllLooAv(:,r,:) = mean(betaAll1(:,nr~=r,:),2);
    end
    
    s1L = zeros(4,1);
    s2L = zeros(4,1);
    s3L = zeros(4,1);
    s4L = zeros(4,1);
    
    for r = 1:4
        
        %averages:
        %hex 1
        conSHex1av = squeeze(betaAllLooAv(1:10,r,:));
        conSHex1av = conSHex1av - repmat(mean(conSHex1av),np,1);%substract the mean over condition
        [U1,S1,V1] = svd(conSHex1av'*conSHex1av,'econ');%
        sh1 = diag(S1);
        ssh1 = sum(sh1);
        
        % hex 2
        conSHex2av = squeeze(betaAllLooAv(11:20,r,:));
        conSHex2av = conSHex2av - repmat(mean(conSHex2av),np,1);
        [U2,S2,V2] = svd(conSHex2av'*conSHex2av,'econ');%
        sh2 = diag(S2);
        ssh2 = sum(sh2);
        
        % cluster 1:
        conSC1av = squeeze(betaAllLooAv(21:30,r,:));
        conSC1av = conSC1av - repmat(mean(conSC1av),np,1);
        [U3,S3,V3] = svd(conSC1av'*conSC1av,'econ');%
        sh3 = diag(S3);
        ssh3 = sum(sh3);
        
        % cluster 2:
        conSC2av = squeeze(betaAllLooAv(31:40,r,:));
        conSC2av = conSC2av - repmat(mean(conSC2av),np,1);
        [U4,S4,V4] = svd(conSC2av'*conSC2av,'econ');%
        sh4 = diag(S4);
        ssh4 = sum(sh4);
        
        
        % run patterns:
        %hex 1
        conSHex1r = betaAll0((r-1)*40+1:(r-1)*40+10,:);
        conSHex1r =  conSHex1r - repmat(mean(conSHex1r),np,1);
        [~,Sr,~] = svd(conSHex1r'*conSHex1r,'econ');%
        sh1r = diag(Sr);
        ssh1r = sum(sh1r);
        %hex 2
        conSHex2r = betaAll0((r-1)*40+11:(r-1)*40+20,:);
        conSHex2r = conSHex2r - repmat(mean(conSHex2r),np,1);
        [~,S2r,~] = svd(conSHex2r'*conSHex2r,'econ');
        sh2r = diag(S2r);
        ssh2r = sum(sh2r);
        %cluster 1:
        conSC1r = betaAll0((r-1)*40+21:(r-1)*40+30,:);
        conSC1r = conSC1r - repmat(mean(conSC1r),np,1);
        [~,S3r,~] = svd(conSC1r'*conSC1r,'econ');
        sh3r = diag(S3r);
        ssh3r = sum(sh3r);
        %cluster 2:
        conSC2r = betaAll0((r-1)*40+31:(r-1)*40+40,:);
        conSC2r = conSC2r - repmat(mean(conSC2r),np,1);
        [~,S4r,~] = svd(conSC2r'*conSC2r,'econ');
        sh4r = diag(S4r);
        ssh4r = sum(sh4r);
        
        %projections:
        % To hex 1:
        pr1 = zeros(4,lvvoxels);
        % project to eigenvectors
        P11 = (conSHex1r*U1).^2;
        P21 = (conSHex2r*U1).^2;
        P31 = (conSC1r*U1).^2;
        P41 = (conSC2r*U1).^2;
        % sum variance explained
        pr1(1,:) = sum(P11)/ssh1r;
        pr1(2,:) = sum(P21)/ssh2r;
        pr1(3,:) = sum(P31)/ssh3r;
        pr1(4,:) = sum(P41)/ssh4r;
        % calculate area under the curve
        v1L = cumsum(pr1,2);
        s1L(:,r)  = sum(v1L,2);%sum(0.5*(v1L(:,2:end) + v1L(:,1:end-1)),2);
        
        % To hex 2:
         pr2 = zeros(4,lvvoxels);
        % project to eigenvectors
        P12 = (conSHex1r*U2).^2;
        P22 = (conSHex2r*U2).^2;
        P32 = (conSC1r*U2).^2;
        P42 = (conSC2r*U2).^2;
      % sum variance explained
        pr2(1,:) = sum(P12)/ssh1r;
        pr2(2,:) = sum(P22)/ssh2r;
        pr2(3,:) = sum(P32)/ssh3r;
        pr2(4,:) = sum(P42)/ssh4r;
        % calculate area under the curve
        v2L = cumsum(pr2,2);
        s2L(:,r)  = sum(v2L,2);%sum(0.5*(v1L(:,2:end) + v1L(:
        
        % To cluster 1:
        pr3 = zeros(4,lvvoxels);
        % project to eigenvectors
        P13 = (conSHex1r*U3).^2;
        P23 = (conSHex2r*U3).^2;
        P33 = (conSC1r*U3).^2;
        P43 = (conSC2r*U3).^2;
      % sum variance explained
        pr3(1,:) = sum(P13)/ssh1r;
        pr3(2,:) = sum(P23)/ssh2r;
        pr3(3,:) = sum(P33)/ssh3r;
        pr3(4,:) = sum(P43)/ssh4r;
        % calculate area under the curve
        v3L = cumsum(pr3,2);
        s3L(:,r)  = sum(v3L,2);%sum(0.5*(v1L(:,2:end) + v1L(:
        
        % To cluster 2:
        pr4 = zeros(4,lvvoxels);
        % project to eigenvectors
        P14 = (conSHex1r*U4).^2;
        P24 = (conSHex2r*U4).^2;
        P34 = (conSC1r*U4).^2;
        P44 = (conSC2r*U4).^2;
      % sum variance explained
        pr4(1,:) = sum(P14)/ssh1r;
        pr4(2,:) = sum(P24)/ssh2r;
        pr4(3,:) = sum(P34)/ssh3r;
        pr4(4,:) = sum(P44)/ssh4r;
        % calculate area under the curve
        v4L = cumsum(pr4,2);
        s4L(:,r)  = sum(v4L,2);%sum(0.5*(v1L(:,2:end) + v1L(:
        
    end
    
    ms1 = mean(s1L,2);
    ms2 = mean(s2L,2);
    ms3 = mean(s3L,2);
    ms4 = mean(s4L,2);
    
    % normalization constant: not really needed if doing ttest but good to have
    % this issue in mind.
    
    % SNRc = ms1(1)+ms2(2)+ms3(3)+ms4(4);
    %
    % % Hex structure information
    % isHex= (ms2(1) + ms1(2) - (ms4(1) + ms3(2)))/SNRc;
    % % Cluster structure information
    % isCluster = (ms3(4) + ms4(3)- (ms1(4) + ms2(3)))/SNRc;
    % % Stimulus A:
    % isA = (ms1(4) + ms4(1) - (ms3(4) + ms2(1)))/SNRc;
    % % Stimulus B:
    % isB = (ms3(2)+ms2(3) - (ms1(2) + ms4(3)))/SNRc;
    
    H = zeros(1,16);
    H(1:4) = ms1;
    H(5:8) = ms2;
    H(9:12) = ms3;
    H(13:16) = ms4;
    
else
    H = -10000*ones(1,16);
end

