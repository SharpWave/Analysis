function [] = MakeICoutput3(NumIC,varname)
% Pretty much the same as MakeICoutput2 but 
% read in IC, interpret them, save as similar to NeuronImage and
% NeuronPixels.  weighted AND binarry
orig_dir = pwd;

% select Obj_1 directory
%dirname = uigetdir;
load singlesessionmask.mat;
cd([orig_dir,'\IC',int2str(NumIC),'-Objects\Obj_1']);

display('loading data');
for i = 1:NumIC
    % get the things
    cd(['Obj_',int2str(i)]);
    load(['Obj_1 - IC image ',int2str(i),'.mat']);
    RawIC{i} = Object.Data;
    maxval(i) = max(RawIC{i}(:));
    BinaryIC{i} = RawIC{i} > maxval(i)/2;
    load(['Obj_2 - IC trace ',int2str(i),'.mat']);
    RawICtrace{i} = Object.Data;
    cd ..
end


cd([orig_dir,'\ICEvent',int2str(NumIC),'-Objects\Obj_1']);
display('loading data');
for i = 1:NumIC
    % get the things
    cd(['Obj_',int2str(i)]);
   
    load(['Obj_2 - IC trace ',int2str(i),'-events.mat']);
    ICrising{i} = Object.Data;
    cd ..
end

cd(orig_dir);
% apply inclusion thresholds; see Tonegawa % Schnitzer Sun et al PNAS:
%
% Finally, it was processed by custom-made code written in ImageJ [dividing
% each image, pixel by pixel, by a low-passed (r = 20 pixels) filtered
% version], a ?F/F signal was calculated, and a spatial mean filter was
% applied to it in Inscopix Mosaic (disk radius = 3). 
%
% Two hundred cell locations were carefully selected from the resulting
% movie by principal component analysis–independent component analysis
% (PCA-ICA) [300 output principal components, 200 independent components
% (ICs), 0.1 weight of temporal information in spatiotemporal ICA, 750
% iterations maximum, 1E-5 fractional change to end iterations] in Inscopix
% Mosaic software, and the ICs were binarized with a threshold equal to
% one-half of the maximum intensity. Regions of interest (ROIs) were
% constructed very small to minimize overlap between ROIs, with width equal
% to one-half the width of the binarized ICs. ROIs that were too elongated
% (if its length exceeded its width by more than two times) were discarded.

%Correlation of Instantaneous Cell Calcium Event Rate vs. Animal Speed. The
%instantaneous rate of calcium event of each individual cell was determined
%from the number of calcium transients that occurred in the 1-s time window
%place symmetrically around that time bin (time bins sampled at 20 Hz, as
%stated before). Linear regression analysis was performed on the
%instantaneous calcium event rate vs. the animal running speed for each
%individual cell, to yield the distribution of regression slopes (Fig. 3C).

GoodIC = zeros(size(NumIC));
display('eliminating bad ICs');


for i = 1:NumIC
    Props{i} = regionprops(BinaryIC{i},'all');
    if (length(Props{i}) > 1)
        display(['Bad IC #',int2str(i)]);
        continue;
    end
    if (Props{i}.MajorAxisLength <= Props{i}.MinorAxisLength*2) 
        GoodIC(i) = 1;
    else
        display(['Bad IC #',int2str(i)]);
    end
    if (neuronmask(ceil(Props{i}.Centroid(2)),ceil(Props{i}.Centroid(1))) == 0)
        GoodIC(i) = 0;
        display(['Bad IC boundaries#',int2str(i)]);
    end
end

NumGoodIC = sum(GoodIC);
GoodICidx = find(GoodIC);

