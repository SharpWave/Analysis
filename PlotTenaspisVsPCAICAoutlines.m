function [ output_args ] = PlotTenaspisVsPCAICAoutlines( input_args )

load FinalOutput.mat;
load ('TvP_analysis.mat','ICFT','ICimage','ClosestT','ROIgroup');

NumTNeurons = size(FT,1);
NumFrames = size(FT,2);

figure;set(gcf,'Renderer','OpenGl')
colors{1} = [0 0.7 0]; % good match: darkish green
colors{2} = 'b'; %conflict
colors{3} = 'm'; % baddish match
colors{4} = 'r'; % bad match


for i = 1:NumTNeurons
    
    b = bwboundaries(NeuronImage{i});
    y = b{1}(:,1);
    x = b{1}(:,2);
    hold on;
    plot(x,y,'-','LineWidth',2,'Color',colors{ROIgroup(i)});
    
    cidx = ClosestT(i);
    
    b = bwboundaries(ICimage{cidx});
    y = b{1}(:,1);
    x = b{1}(:,2);
    plot(x,y,'-k','LineWidth',1);
    x1{i} = x;
    y1{i} = y;
end


UnusedIC = setdiff(1:length(ICimage),ClosestT);

for i = 1:length(UnusedIC)
    b = bwboundaries(ICimage{UnusedIC(i)});
    y = b{1}(:,1);
    x = b{1}(:,2);
    plot(x,y,'-','Color',[0.5 0.5 0.5],'LineWidth',1);
    x2{i} = x;
    y2{i} = y;
end

axis square;
axis tight;
drawnow;

set(gcf,'Position',[ 217          49        1023         948])
display([int2str(NumTNeurons),' Tenaspis Neurons']);
display([int2str(length(ICimage)),' IC Neurons']);
display([int2str(length(UnusedIC)),' Unmatched IC Neurons']);

old_YLim = get(gca,'YLim');
set(gca,'YLim',[old_YLim(1) old_YLim(2)+50]);
line([50 150],[old_YLim(2)+5 old_YLim(2)+5],'Color','k','LineWidth',3)
axis equal;
axis off;


