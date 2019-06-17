classdef PredictionsHandler
    properties
        ColumnsHandler
    end
    
    methods
        function obj = PredictionsHandler(columnsHandler)
            obj.ColumnsHandler = columnsHandler;
        end
        
        function score = GetPredictionsScore(obj, nodes, sensorData, predictions)
            TP = 0;
            TN = 0;
            for i=1:length(nodes)
                nodePredictions = predictions(:, i);
                nodeLabel = nodes(i).LabelNames;
                subsetIndexes = GetColumnsIndex(obj.ColumnsHandler, nodeLabel);
                for j=1:size(nodePredictions, 1)
                    if (nodePredictions(j, i) == 1 && sensorData(j, subsetIndexes) == 1)
                        TP = TP + 1;
                    elseif (nodePredictions(j, i) == 0 && sensorData(j, subsetIndexes) == 0)
                        TN = TN + 1;
                    end
                end
            end
        end
    end
end

