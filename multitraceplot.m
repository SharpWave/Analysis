function [ output_args ] = multitraceplot(neurons,FT)
figure;

load FinalTraces;
load FinalOutput;
t = (1:size(FT,2))/20;
offset = 0.05;

for i = 1:length(neurons)
    plot(t,rawtrace(neurons(i),:)-(i-1)*offset,'-k','LineWidth',2.5);hold on;
    a = NP_FindSupraThresholdEpochs(FT(neurons(i),:),eps);
    for j = 1:size(a,1)
        plot(t(a(j,1):a(j,2)),rawtrace(neurons(i),a(j,1):a(j,2))-(i-1)*offset,'-r','LineWidth',2.5);
    end

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


end
axis tight;set(gca,'Box','off');
