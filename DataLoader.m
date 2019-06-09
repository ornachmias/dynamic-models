classdef DataLoader
    properties
        RootPath
    end
    
    methods
        function obj = DataLoader()
            obj.RootPath = './data';
        end
        
        function [sensorsData, validationData] = loadData(obj)
            validationData = loadValidationData(obj);
            sensorsData = loadSensorsData(obj);
        end
        
        function sensorsData = loadSingleSensorsData(obj, userId)
            sensorsDataDir = fullfile(obj.RootPath, 'SensorData');
            zipFilePath = fullfile(sensorsDataDir, strcat(userId, '.features_labels.csv.gz'));
            dataFilePath = erase(zipFilePath, '.gz');
            if ~exist(dataFilePath, 'file')
                gunzip(zipFilePath);
            end

            sensorsData = csvread(string(dataFilePath), 1, 0);
        end
        
        function sensorsData = loadSensorsData(obj)
            sensorsData = containers.Map;
            sensorsDataDir = fullfile(obj.RootPath, 'SensorData');
            if ~exist(sensorsDataDir, 'dir')
                sensorsDataZip = fullfile(obj.RootPath, 'ExtraSensory.per_uuid_features_labels.zip');
                unzip(sensorsDataZip, fullfile(obj.RootPath, 'SensorData'));
            end
            
            files = dir(fullfile(sensorsDataDir, '*.gz'));
            for i = 1:length(files)
                zipFilePath = fullfile(sensorsDataDir, files(i).name);
                dataFilePath = erase(zipFilePath, '.gz');
                userId = erase(erase(dataFilePath, '.\data\SensorData\'), '.features_labels.csv');
                if ~exist(dataFilePath, 'file')
                    gunzip(zipFilePath);
                end

                data = csvread(string(dataFilePath), 1, 0);
                sensorsData(userId) = data;
            end
        end
        
        function validationData = loadValidationData(obj)
            validationData = containers.Map;
            validationDataDir = fullfile(obj.RootPath, 'cv_5_folds');
            if ~exist(validationDataDir, 'dir')
                validationDataZip = fullfile(obj.RootPath, 'cv5Folds.zip');
                unzip(validationDataZip, obj.RootPath);
            end
            
            for i = 0:4
                filename = strcat('fold_', num2str(i), '_test_android_uuids.txt');
                path = fullfile(validationDataDir, filename);
                fileId = fopen(path);
                contentAndroidTest = textscan(fileId, '%s');
                fclose(fileId);
                
                filename = strcat('fold_', num2str(i), '_test_iphone_uuids.txt');
                path = fullfile(validationDataDir, filename);
                fileId = fopen(path);
                contentIphoneTest = textscan(fileId, "%s");
                fclose(fileId);
                
                filename = strcat('fold_', num2str(i), '_train_android_uuids.txt');
                path = fullfile(validationDataDir, filename);
                fileId = fopen(path);
                contentAndroidTrain = textscan(fileId, "%s");
                fclose(fileId);
                
                filename = strcat('fold_', num2str(i), '_train_iphone_uuids.txt');
                path = fullfile(validationDataDir, filename);
                fileId = fopen(path);
                contentIphoneTrain = textscan(fileId, "%s");
                fclose(fileId);
                
                validationData(char(i)) = struct('train', [contentAndroidTrain, contentIphoneTrain], ...
                    'test', [contentAndroidTest, contentIphoneTest]);
            end
        end
    end
end

