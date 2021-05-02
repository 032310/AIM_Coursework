% clear console
clc;
clear;
close all;

% bbob benchmark directory
addpath('./');
% output data file location
datapath = './PSOoutput';
% algorithm name
opt.algName = 'Particle Swarm Optimisation';
opt.comments = 'PSO tests';

% 10*dim is a short test-experiment taking a few minutes
% INCREMENT maxfunevals successively to larger value(s)
maxfunevals = '5000';
% PUT MINIMAL SENSIBLE NUMBER OF EVALUATIONS for a restart
minfunevals = 'dim';
% SET to zero for an entirely deterministic algorithm (orignal 10000)
maxrestarts = 10000;

more off;  % in octave pagination is on by default
t0 = clock;
rand('state', 0);

% for dim dimensions, original = [ 2, 3, 5, 10, 20]
for dim = [2,3,5,10,20,40]
    disp( sprintf(['%d-D:'], dim) );
    for ifun = benchmarks('FunctionIndices')  % or benchmarksnoisy(...)
        disp(sprintf([' f%d:'], ifun));
        % for i instances
        for i = [1:15]
            % initialisation
            fgeneric('initialize', ifun, i, datapath, opt); 

            % independent restarts until maxfunevals or ftarget is reached
            for restarts = 0:maxrestarts
            % INSERT OPTIMIZER HERE
                PSO( 'fgeneric', dim, fgeneric('ftarget'), eval(maxfunevals) - fgeneric('evaluations'));
                % Break when ftarget gets too big
                if fgeneric('fbest') < fgeneric('ftarget') || (fgeneric('evaluations') + eval(minfunevals)) > eval(maxfunevals)
                    break;
                end  
            end
            % displaying data
            disp(sprintf(['  instance %d: FEs=%d with %d restarts, fbest-ftarget=%.4e, elapsed time [h]: %.2f'], ...
            i, fgeneric('evaluations'), ...
            restarts, fgeneric('fbest') - fgeneric('ftarget'), ...
            etime(clock, t0)/60/60));

            % finalisation
            fgeneric('finalize');
        end
        disp(sprintf(['-f%d DONE!\n'], ifun));
    end
    % dimension dim is done
    disp('______________________________________________________');
    disp(['|      date and time: ' num2str(clock, ' %.0f')]);
    disp(sprintf(['_________________ dimension %d-D done _________________\n\n'], dim));
end
disp(sprintf([' %s DONE!\n\n'], opt.algName));

% post processing
% python -m cocopp [-o C:\University\Undergraduate UoNM\Year 2\Sem 2\Artificial Intelligence Methods\CW\postprocess] C:\University\Undergraduate UoNM\Year 2\Sem 2\Artificial Intelligence Methods\CW\data