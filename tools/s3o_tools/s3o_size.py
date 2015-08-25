#!/usr/bin/env python

from s3o import S3O
from s3o_optimize import recursively_optimize_pieces

from optparse import OptionParser
from functools import partial
import os
import os.path

def s3o_walk(root_path):
	for root, dirs, files in os.walk(root_path):
		for name in files:
			if name.lower().endswith(".s3o"):
				yield os.path.join(root, name)


def recursive_get_sizes(piece, sizes = {}, offset = (0,0,0)):
	new_offset = map(sum, zip(piece.parent_offset, offset))
	
	if len(piece.vertices) > 4:
		for vertex in piece.vertices:
			coord = map(sum, zip(vertex[0],new_offset))
			if "max" not in sizes:
				sizes["max"] = coord[:]
				sizes["min"] = coord[:]
			else:
				for i in range(3):
					if coord[i] > sizes["max"][i]:
						sizes["max"][i] = coord[i]
					if coord[i] < sizes["min"][i]:
						sizes["min"][i] = coord[i]
	
	for child in piece.children:
		recursive_get_sizes(child, sizes, new_offset)
	
	return sizes
	
def scale_vertex(t, scale):
	return tuple(t[i] * scale for i in (0,1,2))
	
def recursively_scale_pieces(piece, scale):
	new_vertices = []
	
	for vertex in piece.vertices:
		new_vertices.append((scale_vertex(vertex[0], scale),) + vertex[1:])
	
	piece.vertices = new_vertices
	
	piece.parent_offset = scale_vertex(piece.parent_offset, scale)
	
	for child in piece.children:
		recursively_scale_pieces(child, scale)
	

def rescale(path, scale):
	with open(path, 'rb+') as input_s3o:
		data = input_s3o.read()
		model = S3O(data)

		recursively_scale_pieces(model.root_piece, scale)
		model.midpoint = scale_vertex(model.midpoint, scale)
		model.collision_radius = model.collision_radius * scale
		model.height = model.height * scale
		new_data = model.serialize()
		
		input_s3o.seek(0)
		input_s3o.truncate()
		input_s3o.write(new_data)
	
	
	
def get_s3o_sizes(path):
	with open(path, 'rb') as input_s3o:
		data = input_s3o.read()
		model = S3O(data)
		sizes = recursive_get_sizes(model.root_piece)
		x_diff, y_diff, z_diff = sizes["max"][0] - sizes["min"][0], sizes["max"][1] - sizes["min"][1], sizes["max"][2] - sizes["min"][2]
		name = os.path.splitext(os.path.basename(path))[0]
		print "%s,%s,%s,%s" % (name, x_diff, y_diff, z_diff)
	
if __name__ == '__main__':
	parser = OptionParser(usage="%prog [options] <DIR|FILE1 FILE2 ...>", version="%prog 0.2",
						  description="Get s3o sizes or scale them")
	parser.add_option("-r", "--rescale", type = "float", dest="scale",
					  help="rescale the model times SCALE")
					  
	options, args = parser.parse_args()
	if len(args) < 1:
		import sys
		print "%s: error: insufficient arguments\n" % (os.path.basename(sys.argv[0]),)
		parser.print_help()
		exit(1)
		
	if len(args) == 1 and os.path.isdir(args[0]):
		filenames = s3o_walk(args[0])
	else:
		filenames = args
	
	for filename in filenames:
		if options.scale is None:
			sizes = get_s3o_sizes(filename)
		else:
			rescale(filename, options.scale)
		