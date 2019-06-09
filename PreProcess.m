classdef PreProcess
    properties

    end
    
    methods
        function obj = PreProcess()
        end
        
        function [timestamps, features, labels] = extractData(~, userSensorData)
            timestamps = userSensorData(:, 1);
            features = userSensorData(:, 2:226);
            labels = userSensorData(:, 227:277);
        end
    end
end

