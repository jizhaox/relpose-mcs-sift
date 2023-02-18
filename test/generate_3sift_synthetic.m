function [data, R_gt, cay_gt, t_gt] = generate_3sift_synthetic(match_type)

% Reference:
% [1] Banglei Guan, and Ji Zhao. Relative Pose Estimation for
%     Multi-Camera Systems from Point Correspondences with Scale Ratio. 
%     ACM Multimedia, 2022
% Author: Ji Zhao
% Email: zhaoji84@gmail.com
% 11/13/2021

if nargin<1
    match_type = 1;
end

%% four types of correspondence
match_info = match_type_gcam_sift(match_type);

n_cam = 2;
n_point = 3;

%% define random extrinsic parameters
cam_body_rotation = cell(n_cam, 1);
cam_body_offset = cell(n_cam, 1);
R_cam = cell(n_cam, 1);
t_cam = cell(n_cam, 1);
T_body_cam = cell(n_cam, 1);
for ii = 1:n_cam
    cay = rand(3, 1);
    cam_body_rotation{ii} = cayley2rot(cay);
    cam_body_offset{ii} = rand(3, 1);
    
    R_cam{ii} = cam_body_rotation{ii}';
    t_cam{ii} = -R_cam{ii}*cam_body_offset{ii};
    % transformation from body reference to perspective camera references
    T_body_cam{ii} = [R_cam{ii} t_cam{ii}; 0 0 0 1];
end

%% define relative pose
cay = rand(3, 1);
R_gt = cayley2rot(cay);
q = rotm2quat(R_gt);
cay_gt = q(2:4)/q(1);
cay_gt = cay_gt(:);

t_gt = rand(3, 1);

% transformation from body reference at time i to time j
T_gt = [R_gt t_gt; 0 0 0 1];

%% generating random scene points
points_all = cell(n_point, 1);
for ii = 1:n_point
    PT = rand(3, 1);
    points_all{ii} = struct('point', PT);
end

%% Part 2: extract point observations
% images at time i
x_i = cell(n_point, n_cam);
depth_i = cell(n_point, n_cam);
for ii = 1:n_point
    PT = points_all{ii}.point;
    for jj = 1:n_cam
        tmp = R_cam{jj}*PT+t_cam{jj};
        depth_i{ii,jj} = tmp(3);
        x_i{ii,jj} = tmp/tmp(3);
    end
end
% images at time j
Rc_j = cell(n_cam, 1);
tc_j = cell(n_cam, 1);
for ii = 1:n_cam
    tmp = T_body_cam{ii}*T_gt;
    Rc_j{ii} = tmp(1:3,1:3);
    tc_j{ii} = tmp(1:3,4);
end
x_j = cell(n_point, n_cam);
depth_j = cell(n_point, n_cam);
for ii = 1:n_point
    PT = points_all{ii}.point;
    for jj = 1:n_cam
        tmp = Rc_j{jj}*PT+tc_j{jj};
        depth_j{ii,jj} = tmp(3);
        x_j{ii,jj} = tmp/tmp(3);
    end
end

% scale ratio
scale_ratio = cell(n_point, 1);
for i = 1:n_point
    idx1 = match_info{i}.idx1;
    idx2 = match_info{i}.idx2;
    d1 = depth_i{i, idx1};
    d2 = depth_j{i, idx2};
    scale_ratio{i} = d1/d2;
end

%% check
R = R_gt;
Tf1tof2 = t_gt;
err_pc = zeros(n_point, 1);
err_scale = zeros(n_point*3, 1);
A = zeros(4, n_point);
for i = 1:n_point
    idx1 = match_info{i}.idx1;
    idx2 = match_info{i}.idx2;
    x1 = x_i{i, idx1};
    x2 = x_j{i, idx2};
    r = scale_ratio{i};
    
    Q1 = cam_body_rotation{idx1};
    Q2 = cam_body_rotation{idx2};
    s1 = cam_body_offset{idx1};
    s2 = cam_body_offset{idx2};
    
    % form 1
    E_tmp = Q2'*(R*skew(s1) + skew(Tf1tof2)*R - skew(s2)*R)*Q1;
    err_pc(i) = x2'*E_tmp*x1;
    err_scale(i*3-2:i*3) = cross(x2, Q2'*(R*s1 + Tf1tof2 - s2)) - Q2'*R*cross(r*Q1*x1, s1) - Q2'*cross(r*R*Q1*x1, Tf1tof2-s2);
    % form 2
    A(:,i) = [-cross(Q2*x2, R*Q1*x1); x2'*Q2'*(R*skew(s1)-skew(s2)*R)*Q1*x1];
end
A = A';
err_pc2 = A*[t_gt;1];

%% generate data
data = [cam_body_rotation{1}(:); cam_body_offset{1}(:);
         cam_body_rotation{2}(:); cam_body_offset{2}(:)];

for i = 1:n_point
    idx1 = match_info{i}.idx1;
    idx2 = match_info{i}.idx2;
    x1 = x_i{i, idx1};
    x2 = x_j{i, idx2};
    r = scale_ratio{i};
    
    d = [x1(1:2); x2(1:2); r];
    data = [data; d(:)];
end
data = data(:);
