function [ output_args ] = PlotTenaspisVsPCAICAoutlines( input_args )

load T2output.mat;
load TvP_analysis.mat;

NumTNeurons = size(FT,1);
NumFrames = size(FT,2);

figure;

for i = 1:NumTNeurons
    
    b = bwboundaries(NeuronImage{i});
    y = b{1}(:,1);
    x = b{1}(:,2);
    hold on;
    plot(x,y,'-b','LineWidth',1.5);
    
    cidx = ClosestT(i);
    
    b = bwboundaries(ICimage{cidx});
    y = b{1}(:,1);
    x = b{1}(:,2);
    plot(x,y,'-r','LineWidth',2.5);
    
end

UnusedIC = setdiff(1:length(ICimage),ClosestT);

for i = 1:length(UnusedIC)
    b = bwboundaries(ICimage{UnusedIC(i)});
    y = b{1}(:,1);
    x = b{1}(:,2);
    plot(x,y,'-m','LineWidth',2.5);
end

axis square;
axis tight;
drawnow;

set(gcf,'Position',[ 217          49        1023         948])
display([int2str(NumTNeurons),' Tenaspis Neurons']);
display([int2str(length(ICimage)),' IC Neurons']);
display([int2str(length(UnusedIC)),' Unmatched IC Neurons']);


