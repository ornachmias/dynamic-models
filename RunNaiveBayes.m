warning off all;

nodes = createNodes();
engines = [];
subModels = [];

dataLoader = DataLoader();
validationSet = loadValidationData(dataLoader);
train = validationSet(char(0)).train;
    
for node=nodes
    columnsHandler = ColumnsHandler();
    preProcess = PreProcess(columnsHandler);

    tic
    naiveBayesModel = SingleNodeNaiveBayesModel(columnsHandler);
    sensorData = loadMultipleSensorsData(dataLoader, train);
    sensorData = sensorData(randperm(size(sensorData, 1)), :);
    sensorData = sensorData(:, [getFeaturesIndex(columnsHandler) getLabelsIndex(columnsHandler)]);
    sensorData(:, getLabelsIndex(columnsHandler)) = sensorData(:, getLabelsIndex(columnsHandler)) + 1;

    [bnet, sensorDataSubset, columnsHandler] = createBnet(naiveBayesModel, sensorData(1:1000, :), node);
    sensorDataSubset(:, getFeaturesIndex(columnsHandler)) = runPreprocess(preProcess, sensorDataSubset(:, getFeaturesIndex(columnsHandler)));
    engine = jtree_inf_engine(bnet);
    evidence = num2cell(sensorDataSubset');

    [bnet2, LL2, engine2] = learn_params_em(engine, evidence, 1);
    educated_engine = jtree_inf_engine(bnet2);
    engines = [engines educated_engine];
    subModels = [subModels naiveBayesModel];
    toc
end

test = validationSet(char(0)).test;
sensorData = loadMultipleSensorsData(dataLoader, test);
sensorData = sensorData(randperm(size(sensorData, 1)), :);
sensorData(:, getLabelsIndex(columnsHandler)) = sensorData(:, getLabelsIndex(columnsHandler)) + 1;
sensorData(:, getFeaturesIndex(columnsHandler)) = runPreprocess(preProcess, sensorData(:, getFeaturesIndex(columnsHandler)));
sensorData = sensorData(1:10, :);

predictions = [];
for i=1:length(nodes)
    node = nodes(i);
    engine = engines(i);
    model = subModels(i);
    prediction = predict(model, sensorData, node, engine);
    predictions = [prediction; predictions];
end


% evidence = num2cell(sensorDataSubset(100, :));
% evidence(:, end) = {[]};
% mask = cellfun(@(C) isnumeric(C) && isscalar(C) && isnan(C), evidence);
% evidence(mask) = {[]}; 
% [educated_engine, ~] = enter_evidence(educated_engine, evidence);
% marg = marginal_nodes(educated_engine, 77);
