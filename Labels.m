classdef Labels
    properties
        labels = ["label:LYING_DOWN", ...
        "label:SITTING", ...
        "label:FIX_walking", ...
        "label:FIX_running", ...
        "label:BICYCLING", ...
        "label:SLEEPING", ...
        "label:LAB_WORK", ...
        "label:IN_CLASS", ...
        "label:IN_A_MEETING", ...
        "label:LOC_main_workplace", ...
        "label:OR_indoors", ...
        "label:OR_outside", ...
        "label:IN_A_CAR", ...
        "label:ON_A_BUS", ...
        "label:DRIVE_-_I_M_THE_DRIVER", ...
        "label:DRIVE_-_I_M_A_PASSENGER", ...
        "label:LOC_home", ...
        "label:FIX_restaurant", ...
        "label:PHONE_IN_POCKET", ...
        "label:OR_exercise", ...
        "label:COOKING", ...
        "label:SHOPPING", ...
        "label:STROLLING", ...
        "label:DRINKING__ALCOHOL_", ...
        "label:BATHING_-_SHOWER", ...
        "label:CLEANING", ...
        "label:DOING_LAUNDRY", ...
        "label:WASHING_DISHES", ...
        "label:WATCHING_TV", ...
        "label:SURFING_THE_INTERNET", ...
        "label:AT_A_PARTY", ...
        "label:AT_A_BAR", ...
        "label:LOC_beach", ...
        "label:SINGING", ...
        "label:TALKING", ...
        "label:COMPUTER_WORK", ...
        "label:EATING", ...
        "label:TOILET", ...
        "label:GROOMING", ...
        "label:DRESSING", ...
        "label:AT_THE_GYM", ...
        "label:STAIRS_-_GOING_UP", ...
        "label:STAIRS_-_GOING_DOWN", ...
        "label:ELEVATOR", ...
        "label:OR_standing", ...
        "label:AT_SCHOOL", ...
        "label:PHONE_IN_HAND", ...
        "label:PHONE_IN_BAG", ...
        "label:PHONE_ON_TABLE", ...
        "label:WITH_CO-WORKERS", ...
        "label:WITH_FRIENDS"];
    end
    
    methods
        function labelDescription = getLabelsDescription(obj, labelIndex)
            labelDescription = obj.labels(labelIndex);
        end

        function labelsIndex = getLabelsIndex(obj, labelDescriptions)
            [~, labelsIndex] = intersect(obj.labels, labelDescriptions, "stable");
        end
    end

end