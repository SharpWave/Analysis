function [ output_args ] = batchplotoutlines(animalID)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
sessnums = GetSessNums(animalID);
cd('C:\MasterData');
load MasterDirectory;

for i = 1:length(sessnums)
    cd(MD(sessnums(i)).Location);
    load ProcOut.mat;
    close all;
    PlotNeuronOutlines(InitPixelList,Xdim,Ydim,c);
    figure(1);axis equal;axis off;
    cd('C:\MasterData');
    save2pdf(['C:\MasterData\',MD(sessnums(i)).Animal,'_',MD(sessnums(i)).Date,'_',int2str(MD(sessnums(i)).Session),'_outlines.pdf'],figure(1),600);
    pause(2);
    close all;

end

