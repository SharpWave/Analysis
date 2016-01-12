function [ output_args ] = recruitsim( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
n = 15000;
pNew = 0.05;
pOld = 0.7;
pInit = 0.15;
NumSess = 23;
close all;
Raster = zeros(n,NumSess);

for i = 1:n
    for j = 1:NumSess
        if (j == 1)
            Raster(i,j) = rand(1,1) < pInit;
        else
            if (Raster(i,j-1) == 1)
                Raster(i,j) = rand(1,1) < pOld;
            else
                Raster(i,j) = rand(1,1) < pNew;
            end
        end
    end

end

figure;hist(sum(Raster'),0:23);keyboard;


