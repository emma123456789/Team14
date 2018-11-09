function children  = generateChildren( board, turn )
    [ rows cols ] = find(board == 0);
    [ row col ] = size(board);
    [ spaces_ spaces ] = size(rows);
    children = zeros(row, col, spaces_);
    
    for i=1:spaces_
        child = board;
        child( rows(i, 1), cols(i, 1) ) = turn;
        children(:, :, i) = child;
    end
end

