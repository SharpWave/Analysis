function [ output_args ] = conncomptest( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

NumIts = 50;
FractionOn = 0.3;

for i = 1:NumIts
  data = (rand(i)>(1-FractionOn));
  tic;
  temp = bwconncomp(data);
  runtime(i) = toc;

end

figure;plot((1:NumIts).^2,runtime);keyboard;

