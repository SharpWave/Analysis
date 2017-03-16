function [ output_args ] = TenPica_Runtimes_pAct()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

close all;

% comparison of run times at 3 different neuron activities

Pica(1,1:10) = [8964,9262,8793,8916,9006,8774,8827,9284,8849,8869];

Pica(2,1:10) = [8689,9215,9173,9141,7324,8224,9097,9123,9558,8350];

Pica(3,1:10) = [8573,8917,9519,9374,9427,8755,9269,9374,9547,8846];

Pica = Pica/60;

NumSeeds = 10;

basedir{1} = 'J:\PostSubTesting\Fake\pAct_point0005';
basedir{2} = 'J:\PostSubTesting\Fake\pAct_point001';
basedir{3} = 'J:\PostSubTesting\Fake\pAct_point0015';

ndim = [.01,.02,.03];

for i = 1:length(basedir)
    cd(basedir{i});
    for j = 1:NumSeeds
      cd(['Fake300','-',int2str(j)]);
      load ttime.mat;
      Tnsps(i,j) = ttime;
      cd ..
    end
end

Tnsps = Tnsps/60;

x = ndim;

h(1) = plot(x,mean(Tnsps'),'b');hold on;
errorbar(x,mean(Tnsps'),std(Tnsps'),'b','LineWidth',2);
h(2) = plot(x,mean(Pica'),'r');
hold on;errorbar(x,mean(Pica'),std(Pica'),'r','LineWidth',2);
%set(gca,'Xlim',[150 400]);
%set(gca,'Ylim',[0 180]);
set(gca,'XTick',x);
xtl{1} = '0.01';
xtl{2} = '0.02';
xtl{3} = '0.03';


set(gca,'XTickLabel',xtl);
set(gca,'XTickLabelRotation',45);
xlabel('neuron activity rate');
ylabel('run time (minutes)');
set(gca,'Box','off');

keyboard;

end

