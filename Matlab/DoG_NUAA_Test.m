% clear all, close all, clc

%% read client and imposter testing data name
ClientTestNormalizedName = importdata('./NUAA/client_test_normalized.txt');
ClientTestNormalizedNumber = size(ClientTestNormalizedName, 1);
ImposterTestNormalizedName = importdata('./NUAA/imposter_test_normalized.txt');
ImposterTestNormalizedNumber = size(ImposterTestNormalizedName, 1);
addpath('./libsvm-3.19/matlab');
load DoG_SVM_NUAA.mat

%% DoG feature of client testing data
ClientTestFeature = zeros(ClientTestNormalizedNumber, 64*64);
for i = 1 : ClientTestNormalizedNumber
    ClientTest = imread(['./NUAA/ClientNormalized/' ClientTestNormalizedName{i}]);
    ClientTestFeature(i, :) = DoG(ClientTest, 0.5, 1);
    ClientTestFeature(i, :) = (ClientTestFeature(i, :)-MinMax(1,:))./(MinMax(2,:)-MinMax(1,:));
end

%% DoG feature of imposter testing data
ImposterTestFeature = zeros(ImposterTestNormalizedNumber, 64*64);
for i = 1 : ImposterTestNormalizedNumber
    ImposterTest = imread(['./NUAA/ImposterNormalized/' ImposterTestNormalizedName{i}]);  
    ImposterTestFeature(i, :) = DoG(ImposterTest, 0.5, 1);
    ImposterTestFeature(i, :) = (ImposterTestFeature(i, :)-MinMax(1,:))./(MinMax(2,:)-MinMax(1,:));
end

%% SVM testing
[ClientTestLabel, ClientTestAccuracy, ClientTestValue] = svmpredict(ones(ClientTestNormalizedNumber,1), ClientTestFeature, model);
[ImposterTestLabel, ImposterTestAccuracy, ImposterTestValue] = svmpredict(-ones(ImposterTestNormalizedNumber,1), ImposterTestFeature, model);
accuracy = zeros(601, 3);
for i=-3:0.01:3
    accuracy(round(i*100+301),:)=[mean(ClientTestValue>=i),mean(ImposterTestValue<i),(sum(ClientTestValue>=i)+sum(ImposterTestValue<i))/(3362+5761)];
end