classdef DebugModel
    properties
        Dag
        ColumnsHandler
        Engine
        NumberOfNodes
    end
    
    methods
        function obj = DebugModel()
            obj.ColumnsHandler = ColumnsHandler();
            obj.NumberOfNodes = 278;
            obj.Dag = zeros(n, n);
        end
        
        function loadNodes(obj, nodes)
            for n = nodes
                obj.Dag = addToGraph(n, obj.Dag);
            end
            % obj.drawGraph(dag);
        end
        
        function train(obj, data)
            data_t = transpose(data);
            cases = num2cell(data_t);
            dag = zeros(obj.NumberOfNodes, obj.NumberOfNodes);
            node_sizes = ones(1,obj.NumberOfNodes);
            discrete_nodes = getLabelsIndex(obj.ColumnsHandler);
            node_sizes(discrete_nodes) = 2;            
            bnet = mk_bnet(dag, node_sizes, 'discrete', discrete_nodes, 'observed', getFeaturesIndex(obj.ColumnsHandler));
            engine = jtree_inf_engine(bnet);
            max_iter = 10;
            [educated_bnet, ~] = learn_params_em(engine, cases, max_iter);
            obj.Engine = jtree_inf_engine(educated_bnet);
            
        end
        
        function predictions = predict(obj, data)
            [educated_engine, ~] = enter_evidence(obj.Engine, data);
            predictions = marginal_nodes(educated_engine, 227:277);
        end
        
        function drawGraph(obj, dag)
            n = 278;
            G = digraph(dag);
            remove_nodes = setdiff(1:n, obj.FeatureIds);
            remove_nodes = setdiff(remove_nodes, obj.LabelId);
            G = rmnode(G, remove_nodes);
            h = plot(G,'Layout','force');
            labelnode(h, 1:length(obj.FeatureNames), convertContainedStringsToChars(obj.FeatureNames));
            labelnode(h, length(obj.FeatureNames) + 1, convertContainedStringsToChars(obj.LabelName));
        end
    end
end

