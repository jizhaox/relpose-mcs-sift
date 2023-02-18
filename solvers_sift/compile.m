
%eigen_dir = 'C:\jizhao\project\Eigen'; 
eigen_dir = '/usr/include/eigen3';

% Relative Pose Estimation for Multi-Camera Systems from Point Correspondences with Scale Ratio
tic; mex(['-I"' eigen_dir '"'],'-O','solver_gcam_sift_1inter_2intra.cpp'); toc
tic; mex(['-I"' eigen_dir '"'],'-O','solver_gcam_sift_2inter_1intra.cpp'); toc
tic; mex(['-I"' eigen_dir '"'],'-O','solver_gcam_sift_3inter.cpp'); toc
tic; mex(['-I"' eigen_dir '"'],'-O','solver_gcam_sift_3intra.cpp'); toc

% Relative Pose Estimation for Single Camera from Point Correspondences with Scale Ratio
tic; mex(['-I"' eigen_dir '"'],'-O','solver_mono_sift.cpp'); toc

