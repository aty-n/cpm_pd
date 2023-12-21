# pd_cpm

be sure to cite 
Shen, X., Finn, E., Scheinost, D. et al.
Using connectome-based predictive modeling to predict individual behavior from brain connectivity. 
Nat Protoc 12, 506–518 (2017). https://doi.org/10.1038/nprot.2016.178

as this code was adapted and modified from them with great appreciation.

scripts are executed in the following fashion:

1: firstlevel.m: creates first-level connectivity matrices

2: cpm_run.m: model is built and assessed

3: permutation.m: drawing on cpm_func.m, runs prespecified k of permutations

4: com_pval: a combined p-value is calculated from permutation results using fisher's method

5: bioimage suite, https://bioimagesuiteweb.github.io/webapp/connviewer.html#, is used to visualize results

thank you.

atyn
