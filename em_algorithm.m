function [iterations, loss_fcn, E_Xs, VAR_Xs, Ws, elapsed_time] = em_algorithm(x, stop_change, plot_initial_state)
%% INITIALIZATION

global M dim max_iterations;

% Get data mean and variance
data_mean = mean(x, 2);
DATA_VAR = diag(var(x')');

% Random initialization based on simple data distribution model
E_X = mvnrnd(data_mean, DATA_VAR, M)';
VAR_X = zeros(dim, dim, M);
for i=1:M
    VAR_X(:, :, i) = DATA_VAR;
end

% Completely random initialization of distributions weights
W = rand(M, 1);
W = W / sum(W);

% Metrics initialization
iterations = 1;
loss_last = inf;
loss = 0;
loss_fcn = zeros(1, max_iterations);

% Progress initialization
E_Xs = zeros(size(E_X, 1), size(E_X, 2), max_iterations);
VAR_Xs = zeros(size(VAR_X, 1), size(VAR_X, 2), size(VAR_X, 3), max_iterations);
Ws = zeros(size(W, 1), max_iterations);
E_Xs(:, :, 1) = E_X;
VAR_Xs(:, :, :, 1) = VAR_X;
Ws(:, 1) = W;

%% PLOT INITIAL STATE

elipsoids = zeros(1, M);

if plot_initial_state
    figure
    scatter(x(1,:), x(2, :))
    hold on
    for i=1:M
        % External function implemented by Gautam Vallabha
        elipsoids(i) = plot_gaussian_ellipsoid(E_X(:, i), VAR_X(:, :, i));
    end
    title('\textbf{Po\v cate\v cn\'' i stav}', 'interpreter', 'latex')
    xlabel('$\mathbf{X_1}$', 'interpreter', 'latex')
    ylabel('$\mathbf{X_2}$', 'interpreter', 'latex')
    legend(elipsoids, num2cell([repmat('Gauss ', M, 1), num2str((1:M)'), repmat(' elipsoid', M, 1)], 2))
end

%% ALGORITHM RUN

tic
while iterations < max_iterations && abs(loss_last - loss) > stop_change

    loss_last = loss; % metrics update
    
    % Get conditional probabilities matrices
    [P, p_sum] = get_P_matrix(x, W, E_X, VAR_X);
    
    % Compute loss function
    loss = get_loss(p_sum);
    loss_fcn(iterations) = loss;
    
    % Compute new distribution weights
    P_sum = sum(P, 2);
    W = P_sum / size(P, 2);
    
    % Compute new mean value of each distribution
    E_X = next_E_X(x, P, P_sum);
    
    % Compute new variance of each distribution
    VAR_X = next_VAR_X(x, P, P_sum, E_X);
    
    % Metrics update
    iterations = iterations + 1; 
    E_Xs(:, :, iterations) = E_X;
    VAR_Xs(:, :, :, iterations) = VAR_X;
    Ws(:, iterations) = W;
end
% Measure time
elapsed_time = toc;



% Metrics compression
loss_fcn = loss_fcn(1:iterations-1);
E_Xs = E_Xs(:, :, 1:iterations-1);
VAR_Xs = VAR_Xs(:, :, :, 1:iterations-1);
Ws = Ws(:, 1:iterations-1);

iterations = iterations - 3; % metrics putting into context
end



