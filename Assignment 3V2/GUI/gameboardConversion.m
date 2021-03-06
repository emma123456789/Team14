% Given the BP, this function will convert it to x and y coordinates
function [x_coordinate,y_coordinate] = gameboardConversion(x,y)
	% Define the constant values
	half_block_length = 36/2;
	base = 175;
	
	% Convert the row value to x coordinate
	x_coordinate = base + (half_block_length * (2*x-1));

	% Convert the column letter to y coordinate
	y = convertStringsToChars(y);
	switch y
		case 'A'
			y_coordinate = -half_block_length*8;
		case 'B'
			y_coordinate = -half_block_length*6;
		case 'C'
			y_coordinate = -half_block_length*4;
		case 'D'
			y_coordinate = -half_block_length*2;
		case 'E'
			y_coordinate = 0;
		case 'F'
			y_coordinate = half_block_length*2;
		case 'G'
			y_coordinate = half_block_length*4;
		case 'H'
			y_coordinate = half_block_length*6;
		case 'I'
			y_coordinate = half_block_length*8;
        case 'P'
            y_coordinate = -half_block_length*10-50;
        case 'Q'
            y_coordinate = half_block_length*10+50;
	end
		

end
