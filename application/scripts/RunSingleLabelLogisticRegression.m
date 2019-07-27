columnsHandler = ColumnsHandler();
featuresHandler = FeaturesHandler();
labelsHandler = LabelsHandler();
graphHandler = GraphHandler(featuresHandler);
nodes = graphHandler.GenerateNodes();

for i=1:length(nodes)
    models(i) = SingleLabelLogisticRegressionModel(featuresHandler, nodes(i));
    models(i).GenerateDag(1);
end
preProcess = PreProcess(columnsHandler, featuresHandler, labelsHandler);
dataLoader = DataLoader(preProcess);

disp('Loading users to load');
validationData = dataLoader.LoadValidationData();

disp('Creating the bayesian network');
for i=1:length(models)
    bnets(i) = models(i).CreateBnet();
end

% disp('Loading users data');
% [features, labels, ~] = dataLoader.LoadMultipleSensorsData(validationData('0').train);

% disp('Creating inference engine');
% for i=1:length(bnets)
%     engines(i) = jtree_inf_engine(bnets(i));
% end
% 
% disp('Converting data to evidence');
% for i=1:length(nodes)
%     currentLabelsIndex = labelsHandler.GetLabelIndex(nodes(i).LabelNames);
%     currentFeaturesIndex = featuresHandler.GetFeatureIndex(nodes(i).FeatureNames);
%     currentLabels = labels(:, currentLabelsIndex);
%     rowHasEmpty = any(isnan(currentLabels), 2);
%     currentLabels(rowHasEmpty, :) = [];
%     currentFeatures = features;
%     currentFeatures(rowHasEmpty, :) = [];
% 
%     evidence = models(i).RawDataToGraphData(currentFeatures, currentLabels);
%     evidence = evidence(:, 1:10000);
%     nodes(i).Evidences = evidence;
% end
% 
% disp('Starting to learn network parameters');
% for i=1:length(nodes)
%     disp(['Node ' num2str(i) '/' num2str(length(nodes))]);
%     [bnet, ll, engine] = learn_params_em(engines(i), nodes(i).Evidences, 10);
%     filename = ['logistic_regression_engine_' num2str(i)];
%     save(filename, 'engine');
% end

disp('Starting predictions');
for i=1:length(nodes)
    filename = ['logistic_regression_engine_' num2str(i)];
    load(filename, 'engine');
    engines(i) = engine;
end

[features, labels, ~] = dataLoader.LoadMultipleSensorsData(validationData('0').test);
cNodes = graphHandler.GetContinousFeaturesIndex();
features(:, cNodes) = zscore(features(:, cNodes));

predictionsHandler = PredictionsHandler();
samplesCount = size(features, 1);
labelsIndex = graphHandler.GetLabelsIndex();

sumResults = zeros(samplesCount, 4);

for s=1:samplesCount
    if (mod(s, 100) == 0)
        disp(['Running test sample ', num2str(s), '/', num2str(samplesCount)]);
    end
    
    labelsCount = length(nodes);
    results = zeros(labelsCount, 4);
    
    for i=1:length(nodes)
        currentLabelsIndex = labelsHandler.GetLabelIndex(nodes(i).LabelNames);
        currentLabels = labels(:, currentLabelsIndex);
        evidence = models(i).RawDataToTestGraphData(features(s, :), currentLabels(s, :));
        [evidence, originalValue] = models(i).ClearLabelsValuesFromEvidence(evidence);
        [educated_engine, ~] = enter_evidence(engines(i), evidence);
        marginalNode = models(i).GetLabelPrediction(evidence, educated_engine);
        results(i, :) = predictionsHandler.GetSinglePredictionScore(marginalNode, originalValue);
    end

    sumResults(s, :) = sum(results);
end

testScore = predictionsHandler.GetPredictionsScore(sumResults);
disp(['Total score for the test run: ', num2str(testScore)]);
% Last successful run - Total score for the test run: 0.56262