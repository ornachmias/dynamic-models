classdef TimeNaiveBayesModel
    properties
        GraphHandler
        Nodes
    end
    
    methods
        function obj = TimeNaiveBayesModel(graphHandler, nodes)
            obj.GraphHandler = graphHandler;
            obj.Nodes = nodes;
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
            networkSize = length(obj.GraphHandler.AllNodesNames);
            ns = zeros(1, networkSize);
            ns(1, obj.GraphHandler.GetLabelsIndex()) = 3;
            ns(1, obj.GraphHandler.GetNodesIndex("discrete:battery_plugged")) = 4;
            ns(1, obj.GraphHandler.GetNodesIndex("discrete:ringer_mode")) = 4;
            ns(1, obj.GraphHandler.GetNodesIndex("discrete:time_of_day")) = 8;
            ns(1, obj.GraphHandler.GetNodesIndex("discrete:wifi_status")) = 4;
            dag = obj.GenerateDag(1);

            bnet = mk_bnet(dag, ns, 'discrete', ...
                [obj.GraphHandler.GetDiscreteFeaturesIndex() obj.GraphHandler.GetLabelsIndex()], ...
                'observed', obj.GraphHandler.GetFeaturesIndex(), ...
                'names', [obj.GraphHandler.ContinuousNodesNames obj.GraphHandler.DiscreteNodesNames obj.GraphHandler.LabelNodesNames]);
            
            for i=obj.GraphHandler.GetContinousFeaturesIndex()
                bnet.CPD{i} = gaussian_CPD(bnet, i);
            end
            
            for i=obj.GraphHandler.GetDiscreteFeaturesIndex()
                bnet.CPD{i} = tabular_CPD(bnet, i);
            end
            
            for i=obj.GraphHandler.GetLabelsIndex()
                bnet.CPD{i} = tabular_CPD(bnet, i);
            end
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

