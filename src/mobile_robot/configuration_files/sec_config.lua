include "marker_ids.lua"

options = {
    marker_ids = MARKER_IDS,
    use_metrics = true,
    use_marker = true,
    metrics_publish_period_sec = 0.5,
    marker_id = '0',
    relative_to_trajectory_id = '0',
    -- Internal Options
    use_local_slam_score = true,
    use_global_slam_score = true,
    global_max_constraint_distance = 15.0,
    local_slam_score_buffer_size = 20,
    global_slam_score_buffer_size = 10,
}

return options
