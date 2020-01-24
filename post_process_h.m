function post_process_h(a, h_or_ice, type)   
%HAX : a = 1 ; HKC : a = 2;
%h_or_ice = 1 : coeff convectif// moyenne : type = 0.1, max : type = 0.2, position max : type = 0.3,
% local : type = index,  id du point sur la surface (1-100); 
% h_or_ice = 2 : accrétion de glace// moyenne : type = 0.1, max : type =
% 0.2, etendue : type = 0.3, local : type = index, id du point sur la
% surface (1-10000)
%executer dans Full_Analysis


if a  == 1 
      n=190;  
   if h_or_ice == 1  
cd HAX

mkdir h_moy
H_MOY = zeros(n,1);

mkdir h_max
H_MAX = zeros(n,1);

mkdir position_max
POS_MAX = zeros(n,1);

mkdir h_local
H_LOCAL = zeros(n,100);

cd surface_flow_data_hax

DIR = dir;


for i = 3:size(DIR,1)
    
    S = DIR(i).name;
    
    DATA = readtable(S);
    
    DATA(:,18)=[];
    DATA(114:end,:)=[];
    DATA(1:13,:)=[];
    
    Surface_flow = table2array(DATA);
    
    X_coord= Surface_flow(:,1);
    HF = Surface_flow(:,15);
   
  cd ..
  cd surface_flow_csv_hax
  
  Dir = dir;
  
  s = Dir(i).name;
    
    Data = readtable(s);
    
    Surface_flow_csv = table2array(Data);
    
    
    
    hc = -HF./(273.15-262.04.*(1+(0.72).^(1/3)*0.2*0.2^2));
    
    
    H_MOY(i-2,1) = mean(hc(:,1));
   [H_MAX(i-2,1), I] = max(hc(:,1));
    POS_MAX(i-2,1) = X_coord(I);
    H_LOCAL(i-2,:) = hc';
cd ..
cd surface_flow_data_hax
end
cd ..   
   cd h_moy
    xlswrite('hc_moy.xlsx', H_MOY)
   
cd ..   
   cd h_max
    xlswrite('hc_max.xlsx', H_MAX)
        
cd ..   
   cd position_max
    xlswrite('pos_max.xlsx', POS_MAX)

cd ..   
   cd h_local
    xlswrite('hc_local_hax.xlsx', H_LOCAL )
cd ..
   else
    cd Results_ice_HAX
    EP_MAX= xlsread('epaisseur_max.xlsx');
    EP_MOY= xlsread('epaisseur_moy.xlsx');
    ETENDUE= xlsread('etendue.xlsx');
    ICE_LOCAL = xlsread('y_ice_local.xlsx');
    ICE_LOCAL(191:192,:)=[];
    cd ..
    cd HAX
   end
    
cd Input
K = xlsread('K_HAX_Full.xlsx');
Ratio = xlsread('Ratio_HAX_Full.xlsx');
Scorr = xlsread('Scorr_HAX_Full.xlsx');

X = [K Ratio Scorr];

cd ..
cd ..
end
%--------------------------------------------------------------------------%

if a  == 2 
       n=120; 
    if h_or_ice == 1
cd HKC

mkdir h_moy
H_MOY = zeros(n,1);

mkdir h_max
H_MAX = zeros(n,1);

mkdir position_max
POS_MAX = zeros(n,1);

mkdir h_local
H_LOCAL = zeros(n,100);

cd surface_flow_data_hkc

DIR = dir;


for i = 3:size(DIR,1)
    
    S = DIR(i).name;
    
    DATA = readtable(S);
    
    DATA(:,18)=[];
    DATA(114:end,:)=[];
    DATA(1:13,:)=[];
    Surface_flow = table2array(DATA);
    
    X_coord= Surface_flow(:,1);
    HF = Surface_flow(:,15);
   
  cd ..
  cd surface_flow_csv_hkc
  
  Dir = dir;
  
  s = Dir(i).name;
    
    Data = readtable(s);
    
    Surface_flow_csv = table2array(Data);
    
    
    
    hc = -HF./(273.15-262.04.*(1+(0.72).^(1/3)*0.2*0.2^2));
    
    
    H_MOY(i-2,1) = mean(hc(:,1));
   [H_MAX(i-2,1), I] = max(hc(:,1));
    POS_MAX(i-2,1) = X_coord(I);
    H_LOCAL(i-2,:) = hc';
cd ..
cd surface_flow_data_hkc
end
cd .. 
   cd h_moy
    xlswrite('h_moy.xlsx', H_MOY)
   
cd ..   
   cd h_max
    xlswrite('h_max.xlsx', H_MAX)
        
cd ..   
   cd position_max
    xlswrite('pos_max.xlsx', POS_MAX)

cd ..   
   cd h_local
    xlswrite('h_local_hkc.xlsx', H_LOCAL)
cd ..

    else
    cd Results_ice_HKC
    EP_MAX= xlsread('epaisseur_max.xlsx');
    EP_MOY= xlsread('epaisseur_moy.xlsx');
    ETENDUE= xlsread('etendue.xlsx');
    ICE_LOCAL = xlsread('y_ice_local.xlsx');
    ICE_LOCAL(191:192,:)=[];
    cd ..
    cd HKC
   end
cd Input
K = xlsread('K_HKC_Full.xlsx');
Ratio = xlsread('Ratio_HKC_Full.xlsx');

X = [K Ratio];

cd ..
cd ..
end

if type == 0.1
    if h_or_ice == 1
    Y = H_MOY(:,1);
    else
    Y = EP_MOY(:,1);
    end
end
if type == 0.2
    if h_or_ice == 1
    Y = H_MAX(:,1);
    else
    Y = EP_MAX(:,1);
    end
end
if type == 0.3
    if h_or_ice == 1
    Y = POS_MAX(:,1);
    else
    Y = ETENDUE(:,1);
    end
end

if type >=1 
    if h_or_ice == 1
    Y = H_LOCAL(:,type)
    else
    Y = ICE_LOCAL(:,type)
    end
end  
 
  Metamodel_PCE(X, Y)
end