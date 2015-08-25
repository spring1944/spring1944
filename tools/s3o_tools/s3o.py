#!/usr/bin/env python

import struct

_S3OHeader_struct = struct.Struct("< 12s i 5f 4i")
_S3OPiece_struct = struct.Struct("< 10i 3f")
_S3OVertex_struct = struct.Struct("< 3f 3f 2f")
_S3OChildOffset_struct = struct.Struct("< i")
_S3OIndex_struct = struct.Struct("< i")


def _get_null_terminated_string(data, offset):
    if offset == 0:
        return b""
    else:
        return data[offset:data.index(b'\x00', offset)]


class S3O(object):
    def __init__(self, data):
        header = _S3OHeader_struct.unpack_from(data, 0)

        magic, version, radius, height, mid_x, mid_y, mid_z, \
        root_piece_offset, collision_data_offset, tex1_offset, \
        tex2_offset = header

        assert(magic == b'Spring unit\x00')
        assert(version == 0)
        assert(collision_data_offset == 0)

        self.collision_radius = radius
        self.height = height
        self.midpoint = (mid_x, mid_y, mid_z)

        self.texture_paths = (_get_null_terminated_string(data, tex1_offset),
                              _get_null_terminated_string(data, tex2_offset))
        self.root_piece = S3OPiece(data, root_piece_offset)

    def serialize(self):
        encoded_texpath1 = self.texture_paths[0] + b'\x00'
        encoded_texpath2 = self.texture_paths[1] + b'\x00'

        tex1_offset = _S3OHeader_struct.size
        tex2_offset = tex1_offset + len(encoded_texpath1)
        root_offset = tex2_offset + len(encoded_texpath2)

        args = (b'Spring unit\x00', 0, self.collision_radius, self.height,
               self.midpoint[0], self.midpoint[1], self.midpoint[2],
               root_offset, 0, tex1_offset, tex2_offset)

        header = _S3OHeader_struct.pack(*args)

        data = header + encoded_texpath1 + encoded_texpath2
        data += self.root_piece.serialize(len(data))

        return data


class S3OPiece(object):
    def __init__(self, data, offset, parent=None):
        piece = _S3OPiece_struct.unpack_from(data, offset)

        name_offset, num_children, children_offset, num_vertices, \
        vertex_offset, vertex_type, primitive_type, num_indices, \
        index_offset, collision_data_offset, x_offset, y_offset, \
        z_offset = piece

        self.parent = parent
        self.name = _get_null_terminated_string(data, name_offset)
        self.primitive_type = ["triangles",
                               "triangle strips",
                               "quads"][primitive_type]
        self.parent_offset = (x_offset, y_offset, z_offset)

        self.vertices = []
        for i in range(num_vertices):
            current_offset = vertex_offset + _S3OVertex_struct.size * i
            vertex = _S3OVertex_struct.unpack_from(data, current_offset)

            position = vertex[:3]
            normal = vertex[3:6]
            texcoords = vertex[6:]

            self.vertices.append((position, normal, texcoords))

        self.indices = []
        for i in range(num_indices):
            current_offset = index_offset + _S3OIndex_struct.size * i
            index, = _S3OIndex_struct.unpack_from(data, current_offset)
            self.indices.append(index)

        self.children = []
        for i in range(num_children):
            cur_offset = children_offset + _S3OChildOffset_struct.size * i
            child_offset, = _S3OChildOffset_struct.unpack_from(data, cur_offset)
            self.children.append(S3OPiece(data, child_offset))

    def serialize(self, offset):
        name_offset = _S3OPiece_struct.size + offset
        encoded_name = self.name + b'\x00'

        children_offset = name_offset + len(encoded_name)
        child_data = b''
        # HACK: make an empty buffer to put size in later
        for i in range(len(self.children)):
            child_data += _S3OChildOffset_struct.pack(i)

        vertex_offset = children_offset + len(child_data)
        vertex_data = b''
        for pos, nor, uv in self.vertices:
            vertex_data += _S3OVertex_struct.pack(pos[0], pos[1], pos[2],
                                                  nor[0], nor[1], nor[2],
                                                  uv[0], uv[1])

        index_offset = vertex_offset + len(vertex_data)
        index_data = b''
        for index in self.indices:
            vertex_data += _S3OIndex_struct.pack(index)

        primitive_type = {"triangles": 0,
                          "triangle strips": 1,
                          "quads": 2}[self.primitive_type]

        args = (name_offset, len(self.children), children_offset,
                len(self.vertices), vertex_offset, 0, primitive_type,
                len(self.indices), index_offset, 0) + self.parent_offset

        piece_header = _S3OPiece_struct.pack(*args)

        child_offsets = []

        data = piece_header + encoded_name + child_data + vertex_data + index_data

        serialized_child_data = b''
        for child in self.children:
            child_offset = offset + len(data) + len(serialized_child_data)
            child_offsets.append(child_offset)
            serialized_child_data += child.serialize(child_offset)

        child_data = b''
        for child_offset in child_offsets:
            child_data += _S3OChildOffset_struct.pack(child_offset)

        data = piece_header + encoded_name + child_data + vertex_data + \
               index_data + serialized_child_data

        return data
