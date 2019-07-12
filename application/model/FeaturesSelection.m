classdef FeaturesSelection
    properties
        FeaturesHandler
        LabelsHandler
    end
    
    methods
        function obj = FeaturesSelection(featuresHandler, labelsHandler)
            obj.FeaturesHandler = featuresHandler;
            obj.LabelsHandler = labelsHandler;
        end

        function correlation = FeaturesCorrelation(obj, features, showGraph)
            correlation = abs(corrcoef(features, 'rows', 'pairwise'));
            
            if (showGraph == 2)
                figure();
                colormap('hot');
                imagesc(correlation);
                title('Heatmap of correlation between features');
                colorbar;
            end
        end
        
        function correlation = FeaturesLabelsCorrelation(obj, features, labels, showGraph)
            correlation = abs(corrcoef([features labels], 'rows', 'pairwise'));
            labelsRange = size(features, 2) + 1:size(features, 2) + size(labels, 2);
            featuresRange = 1:size(features, 2);
            
            correlation = correlation(labelsRange, featuresRange);
            
            if (showGraph == 2)
                figure();
                colormap('hot');
                imagesc(correlation);
                title('Heatmap of correlation between features and labels');
                colorbar;
            end
        end
        
        function mutualInformation = FeaturesMutualInformation(obj, features, showGraph)
            numberOfFeatures = size(features, 2);
            mutualInformation = zeros(numberOfFeatures, numberOfFeatures);
            
            for i=1:numberOfFeatures
                for j=1:numberOfFeatures
                    mutualInformation(i, j) = mutualinfo(features(:, i), features(:, j));
                end
            end
            
            if (showGraph == 2)
                figure();
                colormap('hot');
                imagesc(mutualInformation);
                title('Heatmap of mutual infromation between features');
                colorbar;
            end
        end
        
        % This method causes the MATLAB to crash, even on a relatively small dataset
        function mutualInformation = FeaturesLabelsMutualInformation(obj, features, labels, showGraph)
            numberOfFeatures = size(features, 2);
            numberOfLabels = size(labels, 2);
            mutualInformation = zeros(numberOfLabels, numberOfFeatures);
            
            for i=1:numberOfLabels
                for j=1:numberOfFeatures
                    mutualInformation(i, j) = mi(labels(:, i), features(:, j));
                end
            end
            
            if (showGraph == 2)
                figure();
                colormap('hot');
                imagesc(mutualInformation);
                title('Heatmap of mutual infromation between features and labels');
                colorbar;
            end
        end
        
        % This method is used to support the decision about the features,
        % but not to automatically select them
        function RecommendFeatures(obj, featuresLabelsCorrelation, featuresCorrelation)
            numberOfFeatures = length(obj.FeaturesHandler.FeatureNames);
            numberOfLabels = length(obj.LabelsHandler.LabelNames);
            
            for i=1:numberOfLabels
                disp(obj.LabelsHandler.LabelNames(i));
                [rankedValues, rankedFeatures] = sort(featuresLabelsCorrelation(i, :), 'descend');
                selectedFeatures = [];
                selectedFeaturesValues = [];
                for j=1:numberOfFeatures
                    currentFeature = rankedFeatures(j);
                    
                    if (~any(featuresCorrelation(selectedFeatures, currentFeature) > 0.3) && ...
                            ~any(isnan(featuresCorrelation(selectedFeatures, currentFeature))) && ...
                            ~all(isnan(featuresCorrelation(currentFeature, :))))
                        selectedFeatures = [selectedFeatures currentFeature];
                        selectedFeaturesValues = [selectedFeaturesValues rankedValues(j)];
                    end
                end
                
                for f=1:length(selectedFeatures)
                    disp(strcat(obj.FeaturesHandler.FeatureNames(selectedFeatures(f)), " - ", num2str(selectedFeaturesValues(f))));
                end
                disp(' ');
            end
        end
        
        function [featureNames, featuresIndex] = GetSelectedFeatures(obj, label)
            mapping = getFeaturesMapping();
            featureNames = mapping(label);
            featuresIndex = obj.FeaturesHandler.GetFeatureIndex(featureNames);
        end
    end
end















