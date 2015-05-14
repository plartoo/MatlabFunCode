% Author: Phyo Thiha
% Date: 5/13/2015
% Description:
% This MATLAB program draws a smiley face (Smiley) that tells (hints at)
% the current time. Smiley's right eye represents the hour 
% (within the interval of 12) and the left eye represents 
% the minute hand. The width of the smile (semicircle) on 
% Smiley's face represents the whole 24 hour period with 
% the label indicating 'AM' or 'PM' at the tip of the smile.
% 
% To run, type:
% >> draw_clock
% 
% OR pass the current time as hour and minute parameters of the 
% 'draw_clock' function. For example,
% >> cur_time = clock; % get current time
% >> draw_clock(cur_time(4), cur_time(5));
%
%
% :::References:::
% For the concept of the clock, this minimalist clock inspired the design
% of the smiley clock:
% http://media02.hongkiat.com/clock-designs/Eyeclock.jpg
%
% Parametric eq. of points on a circle's circumference
% http://stackoverflow.com/questions/839899/how-do-i-calculate-a-point-on-a-circle-s-circumference
% x = cx + r * cos(a)
% y = cy + r * sin(a)
%
% Adjustment of the above parametric eq. to fit with clock hands (not quite
% right for this project's use case, so I modified it a bit.)
% http://www.barrington220.org/cms/lib2/IL01001296/Centricity/Domain/2154/Clock%20Parametrics%20Activity.pdf

function draw_clock(cur_hour, cur_minute)

    if nargin < 1
        cur_time = clock;
        cur_hour = cur_time(4);
        cur_minute = cur_time(5);
    end
    
    set_figure();
    set_colors();
    set_face_vars();
    set_eye_vars();
    set_iris_vars();

    draw_face();
    draw_eyes();
    [s_x, s_y, s_r] = draw_smile(cur_hour);

    % Add 'AM' or 'PM' label at the end of the smile
    [tip_x, tip_y] = get_smile_tip(cur_hour, s_x, s_y, s_r);
    add_label_to_smile_tip(cur_hour, tip_x, tip_y);

    add_labels_on_eyes();

    draw_right_iris(cur_hour);
    draw_left_iris(cur_minute);
    
    %text(face_size/3, 1, 'Current Time: ' 
end

% Set figure properties
function set_figure()
    fig_name = 'Smiley Clock';
    
    % if figure is already drawn, reuse it
    if isempty(findobj('Name', fig_name))
        figure('Name', fig_name)
    end
    
    hold on;
    axis off;
    daspect([1 1 1]);
end

% Define colors
function set_colors()
    dark_yellow = [0.9 0.9 0];
    soft_white = [0.95 0.95 0.95];
    black = [0 0 0];
end

% Face size variable is shared by a few methods because
% everything we draw references it. We could pass this 
% variable around as an input to methods that use it, but I
% personally decided to keep the method signature "clean".
function set_face_vars()
    face_size = 20;
end

% Eye-related variables shared between a couple of drawing functions
% TODO: maybe split this into a couple of functions?
function set_eye_vars()
    global face_size;
    global eye_size eye_thickness;
    global reye_x leye_x eye_y;
    global eye_top;
    global eye_ycenter reye_xcenter leye_xcenter;
    
    eye_size = 5;
    eye_thickness = 3;

    % coordinates of the two eye balls
    reye_x = 1/5 * face_size;   % horizontal location of the right eye
    leye_x = face_size - ((1/5 * face_size) + eye_size); % for the left eye
    eye_y = 1/2 * face_size;    % vertical location of the eye

    % 'y' coordinate of the 'H' and 'M' labels on top of the eyes
    eye_top = eye_y + eye_size + 1;     % '+ 1' is to raise label off the eye

    % coordinates of the two iris and the labels on top of the eyes
    eye_ycenter = eye_y + (eye_size/2);         % 12.5
    reye_xcenter = reye_x + (eye_size/2);       % 6.5
    leye_xcenter = leye_x + (eye_size/2);       % 13.5
end

% Iris-specific variables shared between a couple of drawing functions.
% Note: 'eye_to_iris' is the arbitrary distance assigned between 
% eyeball's center and the iris' center to make the iris appear
% off-centered.
% STRANGE/ASK: why do we need to declare 'eye_to_iris' as global but 
% not to 'iris_raidus' although they're used in the same places?
function set_iris_vars()
    global eye_to_iris;

    iris_radius = 1;
    eye_to_iris = iris_radius + 0.5;
end

% Draw an iris inside the right eye to represent the hour value.
% 'offset' is the distance between the centers of the eyeball and the iris.
function draw_right_iris(cur_hour)
    global black;
    global reye_xcenter eye_ycenter iris_radius eye_to_iris;

    mod_cur_hour = mod(cur_hour, 12);
    hour_in_min = mod_cur_hour * 60;

    r_iris_x = reye_xcenter + (eye_to_iris * sin((pi/360) * hour_in_min));
    r_iris_y = eye_ycenter + (eye_to_iris * cos((pi/360) * hour_in_min));
    draw_filled_circle(r_iris_x, r_iris_y, iris_radius, black);
end

% Draw an iris inside the left eye to represent the minute value.
function draw_left_iris(cur_minute)
    global black;
    global leye_xcenter eye_ycenter iris_radius eye_to_iris;

    l_iris_x = leye_xcenter + (eye_to_iris * sin((pi/30) * cur_minute));
    l_iris_y = eye_ycenter + (eye_to_iris * cos((pi/30) * cur_minute));
    draw_filled_circle(l_iris_x, l_iris_y, iris_radius, black);
end

% This is one way to draw a filled circle in MATLAB.
% This approach requires the center point coordinates of 
% the circle as well as the raidus and (optional) color parameters.
function draw_filled_circle(x, y, radius, color)
    angle = 2 * pi/1000 * (1:1000);
    fill((x+radius*cos(angle)), (y+radius*sin(angle)), color);
end

% This is another way to draw a filled circle in MATLAB.
% Face and eyes are all based on the shape of a circle.
% This approach requires the bottom left corner coordinates 
% of the circle instead of the center.
% Ref.: http://www.mathworks.com/help/matlab/ref/rectangle.html
function draw_circle(x, y, size, color, thickness)
    pos = get_position(x, y, size);
    rectangle('Position',pos,...
            'Curvature',[1 1],...
            'FaceColor',color,...
            'linewidth', thickness);
end

% Returns position vector of form [x,y,w,h] to be
% used with the 'rectangle' drawing function.
function pos = get_position(x, y, r)
    pos = [x y r r];
end

% Define face size, position, thickness etc. and draw it.
% Note: We can reuse 'draw_face()' for 'draw_eyes()', but
% I think it's better to be able to mention the intent of what 
% they are doing by using different method names. 
% It is also nice to encapsulate the parameters related 
% to the face drawing in this method.
function draw_face()
    global dark_yellow;
    global face_size;
    face_x = 0;
    face_y = 0;
    face_thickness = 4;

    draw_circle(face_x, face_y, face_size, dark_yellow, face_thickness);
end

% Draw both the left and the right eyes.
% Note: Because the circles are drawn with rectangle(), 
% we have to manage their positions with reference 
% to the bottom-left corner
function draw_eyes()
    global soft_white;
    global eye_size eye_y;
    global reye_x leye_x eye_thickness;

    draw_circle(reye_x, eye_y, eye_size, soft_white, eye_thickness);
    draw_circle(leye_x, eye_y, eye_size, soft_white, eye_thickness);
end

% Define parameters for smile and draw it.
% Returns the x,y coordinates and radius of the tip of
% the smile so that we can add a label 'AM'/'PM' there.
function [s_x, s_y, s_r] = draw_smile(cur_hour)
    global black;
    global face_size;

    s_x = (1/2 * face_size);
    s_y = (2/5 * face_size);
    s_r = 4;
    smile_thickness = 3;

    draw_semicircle(cur_hour, s_x, s_y, s_r, black, smile_thickness);
end

% Returns the x,y of the last point of the smile figure so that
% we can put a label ['AM' or 'PM'] at the end (tip) of it.
function [x, y] = get_smile_tip(cur_hour, smile_x, smile_y, smile_radius)
    [xv, yv] = get_smile_path(cur_hour, smile_x, smile_y, smile_radius);
    x = xv(end);
    y = yv(end);
end

% Smile is based on a semi-circle that correlates with 
% the fraction of current time to the 24-hour time of the day.
% For example, at 12:00 (midday), the smile should be half way 
% (12/24 = 1/2) of the full smile (semicircle). At 20:00 (8 PM), 
% the smile should be (20/24 = 5/6th) of the full smile.
function draw_semicircle(cur_hour, smile_x, smile_y, smile_radius, smile_color,...
    smile_thickness)
    [sx, sy] = get_smile_path(cur_hour, smile_x, smile_y, smile_radius);
    plot(sx, sy, 'Color' , smile_color, 'LineWidth', smile_thickness);
end

% Returns the path for drawing the smile.
function [sx, sy] = get_smile_path(cur_hour, smile_x, smile_y, smile_radius)
    th = get_smile_points(get_fraction_of_the_day(cur_hour));
    sx = smile_radius*cos(th) + smile_x;
    sy = smile_radius*sin(th) + smile_y;
end

function fraction = get_fraction_of_the_day(cur_hour)
    fraction = cur_hour/24;
end

% Returns the curvature of the smile based on how many hours
% have passed since 00:00 (fraction calculated in 24 hours).
% Note: To start the smile starts from left side of the cheek,
% use this: th = linspace(0, (-pi * fraction_of_day), 100)
% In the formula below, the smile starts from right side of the cheek
function points = get_smile_points(fraction_of_day)
    points = linspace(-pi, (-pi + (pi * fraction_of_day)), 100);
end

% Add 'AM' or 'PM' label to smile
function add_label_to_smile_tip(cur_hour, x, y)
    offset = 0.5;

    label = 'AM';
    if cur_hour >= 12
        label = 'PM';
    end

    text(x+offset, y+offset, label);
end

% Add labels 'H' and 'M' on top of the right and left eyes respectively
function add_labels_on_eyes()
    global reye_xcenter leye_xcenter eye_top;

    r_offset = 0.6; % adjust horizontal position because of the font size
    l_offset = 0.7;
    
    text(reye_xcenter-r_offset, eye_top, 'H', 'FontSize', 20);
    text(leye_xcenter-l_offset, eye_top, 'M', 'FontSize', 20);
end