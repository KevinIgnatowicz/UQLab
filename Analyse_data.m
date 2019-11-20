clearvars
rng(100, 'twister')
uqlab

X = [0.1 0.2 0.8 0.52 0.4 0.9 0.72; 1 1.1 1.4 1.3 1.45 1.9 1.81]';
Y =[120 132 181 144 139 250 232]';

MetaOpts.ExpDesign.Sampling = 'User';
MetaOpts.ExpDesign.X = X;
MetaOpts.ExpDesign.Y = Y;
MetaOpts.Type = 'Metamodel';
MetaOpts.MetaType = 'Kriging';

myKriging = uq_createModel(MetaOpts);
uq_print(myKriging)
uq_display(myKriging)

SobolOpts.Type = 'Sensitivity';
SobolOpts.Method = 'Sobol';
SobolOpts.Sobol.Order = 1;

for ii = 1 : 2
IOpts.Marginals(ii).Type = 'Uniform' ;
IOpts.Marginals(ii).Parameters = [0+ii-1, ii] ;
end
myInput = uq_createInput(IOpts);

PCEOpts.Type = 'Metamodel';
PCEOpts.MetaType = 'PCE';
PCEOpts.FullModel = myKriging;
PCEOpts.Degree = 5;
PCEOpts.ExpDesign.NSamples = size(X,1);
myPCE = uq_createModel(PCEOpts);


mySobolAnalysis = uq_createAnalysis(SobolOpts)
uq_print(mySobolAnalysis)
uq_display(mySobolAnalysis)
