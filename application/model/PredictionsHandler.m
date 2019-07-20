classdef PredictionsHandler
    properties
    end
    
    methods
        function obj = PredictionsHandler()
        end

        function singleScore = GetSinglePredictionScore(obj, marginalNode, groundTruth)
            [~, nodePrediction] = sort(marginalNode.T, 'descend');
            nodePrediction = nodePrediction(1);
            
            % The result return in the following format:
            % [TP TN FP FN]
            
            % Default value in case one of the values in NaN
            singleScore = [0 0 0 0];
            
            if (nodePrediction == 2 && groundTruth == 1)
                singleScore = [1 0 0 0];
            elseif (nodePrediction == 1 && groundTruth == 0)
                singleScore = [0 1 0 0];
            elseif (nodePrediction == 2 && groundTruth == 0)
                singleScore = [0 0 1 0];
            elseif (nodePrediction == 1 && groundTruth == 1)
                singleScore = [0 0 0 1];
            end
        end
        
        function score = GetPredictionsScore(obj, scoresSet)
            total = sum(scoresSet);
            TP = total(1);
            TN = total(2);
            FP = total(3);
            FN = total(4);
            
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

