function [P, p_sum] = get_P_matrix(x, W, E_X, VAR_X)

p = zeros(size(E_X, 2), size(x, 2));

for i=1:size(E_X, 2)
    p(i, :) = mvnpdf(x', E_X(:, i)', VAR_X(:, :, i)');
end

p = p .* W;

p_sum = sum(p, 1);

P = p ./ p_sum;
end

