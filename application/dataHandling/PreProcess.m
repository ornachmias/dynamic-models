classdef PreProcess
    properties
        ColumnsHandler
        FeaturesHandler
        LabelsHandler
    end
    
    methods
        function obj = PreProcess(columnsHandler, featuresHandler, labelsHandler)
            obj.ColumnsHandler = columnsHandler;
            obj.FeaturesHandler = featuresHandler;
            obj.LabelsHandler = labelsHandler;
        end
        
        function [features, labels, timestamps] = RunPreprocess(obj, userSensorData)
            [processedData, timestamps] = obj.removeColumns(userSensorData);
            [features, labels] = obj.separateSensorData(processedData);
            features = obj.mergeColumns(features);
            features = obj.replaceMissingValues(features);
        end

        function [newUserSensorData, timestamps] = removeColumns(obj, sensorData)
            % Get only the columns' index we are about
            [~, columnsIndex] = intersect(obj.ColumnsHandler.RawColumns, obj.ColumnsHandler.Columns, "stable");
            
            % Filter those specific columns
            timestamps = sensorData(:, 1);
            newUserSensorData = sensorData(:, columnsIndex);
        end
        
        function [features, labels] = separateSensorData(obj, sensorData)
            % This separation is relying that we already removed unecessary
            % columns, but didn't merge yet
            features = sensorData(:, obj.getFeaturesIndex());
            labels = sensorData(:, obj.getLabelsIndex());
        end
        
        function newUserSensorFeatures = mergeColumns(obj, sensorFeatures)
            [r1, d1] = obj.mergeSpecificFeature('discrete:battery_plugged:', sensorFeatures);
            [r2, d2] = obj.mergeSpecificFeature('discrete:battery_state:', sensorFeatures);
            [r3, d3] = obj.mergeSpecificFeature('discrete:on_the_phone:', sensorFeatures);
            [r4, d4] = obj.mergeSpecificFeature('discrete:ringer_mode:', sensorFeatures);
            [r5, d5] = obj.mergeSpecificFeature('discrete:wifi_status:', sensorFeatures);
            [r6, d6] = obj.mergeSpecificFeature('discrete:time_of_day:', sensorFeatures);
            
            sensorFeatures(:, [r1 r2 r3 r4 r5 r6]) = [];
            newUserSensorFeatures = [sensorFeatures d1 d2 d3 d4 d5 d6];
        end
        
        function [removableIndex, newData] = mergeSpecificFeature(obj, featurePrefix, sensorFeatures)
            IndexC = strfind(obj.ColumnsHandler.Columns, featurePrefix);
            removableIndex = find(not(cellfun('isempty',IndexC)));
            data = sensorFeatures(:, removableIndex);
            newData = zeros(size(data, 1), 1);
            for i=1:size(data, 1)
                newData(i, 1) = NaN;
                for j=1:size(data, 2)
                    if (data(i, j) == 1)
                        newData(i) = j;
                        break;
                    end
                end
            end
        end
        
        function featuresIndex = getFeaturesIndex(obj)
            featuresIndex = find(~contains(obj.ColumnsHandler.Columns, 'label:'));
        end
        
        function labelsIndex = getLabelsIndex(obj)
            labelsIndex = find(contains(obj.ColumnsHandler.Columns, 'label:'));
        end
        
        function features = replaceMissingValues(obj, features)
            features(:, obj.FeaturesHandler.GetContinuousFeatures()) = ...
                fillmissing(features(:, obj.FeaturesHandler.GetContinuousFeatures()), 'linear');
            
            features(:, obj.FeaturesHandler.GetDiscreteFeatures()) = ...
                fillmissing(features(:, obj.FeaturesHandler.GetDiscreteFeatures()), 'nearest');
        end
        
        function PrintStats(obj, features, description)
            disp(description);
            disp(' ');
            
            for f=1:(length(obj.FeaturesHandler.FeatureNames))
                featureName = obj.FeaturesHandler.FeatureNames(f);
                featureValues = features(:, f);
                
                disp(featureName);
                fprintf('Number of NaN values: %d\n', sum(isnan(featureValues)));
                
                featureValues = featureValues(~isnan(featureValues));
                v = var(featureValues);
                m = mean(featureValues);    
                
                if (contains(featureName, 'discrete:'))
                    uniqueValues = unique(featureValues);
                    occur = histc(featureValues, uniqueValues);
                    
                    for i=1:length(uniqueValues)
                        fprintf('%d: %d\n', uniqueValues(i), occur(i))
                    end
                else
                    fprintf('Mean: %d\n', m);
                    fprintf('Variance: %d\n', v);
                end
                
                disp(' ');
            end
        end
    end
end

