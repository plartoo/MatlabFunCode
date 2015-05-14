% Author: Phyo Thiha
% Date: 5/13/2015
% Description:
% Script to animate the movement of smiley's facial parts 
% in relation to the passing hours/minutes of the day.
%
% To run,
% >> animate_clock
% 
% Note that this script is dependent on the file below:
% - 'draw_clock.m'


figure;
hold on;
axis equal;
title('Smiley Clock');
xlabel('x');
ylabel('y');

hours = 0:0;
minutes = 0:15;
for i= 1:numel(hours)
    for j = 1:numel(minutes)
        draw_clock(hours(i), minutes(j));
        hold on;
        pause(0.05);
        refresh;
    end
end

%{
function setup_figure_properties()
    figure;
    hold on;
    axis equal;
    title('Smiley Clock');
    xlabel('x');
    ylabel('y');
end
%}