% create ROIS
for i = 1:NumGoodIC
    display(int2str(i));
    cidx = GoodICidx(i);
    sqRad = round(Props{cidx}.MinorAxisLength/4);
    ROI{i} = zeros(size(BinaryIC{cidx}));
    xCent = Props{cidx}.Centroid(1);
    yCent = Props{cidx}.Centroid(2);
    xMin = ceil(max(xCent-sqRad,1));
    xMax = ceil(min(xCent+sqRad,size(BinaryIC{cidx},2)));
    
    yMin = ceil(max(yCent-sqRad,1));
    yMax = ceil(min(yCent+sqRad,size(BinaryIC{cidx},1)));
    ROI{i}(yMin:yMax,xMin:xMax) = 1;% centroid pixel +- square radius 1/4 the long axis length
    PixelList{i} = find(ROI{i});
    if (length(PixelList{i}) == 0)
        keyboard;
    end
    ICtrace(i,:) = RawICtrace{cidx};
   
    
end

ICimage = BinaryIC(GoodICidx);
RawICimage = RawIC(GoodICidx);
ICprops = Props(GoodICidx);
ICrising = ICrising(GoodICidx);

NumFrames = length(RawICtrace{1});
ICFT = zeros(NumGoodIC,NumFrames);

% Interpret slopes the same way as Tenaspis
for i = 1:NumGoodIC
   ICsmtrace(i,:) = convtrim(ICtrace(i,:),ones(1,10)./10);
   ICdifftrace(i,:) = diff(ICsmtrace(i,:));
   slopes = find(ICrising{i} > 0);
   for j = 1:length(slopes)
       curr = (slopes(j));
       ICFT(i,curr) = 1;
       curr = max(curr-1,1);
       while((ICdifftrace(i,curr) > 0) && (curr > 1))
           ICFT(i,curr) = 1;
           curr = curr-1;
       end
       curr = min(slopes(j)+1,(NumFrames-1));
       while((ICdifftrace(i,curr)>0) && (curr < (NumFrames-1)))
           ICFT(i,curr) = 1;
           curr = curr+1;
       end
   end
end

clear GoodIC;
for i = 1:size(ICFT,1)
    iEpochs = NP_FindSupraThresholdEpochs(ICFT(i,:),eps);
    Num_Transients = size(iEpochs,1);
    GoodIC(i) = Num_Transients > 0;
    if (~GoodIC(i))
        display(['ROI ',int2str(i),' had no transients']);
    end
end

GoodICidx = find(GoodIC);

ICFT = ICFT(GoodICidx,:);
ICtrace = ICtrace(GoodICidx,:);
ICsmtrace = ICsmtrace(GoodICidx,:);
ICdifftrace = ICdifftrace(GoodICidx,:);
ICimage = ICimage(GoodICidx);
ICprops = ICprops(GoodICidx);



FT = ICFT;
NeuronImage = ICimage;
for i = 1:length(NeuronImage)
    NeuronPixels{i} = find(NeuronImage{i});
end

cd(orig_dir);
save ICoutput.mat ICtrace ICFT ICimage ICprops ICsmtrace ICdifftrace; 
save ProcOutIC.mat FT NeuronImage NeuronPixels;


% update data structures

% decide where calcium transients exist; see Tonegawa & Schnitzer
%
% Calcium traces were calculated at these ROIs for each processed movie,
% in ImageJ. Calcium events were detected by thresholding (>3 SDs from the ?F/F signal) 
% at the local maxima of the ?F/F signal.
% [filename,pathname] = uigetfile('*.h5','pick the DF/F file');
% cd(pathname);
% [~,Xdim,Ydim,NumFrames] = loadframe(filename,1);
% for i = 1:NumFrames
%     i/NumFrames
%     [frame,Xdim,Ydim,NumFrames] = loadframe(filename,i);
%     for j = 1:NumGoodIC
%         ROItrace(j,i) = sum(frame(PixelList{j}));% find transients
%     end
% end
% keyboard;
% make a matrix similar to FT

%%%%%%%%%%%%%%%%%%%%%%

% analysis

% just look at whether Ca2+ transients match

% look at whether IC match (nearest centroid; highest overlap)

% for neurons/IC with good match, how does transient detection fare?