classdef PreProcess
    properties
        ColumnsHandler
    end
    
    methods
        function obj = PreProcess(columnsHandler)
            obj.ColumnsHandler = columnsHandler;
        end
        
        function processedData = runPreprocess(obj, userSensorData)
            processedData = obj.removeNanValues(userSensorData);
            processedData = obj.normalizeValues(processedData);
        end
        
        function newUserSensorData = removeNanValues(obj, userSensorData)
            newUserSensorData = userSensorData;
            m = nanmean(userSensorData);
            for i = 1:size(userSensorData, 1)
                for j = 1:size(userSensorData, 2)
                    if (isnan(userSensorData(i, j)))
                        newUserSensorData(i, j) = m(j);
                    end
                end
            end
        end
        
        function newUserSensorData = normalizeValues(obj, userSensorData)
            idx = isfinite(userSensorData);
            Amax = max(userSensorData(idx));
            Amin = min(userSensorData(idx));
            newUserSensorData = (userSensorData-Amin) / (Amax-Amin);
        end
    end
end

