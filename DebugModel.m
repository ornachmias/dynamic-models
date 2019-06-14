classdef DebugModel
    properties
        Dag
        ColumnsHandler
        Engine
        NumberOfNodes
    end
    
    methods
        function obj = DebugModel(columnsHandler)
            obj.ColumnsHandler = columnsHandler;
            obj.NumberOfNodes = getTotalSize(columnsHandler);
            obj.Dag = zeros(obj.NumberOfNodes, obj.NumberOfNodes);
        end
        
        function dag = loadNodes(obj, nodes)
            for n = nodes
                obj.Dag = addToGraph(n, obj.Dag);
            end
            
            dag = obj.Dag;
        end
        
        function bnet = createBnet(obj)
            ns = ones(1, obj.NumberOfNodes);
            dag = zeros(obj.NumberOfNodes, obj.NumberOfNodes);
            nodes = createNodes();
            obj.Dag = obj.loadNodes(nodes);

            bnet = mk_bnet(dag, ns, 'discrete', [], 'observed', getLabelsIndex(obj.ColumnsHandler));

            for i=1:obj.NumberOfNodes
                bnet.CPD{i} = gaussian_CPD(bnet, i);
            end
            
            obj.drawGraph(obj.Dag);
        end

        
        function drawGraph(obj, dag)
            G = digraph(dag);
            h = plot(G,'Layout','force');
            labelnode(h, 1:obj.NumberOfNodes, convertContainedStringsToChars(obj.ColumnsHandler.Columns));
        end
    end
end

