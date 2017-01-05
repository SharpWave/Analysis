function [outs] = FakeDataResults()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
close all
Set_T_Params('fake.h5');
[Xdim,Ydim,NumFrames] = Get_T_Params('Xdim','Ydim','NumFrames');

load FakeData.mat;
FakePixelIdxList = CircMask;
FakePSA = PSAbool;
FakeTrace = TraceMat;

load ICoutput.mat;
load FinalOutput.mat;

blankframe = zeros(Xdim,Ydim,'single');

%% Thing 1: Neuron Count estimations
TnspsN = NumNeurons;
PicaN = length(ICimage);
FakeN = size(FakePSA,1);

%% Thing 2: Activity Estimations

% Get # of Transients and save the epoch lists
for i = 1:FakeN
    FakeEpochs{i} = NP_FindSupraThresholdEpochs(FakePSA(i,:),eps);
    NumFakeTransients(i) = size(FakeEpochs{i},1);
end

for i = 1:PicaN
    PicaEpochs{i} = NP_FindSupraThresholdEpochs(ICFT(i,:),eps);
    NumPicaTransients(i) = size(PicaEpochs{i},1);
end

for i = 1:TnspsN
    TnspsEpochs{i} = NP_FindSupraThresholdEpochs(PSAbool(i,:),eps);
    NumTnspsTransients(i) = size(TnspsEpochs{i},1);
end

%% Thing 3: Spatial Distance Metrics
disp('spatial distance');
% Get distance between every Fake ROI and every Tenaspis and PCAICA ROI

% get centroids
for i = 1:FakeN
    % Calculate Centroid
    temp = blankframe;
    temp(FakePixelIdxList{i}) = 1;
    
    rp = regionprops(temp);
    
    FakeCent(i,:) = rp(1).Centroid;
end

for i = 1:PicaN
    % Calculate Centroid
    PicaCent(i,:) = ICprops{i}.Centroid;
end

for i = 1:TnspsN
    rp = regionprops(NeuronImage{i});
    TnspsCent(i,:) = rp(1).Centroid;
end

% calculate distances and overlaps
for i = 1:FakeN
    for j = 1:PicaN
        PicaDist(i,j) = pdist([FakeCent(i,:);PicaCent(j,:)]);
        PicaOverlap(i,j) = length(intersect(FakePixelIdxList{i},find(ICimage{j})))/length(FakePixelIdxList{i});
    end
    PicaNeighbors{i} = find(PicaOverlap(i,:) > 0);
    
    for j = 1:TnspsN
        TnspsDist(i,j) = pdist([FakeCent(i,:);TnspsCent(j,:)]);
        TnspsOverlap(i,j) = length(intersect(FakePixelIdxList{i},find(NeuronImage{j})))/length(FakePixelIdxList{i});
    end
    TnspsNeighbors{i} = find(TnspsOverlap(i,:) > 0);
end

%% Thing 4: Temporal correlations (overlaps only)
disp('temporal');
p = ProgressBar(FakeN);
for i = 1:FakeN
    
    for j = 1:length(PicaNeighbors{i})
        PicaFalsePos(i,j) = 0;
        PicaFalseNeg(i,j) = 0;
        % compare with this guy
        nidx = PicaNeighbors{i}(j);
        for k = 1:size(FakeEpochs{i},1)
            Matched = false;
            for m = 1:size(PicaEpochs{nidx},1)
                if(any(intersect(FakeEpochs{i}(k,1):FakeEpochs{i}(k,2),PicaEpochs{nidx}(m,1):PicaEpochs{nidx}(m,2))))
                    Matched = true;
                    break;
                end
            end
            if (~Matched)
                PicaFalseNeg(i,j) = PicaFalseNeg(i,j)+1;
            end
        end
        
        for m = 1:size(PicaEpochs{nidx},1)
            Matched = false;
            for k = 1:size(FakeEpochs{i},1)
                if(any(intersect(FakeEpochs{i}(k,1):FakeEpochs{i}(k,2),PicaEpochs{nidx}(m,1):PicaEpochs{nidx}(m,2))))
                    Matched = true;
                    break;
                end
            end
            if (~Matched)
                PicaFalsePos(i,j) = PicaFalsePos(i,j)+1;
            end
        end
    end
    
    for j = 1:length(TnspsNeighbors{i})
        TnspsFalsePos(i,j) = 0;
        TnspsFalseNeg(i,j) = 0;
        % compare with this guy
        nidx = TnspsNeighbors{i}(j);
        for k = 1:size(FakeEpochs{i},1)
            Matched = false;
            for m = 1:size(TnspsEpochs{nidx},1)
                if(any(intersect(FakeEpochs{i}(k,1):FakeEpochs{i}(k,2),TnspsEpochs{nidx}(m,1):TnspsEpochs{nidx}(m,2))))
                    Matched = true;
                    break;
                end
            end
            if (~Matched)
                TnspsFalseNeg(i,j) = TnspsFalseNeg(i,j)+1;
            end
        end
        
        for m = 1:size(TnspsEpochs{nidx},1)
            Matched = false;
            for k = 1:size(FakeEpochs{i},1)
                if(any(intersect(FakeEpochs{i}(k,1):FakeEpochs{i}(k,2),TnspsEpochs{nidx}(m,1):TnspsEpochs{nidx}(m,2))))
                    Matched = true;
                    break;
                end
            end
            if (~Matched)
                TnspsFalsePos(i,j) = TnspsFalsePos(i,j)+1;
            end
        end
    end
    p.progress;
