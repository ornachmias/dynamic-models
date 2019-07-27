columnsHandler = ColumnsHandler();
featuresHandler = FeaturesHandler();
labelsHandler = LabelsHandler();
graphHandler = GraphHandler(featuresHandler);
nodes = graphHandler.GenerateNodes();
timeNaiveBayesModel = TimeNaiveBayesModel(graphHandler, nodes);
timeNaiveBayesModel.GenerateDag(1);
preProcess = PreProcess(columnsHandler, featuresHandler, labelsHandler);
dataLoader = DataLoader(preProcess);

disp('Loading users to load');
validationData = dataLoader.LoadValidationData();

disp('Creating the bayesian network');
bnet = timeNaiveBayesModel.CreateBnet();
 
disp('Loading users data');
[features, labels, timestamps] = dataLoader.LoadMultipleSensorsData(validationData('0').train);

disp('Creating inference engine');
engine = jtree_inf_engine(bnet);

disp('Converting data to evidence');
evidence = graphHandler.RawDataToTimeGraphData(features, labels, timestamps);

disp('Starting to learn network parameters');
evidence = evidence(:, 1:1000);
[bnet, ll, engine] = learn_params_em(engine, evidence, 10);

save 'time_naive_bayes_engine' engine
save 'time_naive_bayes_bnet' bnet

% load 'time_naive_bayes_engine' engine
% load 'time_naive_bayes_bnet' bnet
% 
% [features, labels] = dataLoader.LoadMultipleSensorsData(validationData('0').test);
% 
% predictionsHandler = PredictionsHandler();
% samplesCount = size(features, 1);
% labelsIndex = graphHandler.GetLabelsIndex();
% 
% sumResults = zeros(samplesCount, 4);
% 
% for s=1:samplesCount
%     if (mod(s, 100) == 0)
%         disp(['Running test sample ', num2str(s), '/', num2str(samplesCount)]);
%     end
%     
%     evidence = graphHandler.RawDataToGraphData(features(s, :), labels(s, :));
%     evidence = graphHandler.ClearLabelsValuesFromEvidence(evidence);
% 
%     [educated_engine, ~] = enter_evidence(engine, evidence);
%     
%     labelsCount = length(labelsIndex);
%     results = zeros(labelsCount, 4);
%     
%     l = 1;
%     for i=1:labelsCount
%         marginalNode = marginal_nodes(educated_engine, labelsIndex(i));
%         results(l, :) = predictionsHandler.GetSinglePredictionScore(marginalNode, labels(s, l));
%         l = l + 1;
%     end
%     
%     sumResults(s, :) = sum(results);
% end
% 
% testScore = predictionsHandler.GetPredictionsScore(sumResults);
% disp(['Total score for the test run: ', num2str(testScore)]);
% Last successful run - Total score for the test run: 0.5816