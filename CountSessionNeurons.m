function [] = CountSessionNeurons()
close all;

cd('C:\MasterData');
load MasterDirectory;

for i = 1:length(MD)
    cd(MD(i).Location)
    load ProcOut.mat;
    SessNeurons(i) = length(NeuronImage);
    SessLengthMinutes(i) = (NumFrames/20/60);
    blabel{i} = [MD(i).Date,'_',MD(i).Env]
end
PrettyBarLongLabels(SessNeurons,blabel);

PrettyBarLongLabels(SessNeurons./SessLengthMinutes,blabel);


keyboard;

