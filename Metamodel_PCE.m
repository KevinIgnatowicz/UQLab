function Metamodel_Sobol_BBD(X,Y)
rng(100, 'twister')
uqlab
%---------------------------------------------------------------------%
%Creation of the inputs

IOpts.Inference.Data = X;
IOpts.Copula.Type = 'Independent';
IOpts.Marginals.Type = 'auto' ;
myInput = uq_createInput(IOpts);
uq_print(myInput)
%---------------------------------------------------------------------%
%Creation of the PCE metamodel
 
MetaOpts.ExpDesign.Sampling = 'User';
MetaOpts.ExpDesign.X = X;
MetaOpts.ExpDesign.Y = Y;
MetaOpts.Type = 'Metamodel';
MetaOpts.MetaType = 'PCE';
MetaOpts.Degree = 1:60;
myMetamodel = uq_createModel(MetaOpts);
uq_print(myMetamodel)
uq_display(myMetamodel)

%---------------------------------------------------------------------%
%Visualization of the output probability distribution functions
YPCE = uq_evalModel(myMetamodel,X);
uq_figure

cmap = uq_colorOrder(2);
uq_histogram(Y, 'FaceColor', cmap(1,:), 'Normalized', false)
hold on
uq_histogram(YPCE, 'FaceColor', cmap(2,:), 'Normalized', false)
hold off

xlabel('$\mathrm{Y}$')
ylabel('Counts')
uq_legend(...
    {'True model response', 'PCE prediction'},...
    'Location', 'northwest')

%---------------------------------------------------------------------%
%Visualization of the predicted vs true response
uq_figure

uq_plot(Y, YPCE, '+')
hold on
uq_plot([min(Y) max(Y)], [min(Y) max(Y)], 'k')
hold off

axis equal
axis([min(Y) max(Y) min(Y) max(Y)])

xlabel('$\mathrm{Y_{true}}$')
ylabel('$\mathrm{Y_{PCE}}$')
%---------------------------------------------------------------------%
%Creation of the Sobol Ananlysis
SobolOpts.Type = 'Sensitivity';
SobolOpts.Method = 'Sobol';
SobolOpts.Sobol.Order = 1;
mySobolAnalysis = uq_createAnalysis(SobolOpts)
mySobolResultsPCE = mySobolAnalysis.Results;
uq_print(mySobolAnalysis)
uq_display(mySobolAnalysis)

end
%---------------------------------------------------------------------%
