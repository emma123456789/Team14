function [letter,number] = Coordinates2BP(x,y)
% Coordinates2BP  change the Coordinates to BP
% [letter,number] = Coordinates2BP(x,y) change the x,y position to BP
    
    %blocks 32*32
    % change the x,y respect to relative axes
    Deskcheck=y;
    flag=1;
    half_block_length = 36/2;  %37
    base = 175;
    error_x = (2/18+1)/2-0.5+0.1;
    error_y = 2/half_block_length+0.1;
    x = (((x-base)/half_block_length)+1)/2;
    y = y/half_block_length;   
    number = x;
    letter = y;
    
    %convert x to number information
    if (rem(number,1)<=error_x)
        number = num2str(floor(number));
    elseif (rem(number,1)>=(1-error_x))
        number = num2str(ceil(number));
    else 
        disp('Not in any BP'); 
        number = 'Num';
        letter = 'Num';
        flag = 0;
    end
       %convert y to letter information
    if (Deskcheck>210)||(Deskcheck<-210)
          if (Deskcheck>=220)&&(Deskcheck<=240)
              letter = 'Q';
          
          end
          
          if (Deskcheck>240)&&(Deskcheck<220)
              letter = 'Num';
              number = 'Num';
          end
          
          if (Deskcheck>=-240)&&(Deskcheck<=-220)
              letter = 'P';
          end
          if (Deskcheck>-220)&&(Deskcheck<-240)
              letter = 'Num';
              number = 'Num';
          end
    else
        
    if (y>=0) && (flag==1) 
        if (rem(letter,1)<=error_y)
            letter=floor(letter);
        elseif(rem(letter,1)>=(1-error_y))
            letter=ceil(letter);
        else
            disp('Not in any BP'); 
            number = 'Num';
            letter = 'Num';
            flag = 0;
        end
    
    elseif y<0 && flag==1
        if (rem(letter,1)>=-error_y)
            letter= ceil(letter);
        elseif(rem(letter,1)<=-(1-error_y))
            letter = floor(letter);
        else
            disp('Not in any BP'); 
            number = 'Num';
            letter = 'Num';
            flag = 0;
        end
        
    end
    
    end
        y=letter;
	 %give the BP depending on the calculation above
        if (flag==1)
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
        
        
end
