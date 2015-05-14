% Author: Phyo Thiha
% Date: 5/13/2015
% Description:
% Script to animate the movement of smiley's facial parts 
% in relation to the passing hours and minutes of the day.
%
% To run,
% >> animate_clock
% 
% Note: this script is dependent on the file below:
% - 'draw_clock.m'

clearvars;  % start from fresh
close all;

profile on
hours = 10:14;
minutes = 0:59;

for i = 1:numel(hours)
    for j = 1:numel(minutes)
        draw_clock(hours(i), minutes(j));
        pause(0.001);
        refresh;
    end
end

profile viewer
%p = profile('info');
%profsave(p,'profile_results')