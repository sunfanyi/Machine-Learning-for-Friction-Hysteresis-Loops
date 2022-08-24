close all;

load real_loops_original.mat

loops = real_loops_original(real_loops_original.CP == 1, :);

figure;
plot(log(loops.loop_idx),loops.kt,'r-o')