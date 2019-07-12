classdef PredictionsHandler
    properties
        ColumnsHandler
    end
    
    methods
        function obj = PredictionsHandler(columnsHandler)
            obj.ColumnsHandler = columnsHandler;
        end
        
        function score = getPredictionsScore(obj, nodes, sensorData, predictions)
            TP = 0;
            TN = 0;
            FP = 0;
            FN = 0;
            for i=1:length(nodes)
                nodePredictions = predictions(i, :);
                nodeLabel = nodes(i).LabelNames;
                subsetIndexes = GetColumnsIndex(obj.ColumnsHandler, nodeLabel);
                for j=1:size(nodePredictions, 2)
                    if (nodePredictions(1, j) == 2 && sensorData(j, subsetIndexes) == 2)
                        TP = TP + 1;
                    elseif (nodePredictions(1, j) == 1 && sensorData(j, subsetIndexes) == 1)
                        TN = TN + 1;
                    elseif (nodePredictions(1, j) == 2 && sensorData(j, subsetIndexes) == 1)
                        FP = FP + 1;
                    elseif (nodePredictions(1, j) == 1 && sensorData(j, subsetIndexes) == 2)
                        FN = FN + 1;
                    end
                end
            end
            
            a = 0;
            if (TP + FN ~= 0)
                a = TP/(TP + FN);
            end
            
            b = 0;
            if (TN + FP ~= 0)
                b = TN/(TN + FP);
            end
            
            score = 0.5 * (a + b);
        end
    end
end

