classdef GraphNode
    properties
        LabelNames
        LabelIds
        FeatureNames
        FeatureIds
    end
    
    methods
        function obj = GraphNode(labelNames, featureNames)
            obj.LabelNames = labelNames;
            obj.FeatureNames = featureNames;
        end
        
        function labelNames = get.LabelNames(obj)
            labelNames = obj.LabelNames;
        end
        
        function featureNames = get.FeatureNames(obj)
            featureNames = obj.FeatureNames;
        end
        
        function updatedDag = addToGraph(obj, dag, columnsHandler)
            obj.LabelIds = GetColumnsIndex(columnsHandler, obj.LabelNames);
            obj.FeatureIds = GetColumnsIndex(columnsHandler, obj.FeatureNames);
            dag(obj.LabelIds, obj.FeatureIds) = 1;
            updatedDag = dag;
        end
    end
end

