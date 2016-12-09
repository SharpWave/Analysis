function [ output_args ] = FakeDataROIplot()
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


%% initial ROI plots
figure(1);hold on;
for i = 1:length(NeuronImage)
    b = bwboundaries(NeuronImage{i});
    plot(b{1}(:,2),b{1}(:,1),'-','LineWidth',3,'Color',[0 0 0]);
    plot(b{1}(:,2),b{1}(:,1),'-','LineWidth',2,'Color',[0 .5 0]);
    
end

for i = 1:length(ICimage)
    b = bwboundaries(ICimage{i});
    plot(b{1}(:,2),b{1}(:,1),'-k','LineWidth',2);
    plot(b{1}(:,2),b{1}(:,1),'-r','LineWidth',1);
    hold on;
end

blankframe = zeros(size(NeuronImage{1}),'single');

for i = 1:length(CircMask)
    temp = blankframe;
    temp(CircMask{i}) = 1;
    b = bwboundaries(temp);
    plot(b{1}(:,2),b{1}(:,1),'-k','LineWidth',1);
    plot(b{1}(:,2),b{1}(:,1),'-b','LineWidth',0.5);
    hold on;
end
axis image;
set(gca,'Xlim',[0 Xdim]);
set(gca,'YLim',[0 Ydim]);
set(gcf, 'PaperPositionMode', 'auto')
saveas(gcf,'ROIoutlines','tif');


