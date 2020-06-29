% Calculates Mean Squared error between two vectors
function mse = mse(x, y)
mse = mean((x - y).^2);
end