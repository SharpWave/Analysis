function [ output_args ] = TenPica_Runtimes_Density()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

close all;

% comparison of run times at 3 different neuron densities

Pica(1,1:10) = [5016,4501,4567,4550,4547,4608,4548,4570,4662,4574];

Pica(2,1:10) = [8689,9215,9173,9141,7324,8224,9097,9123,9558,8350];

Pica(3,1:10) = [11128,13672,11821,14200,11689,12247,12337,11077,11765,11368];

Pica = Pica/60;

NumSeeds = 10;

basedir{1} = 'J:\PostSubTesting\Fake\NeuronDensity_point005';
basedir{2} = 'J:\PostSubTesting\Fake\pAct_point001';
basedir{3} = 'J:\PostSubTesting\Fake\NeuronDensity_point015';

ndim = [0.005,0.01,0.015];

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

h(1) = plot(x,mean(Tnsps'),'bo','MarkerFaceColor','b','MarkerSize',2);hold on;
errorbar(x,mean(Tnsps'),std(Tnsps'),'b','LineWidth',1);
h(2) = plot(x,mean(Pica'),'rs','MarkerFaceColor','r','MarkerSize',2);
hold on;errorbar(x,mean(Pica'),std(Pica'),'r','LineWidth',1);
%set(gca,'Xlim',[150 400]);
%set(gca,'Ylim',[0 180]);
set(gca,'XTick',x);
xtl{1} = '0.005';
xtl{2} = '0.01';
xtl{3} = '0.015';


set(gca,'XTickLabel',xtl);
set(gca,'XTickLabelRotation',45);
xlabel('neuron density (neurons per pixel)');
ylabel('run time (minutes)');
set(gca,'Box','off');
keyboard;

end

