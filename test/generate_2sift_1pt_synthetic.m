function [data, R_gt, cay_gt, t_gt] = generate_2sift_1pt_synthetic()

% Reference:
% [1] S. Liwicki and C. Zach. Scale Exploiting Minimal Solvers
%     for Relative Pose with Calibrated Cameras. BMVC, 2017.
% Author: Ji Zhao
% Email: zhaoji84@gmail.com
% 04/09/2021

% Ground truth pose
cay_gt = randn(3,1);
q_gt = [1; cay_gt];
R_gt = quat2rot(normc(q_gt));
t_gt = randn(3,1);

% setup some 3D points
X = randn(3,3);

% project in first image
x1 = X./X([3;3;3],:);

% Change coordinate system to second camera
RX = R_gt*X + repmat(t_gt,[1 size(X,2)]);

% and reproject
x2 = RX./RX([3;3;3],:);

% distance ratio
% Note: We exploit sphere camera model, so the distances and their ratios
% can be negative.
r = X(3,:)./RX(3,:);

%%
%data = [x1(1:2,1), x1(1:2,2), x1(1:2,3), ...
%        x2(1:2,1), x2(1:2,2), x2(1:2,3)];
%data = [data(:); r(1); r(2)];

data = [x1(1:2,1); x2(1:2,1); r(1); ...
        x1(1:2,2); x2(1:2,2); r(2); ...
        x1(1:2,3); x2(1:2,3)];

