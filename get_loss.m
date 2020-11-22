function loss = get_loss(p_sum)
loss = sum(log(p_sum), 'all');
end

