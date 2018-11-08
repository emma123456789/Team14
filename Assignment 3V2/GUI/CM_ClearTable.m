% This funciton calls simple move functions and clears the table.
% Requirements: Move all reachable blocks on the table into an empty box. 
% Up to 16 blocks will be on the table in this case. Blocks may be 
% scattered over the table at locations outside of BP. There is no 
% requirement on where the blocks need to be placed in the box, except 
% see assumption 6.

function CM_ClearTable()
	% Read the block list
    global tableBlockData;
    global BP2Conveyor_index;
    global BoxX;
    global BoxY;
    BP2Conveyor_index = 1;
	
	% Check each block in the table block list
	len = length(tableBlockData);
	for i = 1:len
		stringSplit = strsplit(tableBlockData(BP2Conveyor_index));
		x1 = str2double(stringSplit(1));
        y1 = str2double(stringSplit(2));
        if (isReachable(x1, y1) == true)
            SM_BP2ConveyorModified(x1, y1, BoxX, BoxY)
            BP2Conveyor_updateBlocklist(BoxX,BoxY)
            BP2Conveyor_index = BP2Conveyor_index-1;
        end
        BP2Conveyor_index = BP2Conveyor_index+1;
        
    end

end

 function reachable = isReachable(x, y)
    %zeroPosition = [805, 25.5943];
    %radius = 832.405697; 
    radius = 548.6;
    
    % Check if block is within reachable radius of robot
    if((x)^2+(y)^2<radius^2)
        reachable = true;
    else
        reachable = false;
    end
end