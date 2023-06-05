function move_robot_to_pos(X, Y, Z)
    angles = inverse_kinematics(X, Y, Z);
    joint_1_angle = angles(1);
    joint_2_angle = angles(2);
    joint_3_angle = angles(3);
    SimulinkConstantBlockName1 = "simulation_three_motors/Constant1";
    SimulinkConstantBlockName1 = "simulation_three_motors/Constant2";
    SimulinkConstantBlockName3 = "simulation_three_motors/Constant3";
    set_param(SimulinkConstantBlockName1, 'Value', mat2str(joint_2_angle));
    set_param(SimulinkConstantBlockName2, 'Value', mat2str(joint_2_angle));
    set_param(SimulinkConstantBlockName3, 'Value', mat2str(joint_3_angle));
end