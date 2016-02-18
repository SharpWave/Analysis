function [] = AnalyzeBlobs()

load CC.mat;

% unpack variables
for i = 1:length(ccprops)
    NumBlobs(i) = length(ccprops{i});
    oNumBlobs(i) = length(origprops{i});
end
keyboard;