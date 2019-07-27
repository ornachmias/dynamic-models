classdef LabelGraphNode
    properties
        LabelNames
        FeatureNames
        Evidences
    end
    
    methods
        function obj = LabelGraphNode(labelNames, featureNames)
            obj.LabelNames = labelNames;
            obj.FeatureNames = featureNames;
        end
        
        function labelNames = get.LabelNames(obj)
            labelNames = obj.LabelNames;
        end
        
        function featureNames = get.FeatureNames(obj)
            featureNames = obj.FeatureNames;
        end
        
        function [labelIds, featureIds, updatedDag] = addToGraph(obj, dag, columnsHandler)
            labelIds = GetColumnsIndex(columnsHandler, obj.LabelNames);
            featureIds = GetColumnsIndex(columnsHandler, obj.FeatureNames);
            dag(labelIds, featureIds) = 1;
            updatedDag = dag;
        end
    end
end

