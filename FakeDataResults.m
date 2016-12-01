function [ output_args ] = FakeDataResults()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load FakeData.mat;
FakePixelIdxList = CircMask;
FakePSA = PSAbool;
FakeTrace = TraceMat;

%load ICoutput.mat;

load FinalOutput.mat;


%% initial ROI plots
figure(1);
for i = 1:length(NeuronImage)
    b = bwboundaries(NeuronImage{i});
    plot(b{1}(:,2),b{1}(:,1),'-','LineWidth',5,'Color',[0 .5 0]);
    hold on;
end

% for i = 1:length(ICimage)
%     b = bwboundaries(ICimage{i});
%     plot(b{1}(:,2),b{1}(:,1),'-r','LineWidth',2);
%     hold on;
% end

blankframe = zeros(size(NeuronImage{1}),'single');

for i = 1:length(CircMask)
    temp = blankframe;
    temp(CircMask{i}) = 1;
    b = bwboundaries(temp);
    plot(b{1}(:,2),b{1}(:,1),'-b');
    hold on;
end

