function P = get_P_matrix(x, C, E_X, VAR_X)


global use_gpu N M dim;




P = zeros(size(E_X, 2), size(x, 2));


for i=1:size(E_X, 2)
    P(i, :) = mvnpdf(x', E_X(:, i)', VAR_X(:, :, i)');
end

P = P .* C;

p_sum = sum(P, 1);


P = P ./ p_sum;


end

