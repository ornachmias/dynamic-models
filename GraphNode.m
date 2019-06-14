classdef GraphNode
    properties
        LabelName
        LabelIds
        FeatureNames
        FeatureIds
    end
    
    methods
        function obj = GraphNode(labelNames, featureNames, columnsHandler)
            obj.LabelName = labelNames;
            obj.LabelIds = GetColumnsIndex(columnsHandler, labelNames);
            obj.FeatureNames = featureNames;
            obj.FeatureIds = GetColumnsIndex(columnsHandler, featureNames);
        end
        
        function updatedDag = addToGraph(obj,dag)
            dag(obj.FeatureIds, obj.LabelIds) = 1;
            updatedDag = dag;
        end
    end
end

