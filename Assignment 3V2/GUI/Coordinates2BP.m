%    x= 195;
%    y=228;
%    [letter,number]= CoordinatesBP(x,y);

function [letter,number] = Coordinates2BP(x,y)
    %blocks 32*32
    Deskcheck=y;
    flag=1;
	half_block_length = 36/2;  %37
	base = 175;
     error_x = (2/18+1)/2-0.5;
     error_y = 2/half_block_length;
	x = (((x-base)/half_block_length)+1)/2;
    y = y/half_block_length;   
	number = x;
    letter = y;
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
    
    if (Deskcheck>225)||(Deskcheck<-225)
          if (Deskcheck>=228)&&(Deskcheck<=232)
              letter = 'P';
          
          end
          if (Deskcheck>225)&&(Deskcheck<228)
              letter = 'Num';
              number = 'Num';
          end
          if (Deskcheck>=-232)&&(Deskcheck<=-228)
              letter = 'Q';
          end
          if (Deskcheck>-228)&&(Deskcheck<-225)
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