end
p.stop;
PicaFalseNegRates = (PicaFalseNeg)./NumFakeTransients';
TnspsFalseNegRates = (TnspsFalseNeg)./NumFakeTransients';
PicaFalsePosRates = PicaFalsePos./NumFakeTransients';
TnspsFalsePosRates = TnspsFalsePos./NumFakeTransients';

%% Thing 4 - Determine whether detection techniques found the ROIs

%Highest overlapping ROI with a false negative false of less than 80% is considered the partner

PicaPartner = zeros(1,FakeN);
TnspsPartner = zeros(1,FakeN);

for i = 1:FakeN
    if ~(isempty(PicaNeighbors{i}))
        [PicaFalseNegRate(i),idx] = min(PicaFalseNegRates(i,1:length(PicaNeighbors{i})));
        if (PicaFalseNegRate(i) < 0.8)
            PicaPartner(i) = PicaNeighbors{i}(idx);
        end
        PicaFalsePosRate(i) = PicaFalsePosRates(i,idx);
    else
        PicaFalseNegRate(i) = 0;
        PicaFalsePosRate(i) = 0;
    end
    
    if (~isempty(TnspsNeighbors{i}))
        [TnspsFalseNegRate(i),idx] = min(TnspsFalseNegRates(i,1:length(TnspsNeighbors{i})));
        if (TnspsFalseNegRate(i) < 0.8)
            TnspsPartner(i) = TnspsNeighbors{i}(idx);
        end
        TnspsFalsePosRate(i) = TnspsFalsePosRates(i,idx);
    else
        TnspsFalseNegRate(i) = 0;
        TnspsFalsePosRate(i) = 0;
    end
end

% now calculate ROI-based false pos and neg
TnspsROIFalsePos = 0;
TnspsROIFalseNeg = 0;
PicaROIFalsePos = 0;
PicaROIFalseNeg = 0;

for i = 1:FakeN
    if (PicaPartner(i) == 0)
        PicaROIFalseNeg = PicaROIFalseNeg+1;
    end
    
    if (TnspsPartner(i) == 0)
        TnspsROIFalseNeg = TnspsROIFalseNeg+1;
    end
end

for i = 1:PicaN
    if(~any(ismember(i,PicaPartner)))
        PicaROIFalsePos = PicaROIFalsePos+1;
    end
end

for i = 1:TnspsN
    if(~any(ismember(i,TnspsPartner)))
        TnspsROIFalsePos = PicaROIFalsePos+1;
    end
end

% throw the important shit in a struct
outs = v2struct(PicaPartner,TnspsPartner,TnspsROIFalsePos,TnspsROIFalseNeg,PicaROIFalsePos,PicaROIFalseNeg,TnspsN,PicaN,FakeN,PicaFalseNegRate,TnspsFalseNegRate,TnspsFalsePosRate,PicaFalsePosRate,NumTnspsTransients,NumPicaTransients,NumFakeTransients);

save FakeDataResults.mat;










