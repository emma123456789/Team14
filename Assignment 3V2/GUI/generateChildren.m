function children  = generateChildren( board, plr )
    [ rows columns ] = find(board == 0);
    [ row column ] = size(board);
    [ spaces_ spaces ] = size(rows);
    children = zeros(row, column, spaces_);
    
    for i=1:spaces_
        child = board;
        child( rows(i, 1), columns(i, 1) ) = plr;
        children(:, :, i) = child;
    end
end

