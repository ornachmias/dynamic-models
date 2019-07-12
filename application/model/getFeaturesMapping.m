function featuresMapping = getFeaturesMapping()
% Based on the features recommendation in FeatureSelection
featuresMapping = containers.Map;
featuresMapping("label:LYING_DOWN") = ...
    ["discrete:time_of_day", ...
    "discrete:battery_plugged", ...
    "audio_naive:mfcc1:mean", ...
    "lf_measurements:light", ...
    "audio_naive:mfcc6:mean", ...
    "raw_acc:3d:std_x", ...
    "audio_naive:mfcc12:mean"];

featuresMapping("label:SITTING") = ...
    ["discrete:time_of_day", ...
    "lf_measurements:light", ...
    "audio_naive:mfcc1:mean", ...
    "discrete:battery_plugged", ...
    "proc_gyro:3d:std_y"];

featuresMapping("label:FIX_walking") = ...
    ["proc_gyro:3d:std_x", ...
    "discrete:battery_plugged", ...
    "discrete:wifi_status", ...
    "raw_acc:3d:mean_y", ...
    "audio_properties:max_abs_value", ...
    "raw_acc:3d:mean_z"];

featuresMapping("label:FIX_running") = ...
    ["proc_gyro:3d:std_y", ...
    "raw_magnet:3d:mean_z", ...
    "audio_properties:max_abs_value", ...
    "discrete:battery_plugged", ...
    "raw_magnet:3d:std_x"];

featuresMapping("label:BICYCLING") = ...
    ["watch_acceleration:3d:std_z", ...
    "location:log_longitude_range", ...
    "raw_acc:3d:std_y", ...
    "audio_naive:mfcc5:mean", ...
    "discrete:wifi_status", ...
    "raw_acc:3d:mean_z", ...
    "audio_properties:max_abs_value", ...
    "discrete:battery_plugged"];

featuresMapping("label:SLEEPING") = ...
    ["discrete:time_of_day", ...
    "discrete:battery_plugged", ...
    "lf_measurements:light", ...
    "audio_properties:max_abs_value", ...
    "audio_naive:mfcc12:mean", ...
    "raw_acc:3d:std_x", ...
    "audio_naive:mfcc6:mean", ...
    "lf_measurements:pressure"];

featuresMapping("label:PHONE_ON_TABLE") = ...
    ["audio_naive:mfcc5:std", ...
    "audio_naive:mfcc12:mean", ...
    "audio_naive:mfcc9:mean", ...
    "raw_magnet:3d:mean_x", ...
    "watch_heading:std_cos", ...
    "raw_acc:3d:ro_xz", ...
    "lf_measurements:battery_level", ...
    "raw_acc:3d:mean_y", ...
    "location:max_speed"];

featuresMapping("label:LOC_home") = ...
    ["raw_acc:3d:std_x", ...
    "discrete:battery_plugged", ...
    "raw_magnet:3d:std_x", ...
    "discrete:wifi_status", ...
    "audio_naive:mfcc1:mean", ...
    "raw_magnet:3d:mean_z", ...
    "raw_acc:3d:mean_y"];

featuresMapping("label:IN_A_MEETING") = ...
    ["audio_naive:mfcc1:mean", ...
    "lf_measurements:proximity_cm", ...
    "raw_acc:3d:mean_y", ...
    "audio_naive:mfcc9:mean", ...
    "audio_naive:mfcc9:std", ...
    "discrete:wifi_status", ...
    "location:max_speed", ...
    "raw_acc:3d:std_x", ...
    "raw_magnet:3d:mean_x"];

featuresMapping("label:WITH_FRIENDS") = ...
    ["audio_naive:mfcc3:std", ...
    "raw_magnet:3d:mean_z", ...
    "audio_naive:mfcc12:mean", ...
    "raw_acc:3d:std_x", ...
    "raw_acc:3d:mean_z", ...
    "lf_measurements:pressure", ...
    "raw_magnet:3d:ro_xz", ...
    "discrete:ringer_mode"];

featuresMapping("label:EATING") = ...
    ["discrete:time_of_day", ...
    "location:min_speed", ...
    "lf_measurements:proximity_cm", ...
    "lf_measurements:light", ...
    "raw_magnet:3d:ro_yz", ...
    "audio_naive:mfcc0:std", ...
    "lf_measurements:temperature_ambient", ...
    "raw_magnet:3d:ro_xy"];

featuresMapping("label:SURFING_THE_INTERNET") = ...
    ["audio_naive:mfcc11:std", ...
    "lf_measurements:relative_humidity", ...
    "audio_naive:mfcc7:mean", ...
    "audio_naive:mfcc3:mean", ...
    "lf_measurements:battery_level", ...
    "audio_naive:mfcc12:mean", ...
    "lf_measurements:pressure", ...
    "lf_measurements:light", ...
    "audio_naive:mfcc1:mean"];

featuresMapping("label:OR_outside") = ...
    ["raw_acc:3d:std_x", ...
    "discrete:battery_plugged", ...
    "lf_measurements:temperature_ambient", ...
    "discrete:wifi_status", ...
    "raw_acc:3d:mean_z", ...
    "audio_naive:mfcc1:mean", ...
    "discrete:time_of_day"];

featuresMapping("label:IN_A_CAR") = ...
    ["audio_naive:mfcc6:std", ...
    "audio_naive:mfcc1:mean", ...
    "proc_gyro:3d:std_x", ...
    "discrete:wifi_status", ...
    "audio_naive:mfcc7:mean", ...
    "raw_magnet:3d:mean_x", ...
    "lf_measurements:battery_level", ...
    "raw_acc:3d:mean_z"];

end
