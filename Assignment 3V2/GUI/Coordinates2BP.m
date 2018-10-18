function [letter,number] = Coordinates2BP(x,y)
	half_block_length = 36/2;
	base = 175;

	x = (((x-base)/half_block_length)+1)/2;
	number = x;
	
	y = y/20;
	switch y
		case -8
			letter = 'A';
		case -6
			letter = 'B';
		case -4
			letter = 'C';
		case -2
			letter = 'D';
		case 0
			letter = 'E';
		case 2
			letter = 'F';
		case 4
			letter = 'G';
		case 6
			letter = 'H';
		case 8
			letter = 'I';
	end
end