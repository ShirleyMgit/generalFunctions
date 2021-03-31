function H = BetaCor_DistSpN_LooFixNormMElementsNoNanInf_RSAtoolboxCheckF(RowData,SPM)
% RowData: raw data from searchlight

mRowData = mean(RowData);
isNanOrInf = isnan(mRowData) + isinf(mRowData);
RowData2 = RowData(:,isNanOrInf==0);

[a,b]=size(RowData);
[a2,b2]=size(RowData);
if a~=a2||b~=b2
    disp('in TimNormLOO fun \n');
    disp(size(RowData));
    disp(size(RowData2));
end
% pre - whitening and calculate beta whights:
% default: normalize using all runs (overall):
% if wanted to be changed should add in the options: 'normmode':
% 'overall': Does the multivariate noise normalisation overall (default)
% 'runwise': Does the multivariate noise normalisation by run
[betaAll00,resMS,Sw_hat,beta_hat,shrinkage,trRR]=noiseNormalizeBeta(RowData2,SPM);%,varargin);

% beta to use:
nMap = 4;
nBlock = 5;
v = zeros(1,nMap*3);% 3 regressors per map: all piles, distance, special nodes
wbDist = 2:3:12;% distance betas
wbSpN  = 3:3:12;% special nodes betas
v(wbDist) = 1;% take the distance regressor
v(wbSpN) = 1;% take the special regressor, both wil give 8x8 matrix
zeroBetas = 3 + 3 +7;
bn0 =  [zeros(1,5) v zeros(1,zeroBetas)];%[zeros(1,5) v zeros(1,5)];%zeros in the end - betas for 5 maps,the catch, the start and the movement regressors + ventricles regressors
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

flagCal = 1;
if sum(inanb)>0||sum(iinfb)
    disp('in TimNormLOO fun \n');
    disp(size(betaAll00));
    disp(['num non inf: ', num2str(um(iinfb))])
    disp(['num non nan: ', num2str(um(inanb))])
    disp(size(betaAll00));
    disp(size(betaAll0));
    flagCal = 0;
end

lvvoxels = length(betaAll0(1,:));
disp(lvvoxels);
betaAll1 = reshape(betaAll0,[8,4,lvvoxels]);
betaAllLooAv = zeros(8,4,lvvoxels);

nr = 1:4;
%% LOO averages:
for r = 1:4
    betaAllLooAv(:,r,:) = mean(betaAll1(:,nr~=r,:),2);
end

corMatallR = zeros(4,8,8);

if flagCal==1% if betas are OK calculate, otherwise put -10000 at that voxel
    for r = 1:4
        
        %averages:
        avOutB = squeeze(betaAllLooAv(:,r,:));
        avOutB = avOutB - repmat(mean(avOutB),8,1);
        avOutB = avOutB - repmat(mean(avOutB,2),1,lvvoxels);
        
        runB = squeeze(betaAll1(:,r,:));
        runB = runB - repmat(mean(runB),8,1);
        runB = runB - repmat(mean(runB,2),1,lvvoxels);
        
        corMat = runB*avOutB';
        n1 = sqrt(diag(runB*runB'));
        n2 = sqrt(diag(avOutB*avOutB'));
        normM =n1*n2';
        corMatallR(r,:,:) = corMat./normM;
        
    end
    
    mtcorMatallR = (squeeze(mean(atanh(corMatallR))));
    
    H = mtcorMatallR(:);% H is 64 elements vector.
    
else
    H = -10000*ones(64,1);
end
