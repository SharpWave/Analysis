function [ output_args ] = PFHitAnalysis( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
load PFstats.mat;
load PlaceMaps.mat;

PFFT = zeros(size(FT));
PFbool = zeros(size(FT));

for i = 1:size(FT,1)
    PSE = NP_FindSupraThresholdEpochs(FT(i,:),eps);
    NumPSE(i) = size(PSE,1);
    FirstInPF(i) = 0;
    if (pval(i) > 0.95 && (sum(PFactive{i,MaxPF(i)}) >= 4))
        % Good PF   
        for j = 1:size(PFepochs{i,MaxPF(i)},1)
            PFbool(i,PFepochs{i,MaxPF(i)}(j,1):PFepochs{i,MaxPF(i)}(j,2)) = 1;
        end
        PFFT(i,:) = FT(i,:).*PFbool(i,:);
        PFFT(i,:) = PFFT(i,:) - (FT(i,:).*~PFbool(i,:));
        InF = find(PFFT(i,:) == 1);
        try
        FirstInPF(i) = min(InF);
        end
    end
    
    
end
keyboard;
end

