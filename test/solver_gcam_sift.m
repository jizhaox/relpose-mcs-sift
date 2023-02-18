function [qt_sols, R_sols] = solver_gcam_sift(data, match_type)

switch match_type
    case 1
        sols = solver_gcam_sift_3inter(data);
    case 2
        sols = solver_gcam_sift_3intra(data);
        
    case 3
        sols = solver_gcam_sift_2inter_1intra(data);
    case 4
        sols = solver_gcam_sift_1inter_2intra(data);
    otherwise
        error('match type error!');
end
[real_sols,R_sols] = post_process_rotation(sols);
qt_sols = calculate_translation(data, match_type, real_sols);

function [real_sols, R_sols] = post_process_rotation(sols)
thresh = 1e-12;
idx = max(abs(imag(sols(1:4,:))), [], 1) < thresh;
real_sols = real(sols(:, idx));
n_sol = size(real_sols, 2);
R_sols = zeros(3,3,n_sol);
for ii =  1:n_sol
    q = real_sols(1:4, ii);
    q = normc(q);
    real_sols(1:4, ii) = q;
    R_sols(:,:,ii) = quat2rot(q([4, 1:3]));
end

function qt_sols = calculate_translation(data, match_type, real_sols)
qt_sols = real_sols;

cam2f_rotation = cell(2, 1);
cam2f_rotation{1} = reshape(data(1:9), [3,3]);
cam2f_rotation{2} = reshape(data(13:21), [3,3]);
cam2f_offset = cell(2, 1);
cam2f_offset{1} = data(10:12);
cam2f_offset{2} = data(22:24);

Img1 = [data(25:26), data(30:31), data(35:36)];
Img2 = [data(27:28), data(32:33), data(37:38)];
r_arr = [data(29), data(34), data(39)];
match_info = match_type_gcam_sift(match_type);

n = 3;
for ii = 1:size(real_sols, 2)
    q = real_sols(1:4, ii);
    R = quat2rot(q([4, 1:3]));
    
    A = zeros(n, 4);
    for k = 1:n
        x1 = [Img1(1:2,k);1];
        x2 = [Img2(1:2,k);1];

        idx1 = match_info{k}.idx1;
        idx2 = match_info{k}.idx2;

        Q1 = cam2f_rotation{idx1};
        Q2 = cam2f_rotation{idx2};
        s1 = cam2f_offset{idx1};
        s2 = cam2f_offset{idx2};
        
        A(k, :) = [-cross(Q2*x2, R*Q1*x1); x2'*Q2'*(R*skew(s1)-skew(s2)*R)*Q1*x1];
    end
    t = null(A);
    qt_sols(5:7, ii) = t(1:3)/t(4);
end
