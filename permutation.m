
% adapted from
% Shen, X., Finn, E., Scheinost, D. et al. 
% Using connectome-based predictive modeling to predict individual behavior from brain connectivity. 
% Nat Protoc 12, 506–518 (2017). https://doi.org/10.1038/nprot.2016.178
% be sure to cite them if you use this script

% ------------ INPUTS -------------------

all_mats  = x;
all_behav = y;

thresh = 0.0004;

no_sub = size(all_mats,3);

% calculate the true prediction correlation
[true_prediction_R_pos, true_prediction_R_neg] = cpm_func(all_mats, all_behav, yoe, thresh);

% number of iterations for permutation testing
no_iterations   = 10001;
prediction_r    = zeros(no_iterations,2);
prediction_r(1,1) = true_prediction_R_pos;
prediction_r(1,2) = true_prediction_R_neg;

% create estimate distribution of the test statistic
% via random shuffles of data lables   
for it=2:no_iterations
    fprintf('\n Performing iteration %d out of %d', it, no_iterations);
    new_behav        = all_behav(randperm(no_sub));
    [prediction_r(it,1), prediction_r(it,2)] = cpm_func(all_mats, new_behav, yoe, thresh);    
end

sorted_prediction_R_pos = sort(prediction_r(:,1),'descend');
position_pos            = find(sorted_prediction_R_pos==true_prediction_R_pos);
pval_pos                = position_pos(1)/no_iterations

sorted_prediction_R_neg = sort(prediction_r(:,2),'descend');
position_neg            = find(sorted_prediction_R_neg==true_prediction_R_neg);
pval_neg                = position_neg(1)/no_iterations
