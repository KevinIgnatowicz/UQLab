function Metamodel_Sobol_BBD(X, Y, num) %num = 1; Kriging, PCE, Sobol; num = 2; PCE, Sobol
rng(100, 'twister')
uqlab

 
MetaOpts.ExpDesign.Sampling = 'User';
MetaOpts.ExpDesign.X = X;
MetaOpts.ExpDesign.Y = Y;
MetaOpts.Type = 'Metamodel';

MetaOpts.MetaType = 'PCE';
MetaOpts.Degree = 1:5;
%{
if num == 1 
MetaOpts.MetaType = 'PCK';
MetaOpts.Trend.Type = 'sequential';
MetaOpts.Trend.Degree = 2;
%MetaOpts.Trend.CustomF = [3 2];
%MetaOpts.Regression.SigmaNSQ = 'auto';
end

if num ==2
    
MetaOpts.Type = 'Metamodel';
MetaOpts.MetaType = 'PCE';

MetaOpts.Degree = 3;
MetaOpts.ExpDesign.NSamples = size(X,1);

%}
IOpts.Inference.Data = X;
IOpts.Copula.Type = 'Independent';
IOpts.Marginals.Type = 'auto' ;
myInput = uq_createInput(IOpts);

%end
myMetamodel = uq_createModel(MetaOpts);
uq_print(myMetamodel)
uq_display(myMetamodel)


YPCE = uq_evalModel(myMetamodel,X);
uq_figure

cmap = uq_colorOrder(2);
uq_histogram(Y, 'FaceColor', cmap(1,:))
hold on
uq_histogram(YPCE, 'FaceColor', cmap(2,:))
hold off

xlabel('$\mathrm{Y}$')
ylabel('Counts')
uq_legend(...
    {'True model response', 'PCE prediction'},...
    'Location', 'northwest')

SobolOpts.Type = 'Sensitivity';
SobolOpts.Method = 'Sobol';
SobolOpts.Sobol.Order = 1;


%{
if num ==1 
IOpts.Inference.Data = X;
IOpts.Copula.Type = 'Independent';
IOpts.Marginals.Type = 'auto' ;
myInput = uq_createInput(IOpts);
PCEOpts.Type = 'Metamodel';
PCEOpts.MetaType = 'PCE';
PCEOpts.FullModel = myMetamodel;
PCEOpts.Degree = 5;
PCEOpts.ExpDesign.NSamples = size(X,1);
myPCE = uq_createModel(PCEOpts);
end
%}
mySobolAnalysis = uq_createAnalysis(SobolOpts)
mySobolResultsPCE = mySobolAnalysis.Results;
uq_print(mySobolAnalysis)
uq_display(mySobolAnalysis)


%---------------------------------------------------------------------%
