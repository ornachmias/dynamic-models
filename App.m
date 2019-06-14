tic
columnsHandler = ColumnsHandler();
debugModel = DebugModel(columnsHandler);

dataLoader = DataLoader();
sensorData = loadSingleSensorsData(dataLoader, '0E6184E1-90C0-48EE-B25A-F1ECB7B9714E');
sensorData = sensorData(1:100, [getFeaturesIndex(columnsHandler) getLabelsIndex(columnsHandler)]);

bnet = createBnet(debugModel);
engine = jtree_inf_engine(bnet);
evidence = num2cell(sensorData');

[bnet2, LL2, engine2] = learn_params_em(engine, evidence, 3);


toc