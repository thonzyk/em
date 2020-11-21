function E_X = next_E_X(x, P, P_sum)

global use_gpu N M dim;



E_X = zeros(dim, M);

for i=1:M
    E_X(:, i) = sum(P(i, :) .* x, 2) / P_sum(i);
end


end

