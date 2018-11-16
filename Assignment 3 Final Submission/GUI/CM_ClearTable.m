% This funciton calls simple move functions and clears the table.
% Requirements: Move all reachable blocks on the table into an empty box. 
% Up to 16 blocks will be on the table in this case. Blocks may be 
% scattered over the table at locations outside of BP. There is no 
% requirement on where the blocks need to be placed in the box, except 
% see assumption 6.

function CM_ClearTable()
	% global array of the table block information
    global tableBlockData;
    % accessing the index of the block that is being moved
    global BP2Conveyor_index;
    % access the box's center coordinates
    global BoxX;
    global BoxY;

    % Make BP2Conveyor index to 1
    BP2Conveyor_index = 1;
	
	% Check each block in the table block list
	len = length(tableBlockData);
    % loop through the entire table block data list
	for i = 1:len
        % splitting up the string of block information
		stringSplit = strsplit(tableBlockData(BP2Conveyor_index));
		x1 = str2double(stringSplit(1));
        y1 = str2double(stringSplit(2));
        % if the block is reachable, then move it to conveyor
        if (isReachable(x1, y1) == true)
            % modified BP2Conveyor drops it at a height to allow blocks to
            % be placed in same position
            SM_BP2ConveyorModified(x1, y1, BoxX, BoxY)
            BP2Conveyor_updateBlocklist(BoxX,BoxY)
            % the index needs to stay the same if the prior block is 
            % removed from the blocklist
            BP2Conveyor_index = BP2Conveyor_index-1;
        end
        % move the index to the next block
        BP2Conveyor_index = BP2Conveyor_index+1;
        
    end

end

% This reachable function is used within the function CM_ClearTable and
% finds which blocks are reachable or are not
 function reachable = isReachable(x, y)
    % radius of the robot's reachability
    radius = 548.6;
    
    % Check if block is within reachable radius of robot
    if((x)^2+(y)^2<radius^2)
        reachable = true;
    else
        reachable = false;
    end
end