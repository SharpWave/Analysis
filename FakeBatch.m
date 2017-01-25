function [ output_args ] = FakeBatch( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
NumIts = 10;

for i = 10:NumIts
    mkdirstr = ['! mkdir J:\PostSubTesting\Fake\NeuronDensity_point015\Fake300-',int2str(i)],
    eval(mkdirstr);
    cd(['J:\PostSubTesting\Fake\NeuronDensity_point015\Fake300-',int2str(i)]);
    MakeFakeMovie(i,300);
    tic,MakeFilteredMovies('fake.h5'),MovieFiltTime = toc,save MovieFiltTime.mat MovieFiltTime;
    tic,Tenaspis4testing,ttime = toc,save ttime.mat ttime;
    cd ..
end

