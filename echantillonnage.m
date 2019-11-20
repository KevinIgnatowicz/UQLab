InputOpts.Marginals(1).Type = 'Uniform';
InputOpts.Marginals(1).Parameters = [0 1];
InputOpts.Marginals(2).Type = 'Uniform';
InputOpts.Marginals(2).Parameters = [0 5];

myInput = uq_createInput(InputOpts);
X_LHS = uq_getSample(10, 'LHS')