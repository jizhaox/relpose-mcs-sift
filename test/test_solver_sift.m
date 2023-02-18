% test solvers for monocular cameras and multi-camera systems
% with SIFT features (or other features that provide a scale)

% Reference:
% [1] Banglei Guan, and Ji Zhao. Relative Pose Estimation for
%     Multi-Camera Systems from Point Correspondences with Scale Ratio. 
%     ACM Multimedia, 2022
% [2] S. Liwicki and C. Zach. Scale Exploiting Minimal Solvers
%     for Relative Pose with Calibrated Cameras. BMVC, 2017.
% Author: Ji Zhao
% Email: zhaoji84@gmail.com
% 04/09/2021

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('================== 2SIFT + 1pt for monocular camera ==================');
%% prepare data
[data, R_gt, cay_gt, t_gt] = generate_2sift_1pt_synthetic();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('--------------SIFT method with Cayley--------------');
sols = solver_mono_sift(data);
cay_sol = find_solution_from_complex(sols, cay_gt);
cay_sol, cay_gt

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Relative Pose Estimation for Multi-Camera Systems from Point Correspondences with Scale Ratio
disp('================== 3SIFT for multi-camera systems ==================');
%% generate synthetic data
match_type = 1; % 1,2,3,4
[data, R_gt, cay_gt, t_gt] = generate_3sift_synthetic(match_type);
quat_gt = normc([cay_gt(:); 1]); % scalar-last

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('--------------SIFT method with quaternion--------------');
[qt_sols, R_sols] = solver_gcam_sift(data, match_type);
qt_sols, quat_gt, t_gt
R_sols, R_gt
