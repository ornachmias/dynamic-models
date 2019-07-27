classdef DBNModel
    properties
        GraphHandler
        Nodes
        FeaturesHandler
    end
    
    methods
        function obj = DBNModel(graphHandler, nodes, featuresHandler)
            obj.GraphHandler = graphHandler;
            obj.Nodes = nodes;
            obj.FeaturesHandler = featuresHandler;
        end
        
        function [dag, outerConnections] = GenerateNetworkConnections(obj, showGraph)
            networkSize = length(obj.GraphHandler.AllNodesNames);
            dag = zeros(networkSize, networkSize);
            outerConnections = zeros(networkSize, networkSize);
            
            for n1 = obj.Nodes
                labelsIndex1 = obj.GraphHandler.GetNodesIndex(n1.LabelNames);
                featuresIndex = obj.GraphHandler.GetNodesIndex(n1.FeatureNames);
                dag(labelsIndex1, featuresIndex) = 1;
                
                for n2 = obj.Nodes
                    labelsIndex2 = obj.GraphHandler.GetNodesIndex(n2.LabelNames);
                    outerConnections(labelsIndex1, labelsIndex2) = 1;
                end
            end

            if (showGraph == 2)
                obj.drawGraph(dag, outerConnections);
            end
        end
        
        function bnet = CreateBnet(obj)
            networkSize = length(obj.GraphHandler.AllNodesNames);
            ns = zeros(1, networkSize);
            ns(1, obj.GraphHandler.GetLabelsIndex()) = 3;
            ns(1, obj.GraphHandler.GetNodesIndex("discrete:battery_plugged")) = 4;
            ns(1, obj.GraphHandler.GetNodesIndex("discrete:ringer_mode")) = 4;
            ns(1, obj.GraphHandler.GetNodesIndex("discrete:time_of_day")) = 8;
            ns(1, obj.GraphHandler.GetNodesIndex("discrete:wifi_status")) = 4;
            [dag, outerConnections] = obj.GenerateNetworkConnections(1);

            bnet = mk_dbn(dag, outerConnections, ns, 'discrete', ...
                [obj.GraphHandler.GetDiscreteFeaturesIndex() obj.GraphHandler.GetLabelsIndex()], ...
                'observed', obj.GraphHandler.GetFeaturesIndex());
            
            for i=obj.GraphHandler.GetContinousFeaturesIndex()
                bnet.CPD{i} = gaussian_CPD(bnet, i);
            end
            
            for i=obj.GraphHandler.GetDiscreteFeaturesIndex()
                bnet.CPD{i} = tabular_CPD(bnet, i);
            end
            
            for i=obj.GraphHandler.GetLabelsIndex()
                bnet.CPD{i} = tabular_CPD(bnet, i);
            end
            
            for i=57:70
                bnet.CPD{i} = tabular_CPD(bnet, i);
            end
        end
        
        function drawGraph(obj, dag, intra)
            figure();
            g = digraph(dag);
            h = plot(g, 'Layout','layered', 'NodeLabel', cellstr(obj.GraphHandler.AllNodesNames));

            for n = obj.Nodes
                labelsIndex = obj.GraphHandler.GetNodesIndex(n.LabelNames);
                featuresIndex = obj.GraphHandler.GetNodesIndex(n.FeatureNames);
                currentColor = rand(1,3);
                highlight(h, labelsIndex, featuresIndex, 'EdgeColor', currentColor)
                highlight(h, labelsIndex, 'NodeColor', currentColor);
            end
            
            disp('Intra connections:');
            
            for i = 1:size(intra, 1)
                if (any(intra(i, :)))
                    parent = obj.GraphHandler.GetNodesDescription(i);
                    fprintf('%s ---> ', parent);
                    
                    for j = 1:size(intra, 2)
                        if (intra(i, j) == 1)
                            child = obj.GraphHandler.GetNodesDescription(j);
                            fprintf(' %s', child);
                        end
                    end
                    
                    disp(' ');
                end
            end
        end
        
        function sensorData = RawDataToGraphData(obj, features, labels)
            % Bnet doesn't support 0 values, so we have to increase all
            % discrete nodes by 1
            labels = labels + 1;
            
            % Replace NaN values with a third value to avoid errors
            labels(isnan(labels)) = 3;
            
            featuresDescription = [obj.GraphHandler.ContinuousNodesNames obj.GraphHandler.DiscreteNodesNames];
            featuresIndex = [];
            
            for f=featuresDescription
                featuresIndex = [featuresIndex obj.FeaturesHandler.GetFeatureIndex(f)];
            end
            
            features = features(:, featuresIndex);
            
            cNodes = obj.GraphHandler.GetContinousFeaturesIndex();
            features(:, cNodes) = zscore(features(:, cNodes));
            sensorData = [features labels];
            sensorData = num2cell(sensorData');
            sensorData(cellfun(@isnan,sensorData)) = {[]};
        end
    end
end

