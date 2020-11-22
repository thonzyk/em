function lambda_delta = get_lambda_delta(W, E_X, VAR_X, W_2, E_X_2, VAR_X_2)

Wd = abs(W - W_2);
E_Xd = abs(E_X - E_X_2);
VAR_Xd = abs(VAR_X - VAR_X_2);

lambda_delta = sum(Wd) + sum(E_Xd, 'all') + sum(VAR_Xd, 'all');
end

