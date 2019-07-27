classdef SingleLabelLogisticRegressionModel
    properties
        Node
        LabelIndex
        FeaturesIndex
        FeaturesHandler
    end
    
    methods
        function obj = SingleLabelLogisticRegressionModel(featuresHandler, node)
            obj.Node = node;
            obj.FeaturesIndex = 1:size(node.FeatureNames, 2);
            obj.LabelIndex = size(node.FeatureNames, 2) + 1;
            obj.FeaturesHandler = featuresHandler;
        end
        
        function dag = GenerateDag(obj, showGraph)              
            networkSize = length(obj.LabelIndex) + length(obj.FeaturesIndex);
            dag = zeros(networkSize, networkSize);
            
            dag(obj.FeaturesIndex, obj.LabelIndex) = 1;
            
            if (showGraph == 2)
                obj.drawGraph(dag);
            end
        end
        
        function bnet = CreateBnet(obj)
            networkSize = length(obj.LabelIndex) + length(obj.FeaturesIndex);
            ns = ones(1, networkSize);
            ns(1, networkSize) = 2;
            
            discreteNodes = [];
            
            [~, index] = intersect(obj.Node.FeatureNames, "discrete:battery_plugged", "stable");
            if (~isempty(index))
                ns(1, index) = 4;
                discreteNodes = [discreteNodes index];
            end
            
            [~, index] = intersect(obj.Node.FeatureNames, "discrete:ringer_mode", "stable");
            if (~isempty(index))
                ns(1, index) = 4;
                discreteNodes = [discreteNodes index];
            end
            
            [~, index] = intersect(obj.Node.FeatureNames, "discrete:time_of_day", "stable");
            if (~isempty(index))
                ns(1, index) = 8;
                discreteNodes = [discreteNodes index];
            end
            
            [~, index] = intersect(obj.Node.FeatureNames, "discrete:wifi_status", "stable");
            if (~isempty(index))
                ns(1, index) = 4;
                discreteNodes = [discreteNodes index];
            end
            
            discreteNodes = [discreteNodes networkSize];

            dag = obj.GenerateDag(1);

            bnet = mk_bnet(dag, ns, 'discrete', discreteNodes, ...
                'observed', [obj.FeaturesIndex obj.LabelIndex]);
            
            for i=1:networkSize
                bnet.CPD{i} = gaussian_CPD(bnet, i);
            end
            
            for i=discreteNodes
                bnet.CPD{i} = tabular_CPD(bnet, i);
            end
            
            bnet.CPD{networkSize} = softmax_CPD(bnet, networkSize);
        end
        
        function sensorData = RawDataToGraphData(obj, features, labels)
            % Bnet doesn't support 0 values, so we have to increase all
            % discrete nodes by 1
            labels = labels + 1;
            
            % Order features based on node's order
            index = [];
            
            for f=obj.Node.FeatureNames
                [~, i] = intersect(obj.FeaturesHandler.FeatureNames, f, "stable");
                index = [index i];
            end
            
            features = features(:, index);
            
            [~, dNodes] = ...
                intersect(obj.Node.FeatureNames, ...
                ["discrete:time_of_day", "discrete:battery_plugged", ...
                "discrete:ringer_mode", "discrete:wifi_status"], "stable");
            cNodes = setdiff(1:length(obj.FeaturesIndex), dNodes);
            features(:, cNodes) = zscore(features(:, cNodes));
            
            sensorData = [features labels];
            sensorData = num2cell(sensorData');
            sensorData(cellfun(@isnan,sensorData)) = {[]};
        end
        
        function [sensorData, originalValue] = ClearLabelsValuesFromEvidence(obj, evidence)
            originalValue = evidence{size(evidence, 1), 1};
            evidence{size(evidence, 1), 1} = [];
            sensorData = evidence;
        end
        
        function marginalNode = GetLabelPrediction(obj, evidence, engine)
            marginalNode = marginal_nodes(engine, size(evidence, 1));
        end
        
        function drawGraph(obj, dag)
            figure();
            g = digraph(dag);
            h = plot(g, 'Layout','layered', 'NodeLabel', ...
                cellstr([obj.Node.FeatureNames obj.Node.LabelNames]));

            currentColor = rand(1,3);
            highlight(h, obj.FeaturesIndex, obj.LabelIndex, 'EdgeColor', currentColor)
            highlight(h, obj.LabelIndex, 'NodeColor', currentColor);
        end
    end
end

