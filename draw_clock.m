% Author: Phyo Thiha
% Date: 5/13/2015
% Description:
% MATLAB script to draw a smiley face that represents the clock.
% The smiley's right eye represents the hour (in the interval of 12)
% and the left eye represents the minute hand. The width of the smile
% (semicircle) represents the whole 24 hour period with the label 
% indicating 'AM' or 'PM' at the tip of the smile.
% 
% To run the script, put this file in your current MATLAB folder and type:
% >> clockie
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
    global black;
    global face_size;
    global eye_y;
    global eye_size;
    global reye_x leye_x;
    
    set_colors();
    set_face_vars();
    set_eye_vars();

    
    draw_face();
    draw_eyes();

    % Define smile parameters and draw it.
    smile_x = (1/2 * face_size);
    smile_y = (2/5 * face_size);
    smile_r = 4;
    smile_color = 'k';
    smile_thickness = 3;
    draw_smile(cur_hour, smile_x, smile_y, smile_r, smile_color, smile_thickness);
    [edge_x, edge_y] = get_edge_of_smile(cur_hour, smile_x, smile_y, smile_r);

    % Add 'AM' or 'PM' label at the end of the smile
    add_label_to_smile(cur_hour, edge_x, edge_y);
    
    iris_radius = 1;
    iris_color = 'k';
    offset = 0.5 + iris_radius; % dist. btw iris center to the eyeball center
    

    % right side eye ball that represents the 'hour'
    eye_top = eye_y + eye_size + 1;         % 16; '1' for offset
    eye_ycenter = eye_y + (eye_size/2);     % 12.5
    reye_xcenter = reye_x + (eye_size/2);   % 6.5
    leye_xcenter = leye_x + (eye_size/2);    % 13.5

    add_label_to_eyes(reye_xcenter, leye_xcenter, eye_top);

    draw_hour_eye(cur_hour, reye_xcenter, eye_ycenter,...
        iris_radius, iris_color, offset);
    % draw minute
    %cur_minute
    l_iris_x = leye_xcenter + (offset * sin((pi/30) * cur_minute));
    l_iris_y = eye_ycenter + (offset * cos((pi/30) * cur_minute));
    draw_filled_circle(l_iris_x, l_iris_y, iris_radius, iris_color);
    
    %text(face_size/3, 1, 'Current Time: ' 
end

function set_colors()
    dark_yellow = [0.9 0.9 0];
    soft_white = [0.95 0.95 0.95];
    black = [0 0 0];
end

% Face size variable is shared by a few other methods because
% everything we draw is in relation to it. We could pass this 
% variable around as an input to methods that use it, but I
% personally decided to keep the method signature "clean".
function set_face_vars()
    face_size = 20;
end

% Eye-related variables shared between  other drawing methods.
function set_eye_vars()
    global face_size;
    global eye_y;
    global eye_size;

    eye_y = 1/2 * face_size;    % vertical location of the eye
    eye_size = 5;
end

    
% Set up figure properties
function set_figure()
    figure;
    hold on;
    axis equal;
    title('Smiley Clock');
    xlabel('x');
    ylabel('y');
end

% Draw an iris inside the right eye to represent the hour value.
% 'offset' is the distance between the centers of the eyeball and the iris.
function draw_hour_eye(cur_hour, x, y, radius, color, offset)
    mod_cur_hour = mod(cur_hour, 12);
    hour_in_min = mod_cur_hour * 60;
    
    r_iris_x = x + (offset * sin((pi/360) * hour_in_min));
    r_iris_y = y + (offset * cos((pi/360) * hour_in_min));
    draw_filled_circle(r_iris_x, r_iris_y, radius, color);
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

% Define face size, position, thickness etc. and draw it.
% Note: We probably don't need both draw_face and draw_eye methods, but
% I think it's better to be able to mention the intent of what 
% they are doing by using different method names. Also, it's nice to
% encapsulate the parameters related to the face in this method.
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
    global face_size;
    global eye_size eye_y;
    global reye_x leye_x;

    eye_thickness = 3;
    reye_x = 1/5 * face_size;   % horizontal location of the right eye
    leye_x = face_size - ((1/5 * face_size) + eye_size); % for the left eye

    draw_circle(reye_x, eye_y, eye_size, soft_white, eye_thickness);
    draw_circle(leye_x, eye_y, eye_size, soft_white, eye_thickness);
end

% Returns position vector of form [x,y,w,h] to be used with 
% the 'rectangle' drawing function.
function pos = get_position(x, y, r)
    pos = [x y r r];
end

% Returns the x,y of the last point of the smile figure so that
% we can put a label ['AM' or 'PM'] at the end of it.
function [x, y] = get_edge_of_smile(cur_hour, smile_x, smile_y, smile_radius)
    [xv, yv] = get_smile_path(cur_hour, smile_x, smile_y, smile_radius);
    x = xv(end);
    y = yv(end);
end

% Smile is based on a semi-circle that correlates with 
% the fraction of current time to the 24-hour time of the day.
% For example, at 12:00 (midday), the smile should be half way 
% (12/24 = 1/2) of the full smile (semicircle). At 20:00 (8 PM), 
% the smile should be (20/24 = 5/6th) of the full smile.
function draw_smile(cur_hour, smile_x, smile_y, smile_radius, smile_color,...
    smile_thickness)
    [sx, sy] = get_smile_path(cur_hour, smile_x, smile_y, smile_radius);
    plot(sx, sy, 'Color' , smile_color, 'LineWidth', smile_thickness);
end

% Returns the path for drawing the smile.
function [sx, sy] = get_smile_path(cur_hour, smile_x, smile_y, smile_radius)
    fr = get_fraction_of_the_day(cur_hour);
    th = get_smile_points(fr);
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

function add_label_to_eyes(righteye_x, lefteye_x, eye_y)
    r_offset = 0.6; % adjust horizontal position because of the font size
    l_offset = 0.7;
    
    text(righteye_x-r_offset, eye_y, 'H', 'FontSize', 20);
    text(lefteye_x-l_offset, eye_y, 'M', 'FontSize', 20);
end

% Add 'AM' or 'PM' label to smile
function add_label_to_smile(cur_hour, x, y)
    offset = 0.5;

    label = 'AM';
    if cur_hour >= 12
        label = 'PM';
    end

    text(x+offset, y+offset, label);
end
