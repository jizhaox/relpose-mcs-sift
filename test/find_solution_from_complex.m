function sol = find_solution_from_complex(sols, gt, is_sign_ambiguity)

if nargin < 3
    is_sign_ambiguity = false;
end

thresh = 1e-10;

% reject complex-number solution
tmp = max(abs(imag(sols)), [], 1);
idx = find(tmp<thresh);
sols = sols(:, idx);
sols = real(sols);

if is_sign_ambiguity
    if gt(end) < 0
        gt = -gt;
    end
    for ii = 1:size(sols, 2)
        tmp = sols(:, ii);
        if tmp(end) < 0
            sols(:, ii) = -tmp;
        end
    end
end

num_sol = size(sols, 2);
if (num_sol < 1)
    sol = [];
    return;
end
err = sols - repmat(gt(:), [1 num_sol]);
err_s = sum(abs(err), 1);
[~, idx] = min(err_s);
sol = sols(:, idx);
