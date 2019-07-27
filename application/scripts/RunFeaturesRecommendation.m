columnsHandler = ColumnsHandler();
featuresHandler = FeaturesHandler();
labelsHandler = LabelsHandler();
preProcess = PreProcess(columnsHandler, featuresHandler, labelsHandler);
dataLoader = DataLoader(preProcess);
validationData = dataLoader.LoadValidationData();

[features, labels, ~] = dataLoader.LoadMultipleSensorsData(validationData('0').train);
featuresSelection = FeaturesSelection(featuresHandler, labelsHandler);

featureCorrelation = featuresSelection.FeaturesCorrelation(features, 2);
featureLabelsCorrelation = featuresSelection.FeaturesLabelsCorrelation(features, labels, 2);
featuresSelection.RecommendFeatures(featureLabelsCorrelation, featureCorrelation);