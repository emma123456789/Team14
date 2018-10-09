function waitForRobotDone()
    global done_flag;

    while done_flag == 0
    end
    done_flag = 0;
end