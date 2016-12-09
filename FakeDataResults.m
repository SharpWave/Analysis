function [ output_args ] = FakeDataResults()
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
FakeN = size(fakePSA,1);

%% Thing 2: Activity Estimations

% Get # of Transients and save the epoch lists
for i = 1:FakeN
    FakeEpochs{i} = NP_FindSupraThresholdTransients(FakePSA(i,:),eps);
    NumFakeTransients(i) = size(FakeEpochs{i},1);
end

for i = 1:PicaN
    PicaEpochs{i} = NP_FindSupraThresholdTransients(ICFT(i,:),eps);
    NumPicaTransients(i) = size(PicaEpochs{i},1);
end

for i = 1:TnspsN
    TnspsEpochs{i} = NP_FindSupraThresholdTransients(PSAbool(i,:),eps);
    NumTnspsTransients(i) = size(TnspsEpochs{i},1);
end

%% Thing 3: Distance Metrics

% Get distance between every Fake ROI and every Tenaspis and PCAICA ROI

% get centroids
for i = 1:FakeN
    % Calculate Centroid
    temp = blankframe;
    temp(FakePixelIdxList{i}) = 1;
    rp = regionprops(temp,4);
    [FakeCent(i,1),FakeCent(i,2)] = rp{1}.Centroid;
end

for i = 1:PicaN
    % Calculate Centroid
    [PicaCent(i,1),PicaCent(i,2)] = ICprops{i}.Centroid;  
end

for i = 1:TnspsN
    rp = regionprops(NeuronImage{i},4);
    [TnspsCent(i,1),TnspsCent(i,2)] = rp{1}.Centroid;
end

% calculate distances
for i = 1:FakeN
    
    for j = 1:PicaN
        PicaDist(i,j) = pdist([FakeCent(i,:);PicaCent(j,:)]);
    end
    
    for j = 1:TnspsN
        TnspsDist(i,j) = pdist([FakeCent(i,:);TnspsCent(j,:)]);
    end
end
    







