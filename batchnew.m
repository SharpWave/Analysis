function [ output_args ] = batchnew( input_args )

for i = 1:10
%     evstr = ['! mkdir Fake300-',int2str(i)],
%     eval(evstr);
    cd(['Fake300-',int2str(i)]);
    %MakeFakeMovie(i,300);
    %tic,MakeFilteredMovies('fake.h5'),MovieFiltTime = toc;save MovieFiltTime.mat MovieFiltTime;
    %tic,Tenaspis4testing,ttime = toc;save ttime.mat ttime;
    MakeICoutput4(290)
    FakeDataResults;
    cd ..
end

