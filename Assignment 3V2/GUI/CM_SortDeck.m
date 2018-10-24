% This funciton calls simple move functions and sorts the players' deck.
% Requirements: Start with 6 letter and 6 shape blocks distributed randomly
% in either deck. Move all the shape blocks into player 1's deck. Move all
% the letter blocks into player 2's deck.

function CM_SortDeck()
	% Read the block list
    global tableBlockData;
	p1_moveInd = [];
	p2_moveInd = [];
	
	% Check each block in the table block list
	len = length(tableBlockData);
	for i = 1:len
		stringSplit = strsplit(tableBlockData(i));
		BP = char(stringSplit(5));
		% If the block is on player 1's deck
		if strcmp(BP,'P1')||strcmp(BP,'P2')||strcmp(BP,'P3')||strcmp(BP,'P4')||strcmp(BP,'P5')||strcmp(BP,'P6')
			pattern = char(stringSplit(4));
			if strcmp(pattern,'2') % Letter: wrong shape, need to be moved
				p1_moveInd(end+1) = i; % Store the index
			end
		% If the block is on player 2's deck
		elseif strcmp(BP,'Q1')||strcmp(BP,'Q2')||strcmp(BP,'Q3')||strcmp(BP,'Q4')||strcmp(BP,'Q5')||strcmp(BP,'Q6')
			pattern = char(stringSplit(4));
			if strcmp(pattern,'1') % Shape: wrong shape, need to be moved
				p2_moveInd(end+1) = i; % Store the index
			end
		end
	end
	
	% Check if the inputs are exactly 6 letters and 6 shapes
	if ~isequal(length(p1_moveInd),length(p2_moveInd))
		disp('Invalid Input');
	else
		while ~isempty(p1_moveInd)	% Sort the players' decks
			% Move the first block on player 1's deck that needs to be 
			% sorted to an empty BP
			strSplit = strsplit(tableBlockData(p1_moveInd(1)));
			p1_x1 = str2double(strSplit(1));
			p1_y1 = str2double(strSplit(2));
			[p1_x2,p1_y2] = gameboardConversion(9,'P');		% I'll change this position when the OG is defined
			SM_BP2BP(p1_x1, p1_y1, p1_x2, p1_y2);
			
			% Move the first block on player 2's deck that needs to be
			% sorted to the empty space on player 1's deck
			strSplit = strsplit(tableBlockData(p2_moveInd(1)));
			p2_x1 = str2double(strSplit(1));
			p2_y1 = str2double(strSplit(2));
			p2_x2 = p1_x1;
			p2_y2 = p1_y1;
			SM_BP2BP(p2_x1, p2_y1, p2_x2, p2_y2);
			
			% Move the block that was removed from player 1's deck to the
			% empty space on player 2's deck
			SM_BP2BP(p1_x2, p1_y2, p2_x1, p2_y1);
			
			% Update the to-do list
			p1_moveInd(1) = [];
			p2_moveInd(1) = [];		
		end	
	end

end