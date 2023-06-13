function angles = inverse_kinematics(X, Y, Z)
    
    a1 = 88.0;
    a2 = 177.0;
    a3 = 185.0;
    a4 = 68.0;

    Z = Z + 20;

    q1 = atan2(Y, X);

    h1 = X * cos(q1) + Y * sin(q1);
    h2 = Z - a1 + a4;
    dist2 = h1^2 + h2^2;

    q3 = acos((dist2 - a2^2 - a3^2) / (2 * a2 * a3));

    s2 = (h1 * (a2 + a3 * cos(q3)) - a3 * sin(q3) * h2) / dist2;
    c2 = (h2 * (a2 + a3 * cos(q3)) + a3 * sin(q3) * h1) / dist2;

    q2 = atan2(s2, c2);

    angle1 = rad2deg(q1);
    angle2 = rad2deg(q2);
    angle3 = rad2deg(q3);

    angles = [angle1, angle2, angle3];

end