classdef NaiveBayesModel
    %NAIVEBAYESMODEL Full Naive Bayes model
    %   In this model the features are connected to several labels
    
    properties
        ColumnsHandler
        Dag
        NumberOfNodes
    end
    
    methods
        function obj = NaiveBayesModel(columnsHandler)
            obj.ColumnsHandler = columnsHandler;
            obj.Dag = zeros(1, 1);
            obj.NumberOfNodes = 0;
        end
        
        function dag = loadNodes(obj, nodes)
            obj.Dag = zeros(obj.NumberOfNodes, obj.NumberOfNodes);
            
            for node=nodes    
                [labelIds, ~, obj.Dag] = addToGraph(node, obj.Dag, obj.ColumnsHandler);
                obj.Dag(labelIds, obj.NumberOfNodes) = 1;
            end

            dag = obj.Dag;
        end
        
        function [columnsHandler, dataSubset] = createDataSubset(obj, sensorData, nodes)
            columns = [];
            for node=nodes
                columns = [columns node.LabelNames node.FeatureNames];
            end
            
            subsetIndexes = GetColumnsIndex(obj.ColumnsHandler, columns);
            dataSubset = sensorData(:, subsetIndexes);
            
            obj.ColumnsHandler.Columns = columnsSubset(obj.ColumnsHandler, columns);
            columnsHandler = obj.ColumnsHandler;
        end
        
        function newSensorData = replaceNanInLabels(obj, sensorData)
            B = sensorData;
            Lidx = isnan(sensorData);
            B(Lidx) = 3;
            sensorData(:, getLabelsIndex(obj.ColumnsHandler)) = B(:, getLabelsIndex(obj.ColumnsHandler));
            newSensorData = sensorData;
        end
        
        function [bnet, sensorDataSubset, columnsHandler] = createBnet(obj, sensorData, nodes)
            [obj.ColumnsHandler, sensorDataSubset] = obj.createDataSubset(sensorData, nodes);
            sensorDataSubset = obj.replaceNanInLabels(sensorDataSubset);
            
            % Add column to data for the sofmax function, we dont care
            % about the values since we are going to override it later
            sensorDataSubset = [sensorDataSubset sensorDataSubset(:, 1)];
            
            % Add one to the softmax node
            obj.NumberOfNodes = getTotalSize(obj.ColumnsHandler) + 1;
            
            ns = 4* ones(1, obj.NumberOfNodes);
            ns(1, obj.NumberOfNodes) = 6;
            
            obj.Dag = obj.loadNodes(nodes);

            % Softmax node is the last one, so we add its' Id as well
            bnet = mk_bnet(obj.Dag, ns, 'discrete', [getLabelsIndex(obj.ColumnsHandler) obj.NumberOfNodes], 'observed', getFeaturesIndex(obj.ColumnsHandler));

            for i=getFeaturesIndex(obj.ColumnsHandler)
                bnet.CPD{i} = gaussian_CPD(bnet, i);
            end
            
            for i=getLabelsIndex(obj.ColumnsHandler)
                ns(1, i) = 2;
                bnet.CPD{i} = tabular_CPD(bnet, i);
            end
            
            bnet.CPD{obj.NumberOfNodes} = softmax_CPD(bnet, obj.NumberOfNodes, 'discrete', getLabelsIndex(obj.ColumnsHandler));
            
            columnsHandler = obj.ColumnsHandler;
            obj.drawGraph(obj.Dag);
        end
        
        function drawGraph(obj, dag)
            G = digraph(dag);
            h = plot(G,'Layout','force');
            highlight(h, obj.NumberOfNodes, 'NodeColor', 'r')
            labelnode(h, 1:obj.NumberOfNodes, 1:obj.NumberOfNodes);
        end
    end
end

