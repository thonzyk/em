function VAR_X = next_VAR_X(x, P, P_sum,E_X)

global use_gpu N M dim;

deviations = zeros(2, M, N);

for i=1:M
    deviations(:, i, :) = x - E_X(:, i);
end

disp('num2cell')
tic
deviations = num2cell(deviations, 1);
toc

square_deviations = zeros(dim, dim, N, M);


tic
for i=1:M
   square_deviations(:, :, :, i) =  cell2mat( cellfun(@row_product, deviations(:, i, :), 'UniformOutput', false) );
end
toc

P = reshape(P, [1 size(P)]);

VAR_X = zeros(dim, dim, M);

for i=1:M
    VAR_X(:, :, i) = sum( times( P(:, i, :), square_deviations(:, :, :, i)) , 3) / P_sum(i);
end


function result = row_product(a)
    result = a*a';
end
end

