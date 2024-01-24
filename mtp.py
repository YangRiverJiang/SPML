import struct

def mtp_read(file, latest):
    mat = {}

    with open(file, 'rb') as fid:
        while True:
            c = fid.read(3)
            if not c:
                break

            if c.decode('utf-8') != 'MTX':
                raise ValueError("Invalid file format")

            mat_row = struct.unpack('i', fid.read(4))[0]
            mat_col = struct.unpack('i', fid.read(4))[0]
            m = struct.unpack(f'{mat_row * mat_col}d', fid.read(8 * mat_row * mat_col))

            m = [list(m[i:i + mat_col]) for i in range(0, len(m), mat_col)]
            mat_name_piece = struct.unpack('16s', fid.read(16))[0].decode('utf-8').rstrip('\x00')

            mat_name = f'mat["{mat_name_piece}"]'

            crc = struct.unpack('I', fid.read(4))[0]

            if mat_name_piece in mat and not latest:
                command = f'{mat_name}.append(m)'
            else:
                command = f'{mat_name} = [m]'

            exec(command)

    return mat

 