function [] = TvP_Group_Analysis()

dr{1} = 'J:\Tenaspis2Test\GCaMP6f_30';
dr{2} = 'J:\Tenaspis2Test\GCaMP6f_31';
dr{3} = 'J:\Tenaspis2Test\GCaMP6f_44';
dr{4} = 'J:\Tenaspis2Test\GCaMP6f_45';
dr{5} = 'J:\Tenaspis2Test\GCaMP6f_48';

NumIC = [1355,332,193,1533,868];

All_Fraction_T_Matched = [];
All_FractionOverlap = [];
All_mindist = [];
All_Num_I_Transients = [];
All_Num_Closest_I_Transients = [];
All_Num_Matching_Transients = [];
All_Num_T_Transients = [];
All_T_Score = [];
All_ROIgroup = [];
All_Animal = [];
All_FT = [];
All_ICFT = [];
All_I_Animal = [];
All_T_TranDur = [];
All_I_TranDur = [];

for i = 1:length(dr)
    cd(dr{i});
    DetectGoodSlopes();
    MakeICoutput3(NumIC(i));
    TenaspisVsPCAICA('DFF.h5')
    Analyze_TvP('TvP.mat');
    
    load('TvP_analysis.mat','Fraction_T_Matched','FractionOverlap','mindist','Num_I_Transients','Num_Matching_Transients','Num_T_Transients','T_Score','ROIgroup','FT','ICFT','Num_Closest_I_Transients');
    All_Fraction_T_Matched = [All_Fraction_T_Matched,Fraction_T_Matched];
    All_FractionOverlap = [All_FractionOverlap,FractionOverlap];
    All_mindist = [All_mindist,mindist];
    All_Num_I_Transients = [All_Num_I_Transients,Num_I_Transients];
    All_Num_Closest_I_Transients = [All_Num_Closest_I_Transients,Num_Closest_I_Transients];
    All_Num_Matching_Transients = [All_Num_Matching_Transients,Num_Matching_Transients];
    All_Num_T_Transients = [All_Num_T_Transients,Num_T_Transients];
    All_T_Score = [All_T_Score,T_Score];
    All_ROIgroup = [All_ROIgroup,ROIgroup];
    All_Animal = [All_Animal,ones(1,length(mindist))*i];
    All_I_Animal = [All_I_Animal,ones(1,size(ICFT,1))];
    All_FT{i} = FT;
    All_ICFT{i} = ICFT;
    All_Duration(i) = size(FT,2);
    for j = 1:size(FT,1)
        tEpochs = NP_FindSupraThresholdEpochs(FT(j,:),eps);
        All_T_TranDur = [All_T_TranDur;tEpochs(:,2)-tEpochs(:,1)+1];
    end
    for j = 1:size(ICFT,1)
        tEpochs = NP_FindSupraThresholdEpochs(FT(j,:),eps);
        All_I_TranDur = [All_I_TranDur;tEpochs(:,2)-tEpochs(:,1)+1];
    end
        
end



keyboard;
    