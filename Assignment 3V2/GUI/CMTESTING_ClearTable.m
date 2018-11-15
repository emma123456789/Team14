%CMTESTING_ClearTable
%Adds 16 blocks to the blocklist according to the test camera image, then
%calls CM_CLEARTABLE to command the robot to move them to the conveyer.
%
%The GUI should be running and connected to the robotstudio simulation
%before calling.
%
%All blocks are assumed to have 0 initial rotation.
%
%see also CM_CLEARTABLE

%Get BP coordinates from the gameboardConversion function
blocklist_test = [];
for i =3:2:9
    [x, y] = gameboardConversion(i,'B');
    blocklist_test = [blocklist_test; [x, y]];
    
    [x, y] = gameboardConversion(i,'D');
    blocklist_test = [blocklist_test; [x, y]];
    
    [x, y] = gameboardConversion(i,'F');
    blocklist_test = [blocklist_test; [x, y]];
    
    [x, y] = gameboardConversion(i,'I');
    blocklist_test = [blocklist_test; [x, y]];
end

global queue;
global tableBlockData;
%     fast = 'v500';
%     regular = 'v100';
%     slow = 'v50';
%     table_height = 147;
%     conveyor_height = 22;
%     block_height = 5;
%     move_height = table_height + block_height * 6;
%     grip_height = table_height + block_height;
%     conveyor_grip_height = conveyor_height + block_height;
    
    %add the occupied BP coordinates to the block list
    for i = 1:length(blocklist_test(:,1))
            tableList = sprintf('%.0f %.0f %.0f %.0f %s', blocklist_test(i,1),blocklist_test(i,2),0, 1, 'B1');%blocklist_test(i,3));
            tableList = string(tableList)
            if isempty(tableBlockData)
                tableBlockData = tableList;
            else
                tableBlockData = [tableBlockData; tableList];
            end
%             set(handles.TableBlocksListbox, 'String', tableBlockData);
%             set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
%             set(handles.BPtoBPBlockList, 'String', tableBlockData);
%             set(handles.RotateBlockBlockList, 'String', tableBlockData);
    end
    
    %Command the robot to do teh clear table complex move.
    CM_ClearTable()
    
    
    
