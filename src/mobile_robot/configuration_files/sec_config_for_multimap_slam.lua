include "marker_ids.lua"
include "states.lua"

-- PRIORITY : use multi trajectory > use marker
-- use multi trajectory : multi-map SLAM
-- use marker : intervened relocalization

options = {
    -- intervened relocalization
    marker_ids = MARKER_IDS,
    marker_id = '0',
    relative_to_trajectory_id = '0',
    use_marker = false,
    -- multi-map SLAM
    use_multi_trajectories = true,
    state_filenames = STATE_FILENAMES,
    state_poses = STATE_POSES,
    --- localization score
    use_metrics = true,
    metrics_publish_period_sec = 0.5,
        -- Internal Options
    use_local_slam_score = true,
    use_global_slam_score = true,
    global_max_constraint_distance = 15.0,
    local_slam_score_buffer_size = 20,
    global_slam_score_buffer_size = 10,
}

return options
