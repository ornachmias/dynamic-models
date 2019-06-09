classdef GraphNode
    properties
        LabelName
        LabelId
        FeatureNames
        FeatureIds
    end
    
    methods
        function obj = GraphNode(featureNames, labelNames, columnsHandler)
            obj.LabelName = labelNames;
            obj.LabelId = GetColumnsIndex(columnsHandler, labelNames);
            obj.FeatureNames = featureNames;
            obj.FeatureIds = GetColumnsIndex(columnsHandler, featureNames);
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

