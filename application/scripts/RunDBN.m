columnsHandler = ColumnsHandler();
featuresHandler = FeaturesHandler();
labelsHandler = LabelsHandler();
graphHandler = GraphHandler(featuresHandler);
nodes = graphHandler.GenerateNodes();
dbn = DBNModel(graphHandler, nodes, featuresHandler);
dbn.GenerateNetworkConnections(2);
preProcess = PreProcess(columnsHandler, featuresHandler, labelsHandler);
dataLoader = DataLoader(preProcess);

disp('Loading users to load');
validationData = dataLoader.LoadValidationData();

disp('Creating the bayesian network');
bnet = dbn.CreateBnet();
 
disp('Loading users data');
[features, labels, timestamps] = dataLoader.LoadMultipleSensorsData(validationData('0').train);

disp('Creating inference engine');
engine = jtree_inf_engine(bnet);

disp('Converting data to evidence');
evidence = dbn.RawDataToGraphData(features, labels);

disp('Starting to learn network parameters');
[bnet, ll, engine] = learn_params_dbn_em(engine, {evidence}, 'max_iter', 10);

save 'dbn_engine' engine
save 'dbn_bnet' bnet