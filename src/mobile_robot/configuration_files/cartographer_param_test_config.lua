-- Copyright 2018 The Cartographer Authors
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

include "map_builder.lua"
include "trajectory_builder.lua"

options = {
  map_builder = MAP_BUILDER,
  trajectory_builder = TRAJECTORY_BUILDER,
  map_frame = "map",
  tracking_frame = "imu_link",
  published_frame = "base_link",
  odom_frame = "odom",
  provide_odom_frame = true,
  publish_frame_projected_to_2d = true,
  publish_tracked_pose = true,
  use_odometry = true,
  use_pose_extrapolator = true,
  use_nav_sat = false,
  use_landmarks = false,
  num_laser_scans = 2,
  num_multi_echo_laser_scans = 0,
  num_subdivisions_per_laser_scan = 1,
  num_point_clouds = 0,
  lookup_transform_timeout_sec = 0.2,
  submap_publish_period_sec = 0.3,
  pose_publish_period_sec = 5e-3,
  trajectory_publish_period_sec = 30e-3,
  rangefinder_sampling_ratio = 1.,
  odometry_sampling_ratio = 1.,
  fixed_frame_pose_sampling_ratio = 1.,
  imu_sampling_ratio = 1.,
  landmarks_sampling_ratio = 1.,
}

MAP_BUILDER.use_trajectory_builder_2d = true
TRAJECTORY_BUILDER.collate_landmarks = false
TRAJECTORY_BUILDER_2D.num_accumulated_range_data = 2
TRAJECTORY_BUILDER_2D.use_imu_data = true
TRAJECTORY_BUILDER_2D.submaps.num_range_data = 45

-- more points  
TRAJECTORY_BUILDER_2D.adaptive_voxel_filter.max_length = 0.6
TRAJECTORY_BUILDER_2D.adaptive_voxel_filter.min_num_points = 150
-- slightly slower insertion
TRAJECTORY_BUILDER_2D.submaps.range_data_inserter.probability_grid_range_data_inserter.hit_probability = 0.53
TRAJECTORY_BUILDER_2D.submaps.range_data_inserter.probability_grid_range_data_inserter.miss_probability = 0.493
-- slightly shorter rays
TRAJECTORY_BUILDER_2D.max_range = 2.
-- wheel odometry is fine
TRAJECTORY_BUILDER_2D.ceres_scan_matcher.translation_weight = 50
-- IMU is ok
TRAJECTORY_BUILDER_2D.ceres_scan_matcher.rotation_weight = 20

-- less outliers
POSE_GRAPH.constraint_builder.max_constraint_distance = 10.
POSE_GRAPH.constraint_builder.min_score = 0.55
-- tune down IMU in optimization
POSE_GRAPH.optimization_problem.acceleration_weight = 0.1 * 1e3
POSE_GRAPH.optimization_problem.rotation_weight = 0.1 * 3e5
-- ignore wheels in optimization
POSE_GRAPH.optimization_problem.odometry_translation_weight = 1e5
POSE_GRAPH.optimization_problem.odometry_rotation_weight = 1e5
POSE_GRAPH.optimization_problem.log_solver_summary = true

POSE_GRAPH.constraint_builder.sampling_ratio = 0.1 --0.3
POSE_GRAPH.global_sampling_ratio = 0.01--0.003
POSE_GRAPH.global_constraint_search_after_n_seconds = 15. --10

TRAJECTORY_BUILDER.pure_localization_trimmer = {
  max_submaps_to_keep = 3
}

POSE_GRAPH.optimize_every_n_nodes = 20

POSE_GRAPH.constraint_builder.global_localization_min_score = 0.6

-- For Test

-- 60<= good match max 70~75
-- 55 default( <=55 : outliers)
-- POSE_GRAPH.constraint_builder.min_score = 0.01
-- POSE_GRAPH.constraint_builder.loop_closure_translation_weight = 1
-- POSE_GRAPH.constraint_builder.loop_closure_rotation_weight = 100000

-- a lot impact on computation load -> mapping quality lower
-- POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher.linear_search_window = 30.
-- POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher.angular_search_window = math.rad(60.)

-- constraint building time consuming high -> data squeeze not online
-- POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher.branch_and_bound_depth = 15

-- POSE_GRAPH.constraint_builder.ceres_scan_matcher.translation_weight = 10.
-- POSE_GRAPH.constraint_builder.ceres_scan_matcher.rotation_weight = 1.
-- POSE_GRAPH.matcher_rotation_weight = 5e10
-- POSE_GRAPH.matcher_rotation_weight = 1.6e10

-- not big impact on mapping that much, correlated min_score and can control with it / bigger scale -> bigger outlier impact
-- POSE_GRAPH.optimization_problem.huber_scale = 1e10 

-- POSE_GRAPH.optimization_problem.local_slam_pose_translation_weight = 1e10
-- POSE_GRAPH.optimization_problem.local_slam_pose_rotation_weight = 1e10
-- POSE_GRAPH.optimization_problem.odometry_translation_weight = 1e15
-- POSE_GRAPH.optimization_problem.odometry_rotation_weight = 1e15



-- Done

-- more greater impact on map building speed than accruacy of map. 
-- computatation lower, speed of map building high, accruacy of map slightly and slowly lower
-- TRAJECTORY_BUILDER_2D.voxel_filter_size = 0.025

-- adaptive : for global SLAM (local SLAM -> Only use static voxel filter)
-- great impact on computational load and points what we handle for global SLAM
-- TRAJECTORY_BUILDER_2D.adaptive_voxel_filter.max_length = 0.5
-- TRAJECTORY_BUILDER_2D.adaptive_voxel_filter.min_num_points = 200
-- TRAJECTORY_BUILDER_2D.adaptive_voxel_filter.max_range = 50.

-- deprecated
-- TRAJECTORY_BUILDER_2D.loop_closure_adaptive_voxel_filter.max_length = 0.9
-- TRAJECTORY_BUILDER_2D.loop_closure_adaptive_voxel_filter.min_num_points = 100
-- TRAJECTORY_BUILDER_2D.loop_closure_adaptive_voxel_filter.max_range = 50.

-- how fast we insert points in submap(similar pointclouds -> discard)
-- default setting : angle sensitive : little angle change -> through filter(motion detected)
-- TRAJECTORY_BUILDER_2D.motion_filter.max_time_seconds = 5.
-- TRAJECTORY_BUILDER_2D.motion_filter.max_distance_meters = 0.2
-- TRAJECTORY_BUILDER_2D.motion_filter.max_angle_radians = math.rad(1.)

---

-- TRAJECTORY_BUILDER_2D.ceres_scan_matcher.translation_weight = 10
-- TRAJECTORY_BUILDER_2D.ceres_scan_matcher.rotation_weight = 40

TRAJECTORY_BUILDER.pure_localization_trimmer = {
    max_submaps_to_keep = 3
}

-- POSE_GRAPH.overlapping_submaps_trimmer_2d = {
--     -- allowable submaps count per cell to keep(only the freshest submaps alive)
--     fresh_submaps_count = 1,
--     -- min_covered_cells_count = min_covered_area / resolution*resolution
--     -- chosen submaps count cell by cell -> kept, else -> discarded(less than min_covered_cells_count)
--     min_covered_area = 5,
--     -- trimmer threshold( trimmer will be running if the number of new created submaps is over min_added_submaps_count )
--     min_added_submaps_count = 1,
-- }

return options

