function [] = mask1ImMine(Im1,fileName,safM)

    matlabbatch{1}.spm.util.imcalc.input = {Im1 %make a mask from Im1
                                            };
    matlabbatch{1}.spm.util.imcalc.output = fileName;
    matlabbatch{1}.spm.util.imcalc.outdir = {''};
    matlabbatch{1}.spm.util.imcalc.expression =  ['(i1<',num2str(safM),')'];
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{1}.spm.util.imcalc.options.interp = 1;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
    
    spm_jobman('run',matlabbatch);


end

