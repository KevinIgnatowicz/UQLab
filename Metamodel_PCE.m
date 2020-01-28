function Metamodel_Sobol_BBD(X,Y)
rng(100, 'twister')
uqlab
order = size(X,2)-1;
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
MetaOpts.Degree = 1:20;
myMetamodel = uq_createModel(MetaOpts);
uq_print(myMetamodel)
uq_display(myMetamodel)
%---------------------------------------------------------------------%
%Evaluation of the metamodel
%Prediction on the same input as the CFD simulations
YPCE = uq_evalModel(myMetamodel,X);
%Generation of a large sample of random input and evaluation
X_LHS = uq_getSample(10000, 'LHS');
Y_META = uq_evalModel(myMetamodel, X_LHS);
%---------------------------------------------------------------------%
%Visualization of the output probability distribution functions
%Comparison with the true model
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
%Visualization on the large sample
uq_figure

cmap = uq_colorOrder(2);
uq_histogram(Y_META, 'FaceColor', cmap(1,:))
xlabel('$\mathrm{Y_META}$')
ylabel('Counts')
uq_legend(...
    {'PCE prediction'},...
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
SobolOpts.Sobol.Order = order;
mySobolAnalysis = uq_createAnalysis(SobolOpts)
mySobolResultsPCE = mySobolAnalysis.Results;
uq_print(mySobolAnalysis)
uq_display(mySobolAnalysis)

%---------------------------------------------------------------------%
%Evaluation of the output probability distribution

Output.Inference.Data = Y;
Output.Copula.Type = 'Independent';
Output.Marginals.Type = 'auto' ;
myOutput = uq_createInput(Output);
uq_print(myOutput)

Output.Inference.Data = YPCE;
Output.Copula.Type = 'Independent';
Output.Marginals.Type = 'auto' ;
myOutput = uq_createInput(Output);
uq_print(myOutput)

Output.Inference.Data = Y_META;
Output.Copula.Type = 'Independent';
Output.Marginals.Type = 'auto' ;
myOutput = uq_createInput(Output);
uq_print(myOutput)

end
%---------------------------------------------------------------------%
