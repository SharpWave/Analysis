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
All_T_TransientsPerMinute = [];
All_I_TransientsPerMinute = [];
All_Closest_I_TransientsPerMinute = [];
All_T_MutInf = [];
All_IC_MutInf = [];
All_T_pval = [];
All_IC_pval = [];
All_min_PFdist = [];
All_PFTarea = [];
All_PFICarea = [];
All_PFoverlap = [];
All_MatchedIC = [];
All_Tarea = [];
All_Iarea = [];

for i = 1:length(dr)
    i,
    cd(dr{i});
    tic
    %Tenaspis3singlesession;
    ttime(i) = toc;
    %MakeICoutput3(NumIC(i));
    
    load ExpRoom.mat;
    %CalculatePlacefields(ExpRoom,'alt_inputs','FinalOutput.mat','man_savename','PlaceMaps.mat','half_window',0,'minspeed',3,'cmperbin',0.5,'half_window',0);
    %PFstats;
    %CalculatePlacefields(ExpRoom,'alt_inputs','ProcOutIC.mat','man_savename','PlaceMapsIC.mat','half_window',0,'minspeed',3,'cmperbin',0.5,'half_window',0);
    %PFstats(0,'alt_file_use','PlaceMapsIC.mat','IC');
    TenaspisVsPCAICA();
    
    load('TvP_analysis.mat','PFoverlap','PFTarea','PFICarea','T_MutInf','IC_MutInf','T_pval','IC_pval','min_PFdist','Fraction_T_Matched','FractionOverlap','mindist','Num_I_Transients','Num_Matching_Transients','Num_T_Transients','T_Score','ROIgroup','FT','ICFT','Num_Closest_I_Transients','T_TransientsPerMinute','I_TransientsPerMinute','Closest_I_TransientsPerMinute','MatchedIC','Tarea','Iarea');
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
        tEpochs = NP_FindSupraThresholdEpochs(ICFT(j,:),eps);
        All_I_TranDur = [All_I_TranDur;tEpochs(:,2)-tEpochs(:,1)+1];
    end
    
    All_T_TransientsPerMinute = [All_T_TransientsPerMinute,T_TransientsPerMinute];
    All_I_TransientsPerMinute = [All_I_TransientsPerMinute,I_TransientsPerMinute];
    All_Closest_I_TransientsPerMinute = [All_Closest_I_TransientsPerMinute,Closest_I_TransientsPerMinute];
    
    All_T_MutInf = [All_T_MutInf,T_MutInf];
    All_IC_MutInf = [All_IC_MutInf,IC_MutInf];
    All_T_pval = [All_T_pval,T_pval];
    All_IC_pval = [All_IC_pval,IC_pval];
    All_min_PFdist = [All_min_PFdist,min_PFdist];
    All_PFTarea = [All_PFTarea,PFTarea];
    All_PFICarea = [All_PFICarea,PFICarea];
    All_PFoverlap = [All_PFoverlap,PFoverlap];
    All_MatchedIC = [All_MatchedIC,MatchedIC];
    All_Tarea = [All_Tarea,Tarea];
    All_Iarea = [All_Iarea,Iarea];
end

cd('C:\MasterData');
save TvP_Group.mat;


