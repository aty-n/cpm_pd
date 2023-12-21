%% this code calculates a combined p-value based on fisher's method

% calculate combined x^2
X_squared = -2 * sum(log([pval_pos, pval_neg]));

% calculate combined p-value
degrees_of_freedom = 2 * length([pval_pos, pval_neg]);
combined_p_value = 1 - chi2cdf(X_squared, degrees_of_freedom);

disp(['Combined p-value: ', num2str(combined_p_value)]);
