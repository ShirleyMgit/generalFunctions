function makeAv2images(Im1,Im2,fileName)

    matlabbatch{1}.spm.util.imcalc.input = {Im1
                                            Im2 
                                            };
    matlabbatch{1}.spm.util.imcalc.output = fileName;
    matlabbatch{1}.spm.util.imcalc.outdir = {''};
    matlabbatch{1}.spm.util.imcalc.expression =  '0.5*(i2+i1)';
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{1}.spm.util.imcalc.options.interp = 1;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
    
    spm_jobman('run',matlabbatch);
