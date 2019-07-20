columnsHandler = ColumnsHandler();
featuresHandler = FeaturesHandler();
labelsHandler = LabelsHandler();
preProcess = PreProcess(columnsHandler, featuresHandler, labelsHandler);
dataLoader = DataLoader(preProcess);
validationData = dataLoader.LoadValidationData();

[features, labels, ~] = dataLoader.LoadMultipleSensorsData(validationData('0').train);
featuresSelection = FeaturesSelection(featuresHandler, labelsHandler);

featureCorrelation = featuresSelection.FeaturesCorrelation(features, 1);
featureLabelsCorrelation = featuresSelection.FeaturesLabelsCorrelation(features, labels, 1);
featuresSelection.RecommendFeatures(featureLabelsCorrelation, featureCorrelation);