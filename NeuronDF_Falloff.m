function [AF,Dists] = NeuronDF_Falloff(filename)

close all;

[~,Xdim,Ydim,NumFrames] = loadframe(filename,1);
load('T2output.mat','FT','NeuronImage');

NumNeurons = size(FT,1);

PixelRad = 75;

for i = -PixelRad:PixelRad
    for j = -PixelRad:PixelRad
        Dist(i+PixelRad+1,j+PixelRad+1) = sqrt(i^2+j^2);
    end
end

[Dists,~,DistBin] = unique(Dist);

for i = 1:length(Dists)
    DistCount(i) = length(find(Dist == Dists(i)));
end

MinX = 2+PixelRad;
MinY = 2+PixelRad;

MaxX = Xdim-PixelRad-2;
MaxY = Ydim-PixelRad-2;

EdgeN = zeros(1,NumNeurons);

for i = 1:NumNeurons
    c = regionprops(NeuronImage{i},'Centroid');
    Xcent(i) = round(c.Centroid(2));
    Ycent(i) = round(c.Centroid(1));
    
    if ((Xcent(i) < MinX) || (Xcent(i) > MaxX) || (Ycent(i) < MinY) || (Ycent(i) > MaxY))
        EdgeN(i) = 1;
    end
end



%NumGoodNeurons = sum(~EdgeN);
GoodN = intersect(find(~EdgeN),find(sum(FT')>0));
Xcent = Xcent(GoodN);
Ycent = Ycent(GoodN);
FT = FT(GoodN,:);
NumGoodNeurons = length(GoodN);

for i = 1:NumGoodNeurons
    AvgF{i} = zeros(PixelRad*2+1,PixelRad*2+1);
end

for i = 1:NumFrames
    frame = loadframe(filename,i);
    ActiveN = find(FT(:,i));
    for j = 1:length(ActiveN)
        curr = ActiveN(j);
        % i,j,Xcent(curr),Ycent(curr),
        AvgF{curr} = AvgF{curr} + frame((Xcent(curr)-PixelRad):(Xcent(curr)+PixelRad),(Ycent(curr)-PixelRad):(Ycent(curr)+PixelRad));
    end
end



for i = 1:NumGoodNeurons
    % normalize by # of active frames
    AvgF{i} = AvgF{i}./sum(FT(i,:));
    
    % normalize by centroid intensity
    AvgF{i} = AvgF{i}./AvgF{i}(PixelRad+1,PixelRad+1);
    FallOff{i} = zeros(1,length(Dists));
    
    for j = 1:((PixelRad*2+1)^2)
        
        FallOff{i}(DistBin(j)) = FallOff{i}(DistBin(j)) + AvgF{i}(j)/DistCount(DistBin(j));
    end
end

AF = zeros(NumGoodNeurons,length(FallOff{1}));
for i = 1:NumGoodNeurons
    i
    AF(i,:) = FallOff{i};
end

% check not within x pixels of an edge


% for every neuron
% get centroid
% for every active time of that neuron
% calculate DFF of centroid pixel
% calculate intensity of all pixels within a 40 pixel radius

% average all falloff curves
% establish


end

