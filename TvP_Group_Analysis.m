function [] = TvP_Group_Analysis()

dr{1} = 'J:\Tenaspis2Test\GCaMP6f_30';
dr{2} = 'J:\Tenaspis2Test\GCaMP6f_31';
dr{3} = 'J:\Tenaspis2Test\GCaMP6f_44';
dr{4} = 'J:\Tenaspis2Test\GCaMP6f_45';
dr{5} = 'J:\Tenaspis2Test\GCaMP6f_48';

All_Fraction_T_Matched = [];
All_FractionOverlap = [];
All_mindist = [];
All_Num_I_Transients = [];
All_Num_Matching_Transients = [];
All_Num_T_Transients = [];
All_T_Score = [];


for i = 1:length(dr)
    cd(dr{i});
    load('TvP_analysis.mat','Fraction_T_Matched','FractionOverlap','mindist','Num_I_Transients','Num_Matching_Transients','Num_T_Transients','T_Score');
    
    