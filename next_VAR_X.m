function VAR_X = next_VAR_X(x, P, P_sum,E_X)

global N M dim;

deviations = zeros(2, M, N);

for i=1:M
    deviations(:, i, :) = x - E_X(:, i);
end

P = reshape(P, [1 size(P)]);

square_deviations = zeros(dim, dim, N, M);

for i=1:M
    square_deviations(:, :, :, i) = reshape( reshape(deviations(:, i, :), [dim, N]),[1,dim,N]) .* reshape( reshape(deviations(:, i, :), [dim, N]),[dim,1,N]);
end

VAR_X = zeros(dim, dim, M);

for i=1:M
    VAR_X(:, :, i) = sum(P(:, i, :) .* square_deviations(:, :, :, i), 3) / P_sum(i);
end

function result = row_product(a)
    result = a*a';
end
end

