% adapted from
% Shen, X., Finn, E., Scheinost, D. et al. 
% Using connectome-based predictive modeling to predict individual behavior from brain connectivity. 
% Nat Protoc 12, 506–518 (2017). https://doi.org/10.1038/nprot.2016.178
% be sure to cite them if you use this script

function [true_prediction_R_pos, true_prediction_R_neg] = cpm_func(all_mats, all_behav, yoe, thresh);

% ---------------------------------------

no_sub = size(all_mats,3);
no_node = size(all_mats,1);

behav_pred_pos = zeros(no_sub,1);
behav_pred_neg = zeros(no_sub,1);
behav_pred = zeros(no_sub,1);

for leftout = 1:no_sub
%    fprintf('\n Leaving out subj # %6.3f',leftout);
    
    % LOOCV
    
    train_mats = all_mats;
    train_mats(:,:,leftout) = [];
    train_vcts = reshape(train_mats,[],size(train_mats,3));
    
    train_behav = all_behav;
    train_behav(leftout) = [];
    
    yoe_excluded = yoe;
    yoe_excluded(leftout) = [];

    % correlate x with y
    
    % partial correlation
    [r_mat, p_mat] = partialcorr(train_vcts', train_behav, yoe_excluded);
    
    % rank correlation

    % [r_mat,p_mat] = corr(train_vcts',train_behav);
    
    r_mat = reshape(r_mat,no_node,no_node);
    p_mat = reshape(p_mat,no_node,no_node);
    
    % set threshold and define masks
    
    pos_mask = zeros(no_node,no_node);
    neg_mask = zeros(no_node,no_node);
    
    pos_edges = find(r_mat > 0 & p_mat < thresh);
    neg_edges = find(r_mat < 0 & p_mat < thresh);
    
    pos_mask(pos_edges) = 1;
    neg_mask(neg_edges) = 1;
    
    % get sum of all edges in TRAIN subs (divide by 2 to control for the
    % fact that matrices are symmetric)
    
    train_sumpos = zeros(no_sub-1,1);
    train_sumneg = zeros(no_sub-1,1);
    
    for ss = 1:size(train_sumpos);
        train_sumpos(ss) = sum(sum(train_mats(:,:,ss).*pos_mask))/2;
        train_sumneg(ss) = sum(sum(train_mats(:,:,ss).*neg_mask))/2;
    end
    
    % build model on TRAIN subs
    
    fit_pos = polyfit(train_sumpos, train_behav,1);
    fit_neg = polyfit(train_sumneg, train_behav,1);
    
    test_mat = all_mats(:,:,leftout);
    test_sumpos = sum(sum(test_mat.*pos_mask))/2;
    test_sumneg = sum(sum(test_mat.*neg_mask))/2;
    
    % run model on TEST sub (separate)
    
    behav_pred_pos(leftout) = fit_pos(1)*test_sumpos + fit_pos(2);
    behav_pred_neg(leftout) = fit_neg(1)*test_sumneg + fit_neg(2);
    
    b = regress(train_behav, [train_sumpos, train_sumneg, ones(no_sub-1,1)]);

    % run model on TEST sub (combined)

    behav_pred(leftout) = b(1)*test_sumpos + b(2)*test_sumneg + b(3);

end

% compare predicted and observed scores

%[R_pos, P_pos] = corr(behav_pred_pos,all_behav)
%[R_neg, P_neg] = corr(behav_pred_neg,all_behav)
%[R_com, p_com] = corr(behav_pred, all_behav)

%MSE_pos = sum((behav_pred_pos-all_behav).^2)/(no_sub-length(fit_pos)-1)
%MSE_neg = sum((behav_pred_neg-all_behav).^2)/(no_sub-length(fit_neg)-1)
%MSE_com = sum((behav_pred - all_behav).^2)/(no_sub - 3 - 1)

[true_prediction_R_pos, P_pos] = corr(behav_pred_pos,all_behav)
[true_prediction_R_neg, P_neg] = corr(behav_pred_neg,all_behav)
[true_prediction_R, P_com] = corr(behav_pred,all_behav)
