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

def get_s3o_sizes(path):
	with open(path, 'rb+') as input_s3o:
		data = input_s3o.read()
		model = S3O(data)
		sizes = recursive_get_sizes(model.root_piece)
		x_diff, y_diff, z_diff = sizes["max"][0] - sizes["min"][0], sizes["max"][1] - sizes["min"][1], sizes["max"][2] - sizes["min"][2]
		name = os.path.splitext(os.path.split(path)[-1])[0]
		print "%s,%s,%s,%s" % (name, x_diff, y_diff, z_diff)
	
if __name__ == '__main__':
	parser = OptionParser(usage="%prog [options] <DIR|FILE1 FILE2 ...>", version="%prog 0.2",
						  description="Get s3o sizes or scale them")
	
	options, args = parser.parse_args()
	if len(args) < 1:
		parser.error("insufficient arguments")

		
	if len(args) == 1 and os.path.isdir(args[0]):
		filenames = s3o_walk(args[0])
	else:
		filenames = args


	for filename in filenames:
		sizes = get_s3o_sizes(filename)
		