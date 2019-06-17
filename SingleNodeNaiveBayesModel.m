classdef SingleNodeNaiveBayesModel
    properties
        Dag
        ColumnsHandler
        Engine
        NumberOfNodes
    end
    
    methods
        function obj = SingleNodeNaiveBayesModel(columnsHandler)
            obj.ColumnsHandler = columnsHandler;
            obj.NumberOfNodes = 0;
            obj.Dag = zeros(1, 1);
        end
        
        function dag = loadNodes(obj, node)
            obj.Dag = zeros(obj.NumberOfNodes, obj.NumberOfNodes);
            obj.Dag = addToGraph(node, obj.Dag, obj.ColumnsHandler);
            dag = obj.Dag;
        end
        
        function [bnet, sensorDataSubset, columnsHandler] = createBnet(obj, sensorData, node)
            columns = [node.LabelNames node.FeatureNames];

            subsetIndexes = GetColumnsIndex(obj.ColumnsHandler, columns);
            sensorDataSubset = sensorData(:, subsetIndexes);
            obj.ColumnsHandler.Columns = columnsSubset(obj.ColumnsHandler, columns);

            % Replace all nan values with 3
            B = sensorDataSubset;
            Lidx = isnan(sensorDataSubset);
            B(Lidx) = 3;
            sensorDataSubset(:,getLabelsIndex(obj.ColumnsHandler)) = B(:,getLabelsIndex(obj.ColumnsHandler));
            
            obj.NumberOfNodes = getTotalSize(obj.ColumnsHandler);
            ns = 3* ones(1, obj.NumberOfNodes);
            
            obj.Dag = obj.loadNodes(node);

            bnet = mk_bnet(obj.Dag, ns, 'discrete', getLabelsIndex(obj.ColumnsHandler), 'observed', getFeaturesIndex(obj.ColumnsHandler));

            for i=getFeaturesIndex(obj.ColumnsHandler)
                bnet.CPD{i} = gaussian_CPD(bnet, i);
            end
            
            for i=getLabelsIndex(obj.ColumnsHandler)
                ns(1, i) = 2;
                bnet.CPD{i} = tabular_CPD(bnet, i);
            end
            
            columnsHandler = obj.ColumnsHandler;
            obj.drawGraph(obj.Dag);
        end

        function predictions = predict(obj, sensorData, node, engine)
            columns = [node.LabelNames node.FeatureNames];

            subsetIndexes = GetColumnsIndex(obj.ColumnsHandler, columns);
            obj.ColumnsHandler.Columns = columnsSubset(obj.ColumnsHandler, columns);
            
            evidence = num2cell(sensorData(:, subsetIndexes)');
            for i=getLabelsIndex(obj.ColumnsHandler)
                evidence(i, :) = {[]};
            end
            
            predictions = [];
            for i=1:size(evidence, 2)
                e = evidence(:, i);
                [educated_engine, ~] = enter_evidence(engine, e);
                marg = marginal_nodes(educated_engine, getLabelsIndex(obj.ColumnsHandler));
                [~, p] = max(marg.T);
                predictions = [predictions p];
            end
        end
        
        function drawGraph(obj, dag)
            G = digraph(dag);
            h = plot(G,'Layout','force');
            labelnode(h, 1:obj.NumberOfNodes, 1:obj.NumberOfNodes);
        end
    end
end

