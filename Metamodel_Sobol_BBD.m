function Metamodel_Sobol_BBD(X, Y, num) %num = 1; Kriging, PCE, Sobol; num = 2; PCE, Sobol
uqlab

 
MetaOpts.ExpDesign.Sampling = 'User';
MetaOpts.ExpDesign.X = X;
MetaOpts.ExpDesign.Y = Y;
MetaOpts.Type = 'Metamodel';

if num == 1 
MetaOpts.MetaType = 'Kriging';
MetaOpts.Trend.Type = 'polynomial';
MetaOpts.Trend.Degree = 3;
%MetaOpts.Trend.CustomF = [3 2];
%MetaOpts.Regression.SigmaNSQ = 'auto';
end

if num ==2
    
MetaOpts.Type = 'Metamodel';
MetaOpts.MetaType = 'PCE';

MetaOpts.Degree = 3;
MetaOpts.ExpDesign.NSamples = size(X,1);
IOpts.Inference.Data = X;
IOpts.Copula.Type = 'Independent';
IOpts.Marginals.Type = 'auto' ;
myInput = uq_createInput(IOpts);

end
myMetamodel = uq_createModel(MetaOpts);
uq_print(myMetamodel)
uq_display(myMetamodel)

SobolOpts.Type = 'Sensitivity';
SobolOpts.Method = 'Sobol';
SobolOpts.Sobol.Order = 1;



if num ==1 
    
PCEOpts.Type = 'Metamodel';
PCEOpts.MetaType = 'PCE';
PCEOpts.FullModel = myMetamodel;
PCEOpts.Degree = 5;
PCEOpts.ExpDesign.NSamples = size(X,1);
myPCE = uq_createModel(PCEOpts);
end

mySobolAnalysis = uq_createAnalysis(SobolOpts)
mySobolResultsPCE = mySobolAnalysis.Results;
uq_print(mySobolAnalysis)
uq_display(mySobolAnalysis)

%---------------------------------------------------------------------%
