columnsHandler = ColumnsHandler();
featuresHandler = FeaturesHandler();
labelsHandler = LabelsHandler();
graphHandler = GraphHandler(featuresHandler);
nodes = graphHandler.GenerateNodes();
logisticRegressionModel = LogisticRegressionModel(graphHandler, nodes);
%dag = logisticRegressionModel.GenerateDag(2);
disp('Creating the bayesian network');
bnet = logisticRegressionModel.CreateBnet();

preProcess = PreProcess(columnsHandler, featuresHandler, labelsHandler);
dataLoader = DataLoader(preProcess);

disp('Loading users to load');
validationData = dataLoader.LoadValidationData();

disp('Loading users data');
[features, labels] = dataLoader.LoadMultipleSensorsData(validationData('0').train);

features = features(1:100, :);
labels = labels(1:100, :);

disp('Converting data to evidence');
evidence = graphHandler.RawDataToGraphData(features, labels);

disp('Creating inference engine');
engine = jtree_inf_engine(bnet);

disp('Starting to learn network parameters');
[bnet2, LL2, engine2] = learn_params_em(engine, evidence, 3);

