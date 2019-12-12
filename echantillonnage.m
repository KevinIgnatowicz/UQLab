rng(100, 'twister')
uqlab

InputOpts.Marginals(1).Type = 'Uniform';
InputOpts.Marginals(1).Parameters = [0.41e-3 4.32e-3];
InputOpts.Marginals(2).Type = 'Uniform';
InputOpts.Marginals(2).Parameters = [0.072 3.041];
InputOpts.Marginals(3).Type = 'Uniform';
InputOpts.Marginals(3).Parameters = [1 2.5];

myInput = uq_createInput(InputOpts);
X_LHS = uq_getSample(190, 'LHS');

K = 'K_HAX_Full';
K_txt = strcat(K, '.txt');
R = 'Ratio_HAX_Full';
R_txt = strcat(R, '.txt');
S = 'Scorr_HAX_Full';
S_txt = strcat(S, '.txt');

K_mat = X_LHS(:,1);
Ratio_mat = X_LHS(:,2);
Scorr_mat = X_LHS(:,3);

eval([K '= K_mat']);
eval([R '= Ratio_mat']);
eval([S '= Scorr_mat']);
   cd ..
   cd Full_Analysis
   cd Input
    output = evalc(K);
        fid = fopen(K_txt, 'wt');
        fwrite(fid, output);
        fclose(fid);
        
        output = evalc(R);
        fid = fopen(R_txt, 'wt');
        fwrite(fid, output);
        fclose(fid);
        
        output = evalc(S);
        fid = fopen(S_txt, 'wt');
        fwrite(fid, output);
        fclose(fid);

 scatter3(K_mat, Ratio_mat, Scorr_mat)
 
 cd ..
 cd ..
 cd Matlab_uq