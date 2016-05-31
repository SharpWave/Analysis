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
All_ROIgroup = [];
All_Animal = [];
All_FT = [];
All_ICFT = [];

for i = 1:length(dr)
    cd(dr{i});
    Analyze_TvP('TvP.mat');
    load('TvP_analysis.mat','Fraction_T_Matched','FractionOverlap','mindist','Num_I_Transients','Num_Matching_Transients','Num_T_Transients','T_Score','ROIgroup','FT','ICFT');
    All_Fraction_T_Matched = [All_Fraction_T_Matched,Fraction_T_Matched];
    All_FractionOverlap = [All_FractionOverlap,FractionOverlap];
    All_mindist = [All_mindist,mindist];
    All_Num_I_Transients = [All_Num_I_Transients,Num_I_Transients];
    All_Num_Matching_Transients = [All_Num_Matching_Transients,Num_Matching_Transients];
    All_Num_T_Transients = [All_Num_T_Transients,Num_T_Transients];
    All_T_Score = [All_T_Score,T_Score];
    All_ROIgroup = [All_ROIgroup,ROIgroup];
    All_Animal = [All_Animal,ones(1,length(mindist))*i];
    All_FT{i} = FT;
    All_ICFT{i} = ICFT;
    All_Duration(i) = size(FT,2);
end

keyboard;
    