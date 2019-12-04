function post_process_h(a,n, type)   %HAX : a = 1 ; HKC : a = 2, n nombre de simulations du lot; moyenne : type = 1, max : type = 2, position max : type = 3,
% local : type = 4; executer dans BBDesign


if a  == 1 
        
    
cd HAX

mkdir h_moy
H_MOY = zeros(n,1);
nom_moy = 'hc_moy';
nom_moy_txt = strcat(nom_moy, '.csv');

mkdir h_max
H_MAX = zeros(n,1);
nom_max = 'hc_max';
nom_max_txt = strcat(nom_max, '.csv');

mkdir position_max
POS_MAX = zeros(n,1);
nom_pos = 'pos_max';
nom_pos_txt = strcat(nom_pos, '.csv');

mkdir h_local
H_LOCAL = zeros(n,113);
nom_local = 'hc_local';
nom_local_txt = strcat(nom_local, '.csv');

cd surface_flow_data_hax

DIR = dir;


for i = 3:size(DIR,1)
    
    S = DIR(i).name;
    
    DATA = readtable(S);
    
    DATA(:,18)=[];
    DATA(114:end,:)=[];
    
    Surface_flow = table2array(DATA);
    
    X_coord= Surface_flow(:,1);
    HF = Surface_flow(:,15);
   
  cd ..
  cd surface_flow_csv_hax
  
  Dir = dir;
  
  s = Dir(i).name;
    
    Data = readtable(s);
    
    Surface_flow_csv = table2array(Data);
    
    deltaPrt = Surface_flow_csv(:,7);
    
    hc = -HF./(320-300.*(1+(0.9+deltaPrt).^(1/3)*0.2*0.2^2));
    
    
    H_MOY(i-2,1) = mean(hc(:,1));
   [H_MAX(i-2,1), I] = max(hc(:,1));
    POS_MAX(i-2,1) = X_coord(I);
    H_LOCAL(i-2,:) = hc';
cd ..
cd surface_flow_data_hax
end
cd ..
eval([nom_moy '= H_MOY']);   
   cd h_moy
    output = evalc(nom_moy);
        fid = fopen(nom_moy_txt, 'wt');
        fwrite(fid, output);
        fclose(fid);
   
cd ..   
eval([nom_max '= H_MAX']);
   cd h_max
    output = evalc(nom_max);
        fid = fopen(nom_max_txt, 'wt');
        fwrite(fid, output);
        fclose(fid);
        
cd ..   
eval([nom_pos '= POS_MAX']);
   cd position_max
    output = evalc(nom_pos);
        fid = fopen(nom_pos_txt, 'wt');
        fwrite(fid, output);
        fclose(fid);

cd ..   
eval([nom_local '= H_LOCAL']);
   cd h_local
    output = evalc(nom_local);
        fid = fopen(nom_local_txt, 'wt');
        fwrite(fid, output);
        fclose(fid);
cd ..
cd Input
K = xlsread('K_HAX.xlsx');
Ratio = xlsread('RATIO_HAX.xlsx');
Scorr = xlsread('Scorr_HAX.xlsx');

X = [Ratio(1:13) Scorr(1:13)];
cd ..
cd ..
end
%--------------------------------------------------------------------------%

if a  == 2 
        
    
cd HKC

mkdir h_moy
H_MOY = zeros(n,1);
nom_moy = 'hc_moy';
nom_moy_txt = strcat(nom_moy, '.txt');

mkdir h_max
H_MAX = zeros(n,1);
nom_max = 'hc_max';
nom_max_txt = strcat(nom_max, '.txt');

mkdir position_max
POS_MAX = zeros(n,1);
nom_pos = 'pos_max';
nom_pos_txt = strcat(nom_pos, '.txt');

mkdir h_local
H_LOCAL = zeros(n,113);
nom_local = 'hc_local';
nom_local_txt = strcat(nom_local, '.txt');

cd surface_flow_data_hkc

DIR = dir;


for i = 3:size(DIR,1)
    
    S = DIR(i).name;
    
    DATA = readtable(S);
    
    DATA(:,18)=[];
    DATA(114:end,:)=[];
    
    Surface_flow = table2array(DATA);
    
    X_coord= Surface_flow(:,1);
    HF = Surface_flow(:,15);
   
  cd ..
  cd surface_flow_csv_hkc
  
  Dir = dir;
  
  s = Dir(i).name;
    
    Data = readtable(s);
    
    Surface_flow_csv = table2array(Data);
    
    deltaPrt = Surface_flow_csv(:,7);
    
    hc = -HF./(320-300.*(1+(0.9+deltaPrt).^(1/3)*0.2*0.2^2));
    
    
    H_MOY(i-2,1) = mean(hc(:,1));
   [H_MAX(i-2,1), I] = max(hc(:,1));
    POS_MAX(i-2,1) = X_coord(I);
    H_LOCAL(i-2,:) = hc';
cd ..
cd surface_flow_data_hkc
end
cd ..
eval([nom_moy '= H_MOY']);   
   cd h_moy
    output = evalc(nom_moy);
        fid = fopen(nom_moy_txt, 'wt');
        fwrite(fid, output);
        fclose(fid);
   
cd ..   
eval([nom_max '= H_MAX']);
   cd h_max
    output = evalc(nom_max);
        fid = fopen(nom_max_txt, 'wt');
        fwrite(fid, output);
        fclose(fid);
        
cd ..   
eval([nom_pos '= POS_MAX']);
   cd position_max
    output = evalc(nom_pos);
        fid = fopen(nom_pos_txt, 'wt');
        fwrite(fid, output);
        fclose(fid);

cd ..   
eval([nom_local '= H_LOCAL']);
   cd h_local
    output = evalc(nom_local);
        fid = fopen(nom_local_txt, 'wt');
        fwrite(fid, output);
        fclose(fid);
cd ..
cd Input
K = xlsread('K_HKC.xlsx');
Ratio = xlsread('RATIO_HKC.xlsx');

X = [K Ratio];

cd ..
cd ..
end

if type == 1
    
    Y = H_MOY(:,1);
end
if type ==2
    Y = H_MAX(:,1);
end
if type == 3
    Y = POS_MAX(:,1);
end
  Metamodel_Sobol_BBD(X, Y, 1)  
end