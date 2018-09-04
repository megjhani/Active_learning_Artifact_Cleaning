function [ALparam] =  default_params()
addpath('D:\2016\02_MOCAIP\active_learning\sparse_multiclass_logit_code\');
ALparam.sel_stop_cond = 0.01;
ALparam.C = [0.8];
% ALparam.C = [0.25];
ALparam.kstd_level = [1];
ALparam.method = 'direct';
ALparam.method = 'direct';
ALparam.stop_cond = [1e-5 1e-5];
ALparam.echo_ch = 'off';
% ALparam.C=[0.0001 0.5*12];
% ALparam.C=[0.0001];
ALparam.kstd_level=[0.2]; % kernel width, not used here
% ALparam.method='direct'; % not using kernel
% ALparam.stop_cond=[1e-12 1e-12];
% ALparam.echo_ch='off';
% % if size(x,1)==2, plot_ch='on'; else, plot_ch='off'; end
% ALparam.hess_ch='full';
% % kc_ini=[x];
% %kc_ini=kmc(x,20);
% ALparam.LN = 20; % maximum labeled primary data
% ALparam.sel_stop_condition = [0.1 0.5]; % used in active label selection
% ALparam.plot_ch='off'; % plot the active selection process


end