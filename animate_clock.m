% Author: Phyo Thiha
% Date: 5/13/2015
% Description:
% Script to animate the movement of smiley's facial parts 
% in relation to the passing hours and minutes of the day.
%
% To run,
% >> animate_clock
% 
% Note 1: this script is dependent on the file below:
% - 'draw_clock.m'
%
% Note 2: If we set the hours of the animation to full day,
% (that is, from 0:23 hours) the animation becomes choppy
% after a few hours. I profiled the code and found that most 
% of the runtime is spent in 'pause()' call. However, I do
% believe that we could shave off some (small amount
% compared to the time spend in 'pause()') time by not
% re-drawing the whole componenets of the face. In other words,
% we could redraw only the iris and the smile part of the face 
% instead of the whole face. This is an afterthought and is 
% a lesson learned for future MATLAB animation coding exercises.

clearvars;  % start from fresh
close all;

profile on
hours = 11:13;
minutes = 0:59;

for i = 1:numel(hours)
    for j = 1:numel(minutes)
        draw_clock(hours(i), minutes(j));
        pause(0.05);
        refresh;
    end
end

profile viewer
%p = profile('info');
%profsave(p,'profile_results')