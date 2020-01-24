function rename

cd Full_Analysis/HAX/surface_flow_csv_hax

DIR = dir;

for i = 3:size(DIR,1)
    
    S = DIR(i).name;
    deb = char(extractBetween(S,1,22));
    fin = char(extractBetween(S,23,strlength(S)));
    
    if strlength(S)==27
        index='00';
        Newname = strcat(deb,index,fin);
    movefile(S, Newname);
    end
    if strlength(S)==28
        index='0';
        Newname = strcat(deb,index,fin);
    movefile(S, Newname);
    end
    
    if strlength(S)==29
    end
    
end
end

    