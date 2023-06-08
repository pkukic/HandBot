function location = direct_kinematics(angle_motor_1, angle_motor_2, angle_motor_3)

    a1 = 88.0;
    a2 = 177.0;
    a3 = 177.0;
    a4 = 63.0;

    q1 = deg2rad(angle_motor_1);
    q2 = deg2rad(angle_motor_2);
    q3 = deg2rad(angle_motor_3);

    T01 = zeros(4, 4);
    T01(1, :) = [0 cos(q1) -sin(q1) 0];
    T01(2, :) = [0 sin(q1) cos(q1) 0];
    T01(3, :) = [1 0 0 a1];
    T01(4, :) = [0 0 0 1];

    disp('T01');
    disp(T01);

    T12 = zeros(4, 4);
    T12(1, :) = [cos(q2) -sin(q2) 0 a2 * cos(q2)];
    T12(2, :) = [sin(q2) cos(q2) 0 a2 * sin(q2)];
    T12(3, :) = [0 0 1 0];
    T12(4, :) = [0 0 0 1];

    disp('T02');
    disp(T01 * T12);

    T23 = zeros(4, 4);
    T23(1, :) = [cos(q3) -sin(q3) 0 a3 * cos(q3)];
    T23(2, :) = [sin(q3) cos(q3) 0 a3 * sin(q3)];
    T23(3, :) = [0 0 1 0];
    T23(4, :) = [0 0 0 1];

    T03 = T01 * T12 * T23;
    q4 = acos(-(T03(3, 1)));
    disp(q4);
    
    disp('T03');
    disp(T03);

    T3T = zeros(4, 4);
    T3T(1, :) = [-sin(q4) 0 cos(q4) a4 * cos(q4)];
    T3T(2, :) = [cos(q4) 0 sin(q4) a4 * sin(q4)];
    T3T(3, :) = [0 1 0 0];
    T3T(4, :) = [0 0 0 1];

    T0T = T03 * T3T;
    disp('T0T');
    disp(T0T);

    x = T0T(1, 4);
    y = T0T(2, 4);
    z = T0T(3, 4);

    % Return the location as a triple of three floats
    location = [x, y, z];
    
end