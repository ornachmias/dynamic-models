classdef TimeNaiveBayesModel
    properties
        GraphHandler
        Nodes
        FeaturesHandler
    end
    
    methods
        function obj = TimeNaiveBayesModel(graphHandler, nodes, featuresHandler)
            obj.GraphHandler = graphHandler;
            obj.Nodes = nodes;
            obj.FeaturesHandler = featuresHandler;
        end
        
        function dag = GenerateDag(obj, showGraph)
            networkSize = length(obj.GraphHandler.AllNodesNames) * 3;
            dag = zeros(networkSize, networkSize);
            secondNetworkDiff = length(obj.GraphHandler.AllNodesNames);
            thirdNetworkDiff = 2 * secondNetworkDiff;
            
            for n = obj.Nodes
                labelsIndex = obj.GraphHandler.GetNodesIndex(n.LabelNames);
                featuresIndex = obj.GraphHandler.GetNodesIndex(n.FeatureNames);
                dag(labelsIndex, featuresIndex) = 1;
                
                labelsIndex = secondNetworkDiff + obj.GraphHandler.GetNodesIndex(n.LabelNames);
                featuresIndex = secondNetworkDiff + obj.GraphHandler.GetNodesIndex(n.FeatureNames);
                dag(labelsIndex, featuresIndex) = 1;
                
                labelsIndex = thirdNetworkDiff + obj.GraphHandler.GetNodesIndex(n.LabelNames);
                featuresIndex = thirdNetworkDiff + obj.GraphHandler.GetNodesIndex(n.FeatureNames);
                dag(labelsIndex, featuresIndex) = 1;
            end
            
            for n1 = obj.Nodes
                for n2 = obj.Nodes
                    label1 = obj.GraphHandler.GetNodesIndex(n1.LabelNames);
                    label2 = obj.GraphHandler.GetNodesIndex(n2.LabelNames);
                    
                    dag(label1, label2 + secondNetworkDiff) = 1;
                    dag(label1 + secondNetworkDiff, label2 + thirdNetworkDiff) = 1; 
                end
            end
            
            if (showGraph == 2)
                obj.drawGraph(dag);
            end
        end
        
        function bnet = CreateBnet(obj)
            networkSize = length(obj.GraphHandler.AllNodesNames) * 3;
            ns = zeros(1, networkSize);
            
            secondNetworkDiff = length(obj.GraphHandler.AllNodesNames);
            thirdNetworkDiff = 2 * secondNetworkDiff;
            
            ns(1, obj.GraphHandler.GetLabelsIndex()) = 3;
            ns(1, obj.GraphHandler.GetNodesIndex("discrete:battery_plugged")) = 4;
            ns(1, obj.GraphHandler.GetNodesIndex("discrete:ringer_mode")) = 4;
            ns(1, obj.GraphHandler.GetNodesIndex("discrete:time_of_day")) = 8;
            ns(1, obj.GraphHandler.GetNodesIndex("discrete:wifi_status")) = 4;
            
            ns(1, secondNetworkDiff + obj.GraphHandler.GetLabelsIndex()) = 3;
            ns(1, secondNetworkDiff + obj.GraphHandler.GetNodesIndex("discrete:battery_plugged")) = 4;
            ns(1, secondNetworkDiff + obj.GraphHandler.GetNodesIndex("discrete:ringer_mode")) = 4;
            ns(1, secondNetworkDiff + obj.GraphHandler.GetNodesIndex("discrete:time_of_day")) = 8;
            ns(1, secondNetworkDiff + obj.GraphHandler.GetNodesIndex("discrete:wifi_status")) = 4;
            
            ns(1, thirdNetworkDiff + obj.GraphHandler.GetLabelsIndex()) = 3;
            ns(1, thirdNetworkDiff + obj.GraphHandler.GetNodesIndex("discrete:battery_plugged")) = 4;
            ns(1, thirdNetworkDiff + obj.GraphHandler.GetNodesIndex("discrete:ringer_mode")) = 4;
            ns(1, thirdNetworkDiff + obj.GraphHandler.GetNodesIndex("discrete:time_of_day")) = 8;
            ns(1, thirdNetworkDiff + obj.GraphHandler.GetNodesIndex("discrete:wifi_status")) = 4;
            
            dag = obj.GenerateDag(1);

            bnet = mk_bnet(dag, ns, 'discrete', ...
                [obj.GraphHandler.GetDiscreteFeaturesIndex() obj.GraphHandler.GetLabelsIndex() ...
                secondNetworkDiff + obj.GraphHandler.GetDiscreteFeaturesIndex() secondNetworkDiff + obj.GraphHandler.GetLabelsIndex() ...
                thirdNetworkDiff + obj.GraphHandler.GetDiscreteFeaturesIndex() thirdNetworkDiff + obj.GraphHandler.GetLabelsIndex()], ...
                'observed', [obj.GraphHandler.GetFeaturesIndex() secondNetworkDiff + obj.GraphHandler.GetFeaturesIndex() thirdNetworkDiff + obj.GraphHandler.GetFeaturesIndex()]);
            
            for i=obj.GraphHandler.GetContinousFeaturesIndex()
                bnet.CPD{i} = gaussian_CPD(bnet, i);
            end
            
            for i=obj.GraphHandler.GetContinousFeaturesIndex() + secondNetworkDiff
                bnet.CPD{i} = gaussian_CPD(bnet, i);
            end
            
            for i=obj.GraphHandler.GetContinousFeaturesIndex() + thirdNetworkDiff
                bnet.CPD{i} = gaussian_CPD(bnet, i);
            end
            
            for i=obj.GraphHandler.GetDiscreteFeaturesIndex()
                bnet.CPD{i} = tabular_CPD(bnet, i);
            end
            
            for i=obj.GraphHandler.GetDiscreteFeaturesIndex() + secondNetworkDiff
                bnet.CPD{i} = tabular_CPD(bnet, i);
            end
            
            for i=obj.GraphHandler.GetDiscreteFeaturesIndex() + thirdNetworkDiff
                bnet.CPD{i} = tabular_CPD(bnet, i);
            end
            
            for i=obj.GraphHandler.GetLabelsIndex()
                bnet.CPD{i} = tabular_CPD(bnet, i);
            end
            
            for i=obj.GraphHandler.GetLabelsIndex() + secondNetworkDiff
                bnet.CPD{i} = tabular_CPD(bnet, i);
            end
            
            for i=obj.GraphHandler.GetLabelsIndex() + thirdNetworkDiff
                bnet.CPD{i} = tabular_CPD(bnet, i);
            end
        end
        
        function sensorData = RawDataToTestTimeGraphData(obj, features, labels)
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

            singleNetworkSize = size([features labels], 2) * 3;
            samplesSize = size(features, 1) - 2;
            sensorData = zeros(samplesSize, singleNetworkSize);
            
            predictionlabels = NaN(size(labels(1, :)));
            sensorData(1, :) = [features(1, :) labels(1, :) features(2, :) labels(2, :) features(3, :) predictionlabels];
            
            sensorData = sensorData(any(sensorData,2),:);
            sensorData = num2cell(sensorData');
            sensorData(cellfun(@isnan,sensorData)) = {[]};
        end
        
        function drawGraph(obj, dag)
            figure();
            g = digraph(dag);
            h = plot(g, 'Layout', 'layered', 'NodeLabel', ...
                cellstr([obj.GraphHandler.AllNodesNames obj.GraphHandler.AllNodesNames obj.GraphHandler.AllNodesNames]));

            secondNetworkDiff = length(obj.GraphHandler.AllNodesNames);
            thirdNetworkDiff = 2 * secondNetworkDiff;
            
            for n = obj.Nodes
                labelsIndex = obj.GraphHandler.GetNodesIndex(n.LabelNames);
                featuresIndex = obj.GraphHandler.GetNodesIndex(n.FeatureNames);
                currentColor = rand(1,3);
                highlight(h, labelsIndex, featuresIndex, 'EdgeColor', currentColor)
                highlight(h, labelsIndex, 'NodeColor', currentColor);
                
                highlight(h, secondNetworkDiff + labelsIndex, ...
                    secondNetworkDiff + featuresIndex, 'EdgeColor', currentColor)
                highlight(h, secondNetworkDiff + labelsIndex, 'NodeColor', currentColor);
                
                highlight(h, thirdNetworkDiff + labelsIndex, ...
                    thirdNetworkDiff + featuresIndex, 'EdgeColor', currentColor)
                highlight(h, thirdNetworkDiff + labelsIndex, 'NodeColor', currentColor);
            end
        end
    end
end

