%% SETUP
% close all; 
clear; clc;

global use_gpu N M dim;

try
    gpuArray(1);
    use_gpu=true;
catch
    use_gpu=false;
end



load('sp4_data.mat')
X = X';
% X = X(:, 1:1000);


use_gpu = use_gpu && length(X) > 200;


dim = size(X, 1);
M = 3;
N = size(X, 2);

data_mean = mean(X, 2);

% Random initialization
E_X = mvnrnd([1 1], [1 0; 0 1], M)';
VAR_X_k = diag(var(X')');
VAR_X = zeros(dim, dim, M);
for i=1:M
    VAR_X(:, :, i) = VAR_X_k;
end

C = rand(M, 1);
C = C / sum(C);


%%

P_time = 0;

other_time = 0;

for i=1:10
    P = get_P_matrix(X, C, E_X, VAR_X);
    P_sum = sum(P, 2);
    C = P_sum / size(P, 2);
    E_X = next_E_X(X, P, P_sum);
    VAR_X = next_VAR_X(X, P, P_sum, E_X);
end



figure
scatter(X(1,:), X(2, :))
hold on
for i=1:M
    plot_gaussian_ellipsoid(E_X(:, i), VAR_X(:, :, i))
end



