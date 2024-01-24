function mat = mtp_read(file, latest)

    mat = {};
    fid = fopen(file, 'r');
    
    while ~feof(fid)


        c = fread(fid, 3, 'char*1', 0, 'n');
        if(isempty(c))
            break;
        end

        if ~strcmp(char(c'), 'MTX')

            error("invalid file format");

        end

        mat_row = fread(fid, 1, 'int', 0, 'n');
        if(isempty(mat_row))
            break;
        end

        mat_col = fread(fid, 1, 'int', 0, 'n');
        if(isempty(mat_col))
            break;
        end
        m = fread(fid, mat_row * mat_col, 'real*8', 'n');
        if(isempty(m))
            break;
        end

        m = reshape(m', [mat_col, mat_row])';
        mat_name_piece = fread(fid, 16, 'char*1', 0, 'n');
        mat_name_piece(mat_name_piece == 0) = [];

        mat_name = ['mat.' char(mat_name_piece')];



        crc = fread(fid, 1, 'uint', 'n');
        if(isempty(crc))
            break;
        end

        
        if(isfield(mat, char(mat_name_piece)) && ~latest)
            command = [mat_name '{size(' mat_name ', 1) + 1, 1} = m;'];
        else
            command = [mat_name ' = {m};'];
        end
        
        eval(command);
        
        
    end



    fclose(fid);

end





