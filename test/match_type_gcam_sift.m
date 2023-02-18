function match_info = match_type_gcam_sift(match_type)

if nargin<1
    match_type = 1;
end

switch match_type
    case 1
        % case 1: inter-camera PCs with scale of 2 cameras
        match_info{1} = struct('idx1', 1, 'idx2', 2);
        match_info{2} = struct('idx1', 1, 'idx2', 2);
        match_info{3} = struct('idx1', 2, 'idx2', 1);
    case 2
        % case 2: intra-camera PCs with scale of 2 cameras
        match_info{1} = struct('idx1', 1, 'idx2', 1);
        match_info{2} = struct('idx1', 1, 'idx2', 1);
        match_info{3} = struct('idx1', 2, 'idx2', 2);
    case 3
        % case 3: two inter-cam and one intra-cam PCs with scale
        match_info{1} = struct('idx1', 1, 'idx2', 2);
        match_info{2} = struct('idx1', 2, 'idx2', 1);
        match_info{3} = struct('idx1', 1, 'idx2', 1);
    case 4
        % case 4: one inter-cam and two intra-cam PCs with scale
        match_info{1} = struct('idx1', 1, 'idx2', 2);
        match_info{2} = struct('idx1', 1, 'idx2', 1);
        match_info{3} = struct('idx1', 2, 'idx2', 2);
%     case 5
%         % case 5: general PCs with scale
%         match_info{1} = struct('idx1', 1, 'idx2', 2);
%         match_info{2} = struct('idx1', 3, 'idx2', 4);
%         match_info{3} = struct('idx1', 5, 'idx2', 6);
    otherwise
        error('match type error!');
end
