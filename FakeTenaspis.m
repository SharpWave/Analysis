function [ output_args ] = FakeTenaspis(seed,dimsize)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
MakeFakeMovie(seed,dimsize);
tic,MakeFilteredMovies('fake.h5'),MovieFiltTime = toc;save MovieFiltTime.mat MovieFiltTime;
tic,Tenaspis4testing,ttime = toc;save ttime.mat ttime;

end

