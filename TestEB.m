function [ output_args ] = TestEB( input_args )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


chunks = [1,10,50,100,500,1000,2500,5000];
load singlesessionmask.mat;

for i = 1:length(chunks)
    for j = 1:4
        display(int2str(chunks(i)));
        tic;
        ExtractBlobs('SLPDF.h5',neuronmask,chunks(i));
        protime(i,j) = toc;
    end
end
save Blobtime.mat protime chunks;
