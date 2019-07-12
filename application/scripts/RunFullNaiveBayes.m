warning off all;

dataLoader = DataLoader();
validationSet = loadValidationData(dataLoader);
train = validationSet(char(0)).train;

nodes = createNodes_mi();
engines = [];
subModels = [];

columnsHandler = ColumnsHandler();
preProcess = PreProcess(columnsHandler);

tic
naiveBayesModel = NaiveBayesModel(columnsHandler);
sensorData = loadMultipleSensorsData(dataLoader, train);
sensorData = sensorData(randperm(size(sensorData, 1)), :);
sensorData = sensorData(:, [getFeaturesIndex(columnsHandler) getLabelsIndex(columnsHandler)]);

[bnet, sensorDataSubset, columnsHandler] = createBnet(naiveBayesModel, sensorData, nodes);
sensorDataSubset(:, getFeaturesIndex(columnsHandler)) = runPreprocess(preProcess, sensorDataSubset(:, getFeaturesIndex(columnsHandler)));
sensorDataSubset(:, getLabelsIndex(columnsHandler)) = sensorDataSubset(:, getLabelsIndex(columnsHandler)) + 1;
% sensorDataSubset = sensorDataSubset(1:1000, :);
engine = jtree_inf_engine(bnet);
evidence = num2cell(sensorDataSubset');

j = size(evidence, 1);
for i=1:size(evidence, 2)
    evidence{j, i} = [];
end

[bnet2, LL2, engine2] = learn_params_em(engine, evidence, 1);
educated_engine = jtree_inf_engine(bnet2);

% Can't go beyond this point, the network doesnt iterate properly in the EM
% (no failure, just taking a long time)

