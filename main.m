%% SETUP
close all; 
clear; clc;

global N M dim max_iterations;

% Load data
load('sp4_data.mat')
X = X';

% Data parameters
dim = size(X, 1);
N = size(X, 2);

% Algorithm stop parameters
max_iterations = 300;
stop_change = 1;

%% OPTIONS
run_statistics = true; % Set ´true´ if you want see statistics
M = 3; % Number of Gaussian mixture components

%% ALGORITHM
[iterations, loss_fcn, E_Xs, VAR_Xs, Ws, elapsed_time] = em_algorithm(X, stop_change, true);

%% PLOT


disp(['Number of iterations: ' num2str(iterations)])
disp(['Elapsed time: ' num2str(elapsed_time)])

elipsoids = zeros(1, M);

figure
scatter(X(1,:), X(2, :))
hold on
for i=1:M
    % External function implemented by Gautam Vallabha
    elipsoids(i) = plot_gaussian_ellipsoid(squeeze(E_Xs(:, i, end)), squeeze(VAR_Xs(:, :, i, end)));
end
title('\textbf{Kone\v cn\'' y stav}', 'interpreter', 'latex')
xlabel('$\mathbf{X_1}$', 'interpreter', 'latex')
ylabel('$\mathbf{X_2}$', 'interpreter', 'latex')
legend(elipsoids, num2cell([repmat('Gauss ', M, 1), num2str((1:M)'), repmat(' elipsoid', M, 1)], 2))


figure 
plot(loss_fcn)
title('\textbf{Pr\r ub\v eh kriteri\'' aln\'' i funkce}', 'interpreter', 'latex')
xlabel('\textbf{Iterace}', 'interpreter', 'latex')
ylabel('$\mathbf{Q}$', 'interpreter', 'latex')

%% TABLE RESULTS

if run_statistics
    tables = {};
    for k=1:M
        Iteration = [];
        Weight = [];
        Mean_Value = [];
        Variance = [];
        
        for i=1:length(loss_fcn)
            Iteration = [Iteration; string(num2str(i))];
            Weight = [Weight; string(num2str(Ws(k, i)))];
            Mean_Value = [Mean_Value; string(mat2str(E_Xs(:, k, i)))];
            Variance = [Variance; string(mat2str(VAR_Xs(:, :, k, i)))];
        end
        
        table_name = [num2str(k) '-component table'];
        disp(table_name)
        next_table = table(Iteration, Weight, Mean_Value, Variance);
        writetable(next_table, [table_name '.xls'])
        disp(next_table)
        tables{end + 1} = next_table;
    end
end

%% STATISTICS

if run_statistics
    Ms = 1:20;
    
    iter_statis = zeros(1, length(Ms));
    final_loss_statis = zeros(1, length(Ms));
    elapsed_time_statis = zeros(1, length(Ms));
    
    for M=Ms
        [iterations, loss_fcn, E_Xs, VAR_Xs, Ws, elapsed_time] = em_algorithm(X, stop_change, false);
        iter_statis(M) = iterations;
        final_loss_statis(M) = loss_fcn(end);
        elapsed_time_statis(M) = elapsed_time;
    end
    %% PLOT STATISTICS
    
    figure
    plot(Ms, iter_statis-3)
    title('\textbf{Z\'' avislost po\v ctu iterac\'' i na po\v ctu slo\v zek}', 'interpreter', 'latex')
    xlabel('\textbf{Po\v cet slo\v zek}', 'interpreter', 'latex')
    ylabel('\textbf{Po\v cet iterac\'' i}', 'interpreter', 'latex')
    
    figure
    plot(Ms, final_loss_statis)
    title('\textbf{Z\'' avislost c\'' ilov\'' e hodnoty kriteri\'' aln\'' i funkce na po\v ctu slo\v zek}', 'interpreter', 'latex')
    xlabel('\textbf{Po\v cet slo\v zek}', 'interpreter', 'latex')
    ylabel('$\mathbf{Q_{final}}$', 'interpreter', 'latex')
    
    figure
    plot(Ms, elapsed_time_statis)
    title('\textbf{Z\'' avislost \v casu v\'' ypo\v ctu na po\v ctu slo\v zek}', 'interpreter', 'latex')
    xlabel('\textbf{Po\v cet slo\v zek}', 'interpreter', 'latex')
    ylabel('\textbf{\v Cas v\'' ypo\v ctu [s]}', 'interpreter', 'latex')
    
end
