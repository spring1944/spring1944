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

def add_pieces(piece, piece_list):
    piece_list.append(piece)
    piece.old_name = piece.name
    for child in piece.children:
        add_pieces(child, piece_list)

def get_all_pieces(root_piece):
    piece_list = []
    add_pieces(root_piece, piece_list)
    return piece_list

def update_piece_names(root_piece):
    piece_list = get_all_pieces(root_piece)
    menu(piece_list)

def save_txt(output_txt, piece, indent=0):
    output_txt.write("%s%s\n" % (indent * "    ", piece.name))
    for child in piece.children:
        save_txt(output_txt, child, indent + 1)
    

def load_txt(input_txt, piece, commit):
    changed = 0
    new_name = input_txt.readline().strip()
    if new_name != piece.name:
        print " %s => %s" % (piece.name, new_name)
        changed += 1
        if commit:
            piece.name = new_name
    for child in piece.children:
        changed += load_txt(input_txt, child, commit)
    
    return changed
        
def sizeof_fmt(num):
    for x in ['bytes', 'KB', 'MB', 'GB']:
        if abs(num) < 1024.0:
            return "%3.1f %s" % (num, x)
        num /= 1024.0
    return "%3.1f%s" % (num, 'TB')
    
def dump_s3o(path):
    print "Dumping %s" % (path,)
    with open(path, 'rb') as input_s3o:
        data = input_s3o.read()
    
    model = S3O(data)
    
    with open(path[:-3] + 'txt', 'wb') as output_txt:
        save_txt(output_txt, model.root_piece)

def update_s3o(path, commit, optimize):
    txt_exists = os.path.exists(path[:-3] + 'txt')
    if (commit or not optimize) and not txt_exists:
        print "No txt file, skipping."
        return
    with open(path, 'rb+') as input_s3o:
        data = input_s3o.read()
        model = S3O(data)
        pieces_changed = 0
        if txt_exists:
            with open(path[:-3] + 'txt', 'rb') as input_txt:
                pieces_changed = load_txt(input_txt, model.root_piece, commit)
        
        if optimize:
            recursively_optimize_pieces(model.root_piece)
            
        new_data = model.serialize()
        
        write = False
        changed = False
        if pieces_changed > 0:
            print " %s piece changes" % (pieces_changed,)
            write |= commit
            changed = True
        if optimize and len(new_data) < len(data):
            print " %s bytes optimised" % (len(data) - len(new_data),)
            write = True
            changed = True
        if write:
            input_s3o.seek(0)
            input_s3o.truncate()
            input_s3o.write(new_data)
        return changed
    
if __name__ == '__main__':
    parser = OptionParser(usage="%prog [options] <DIR|FILE1 FILE2 ...>", version="%prog 0.2",
                          description="Edit s3o piece names")
    parser.add_option("-d", "--dump", action="store_true",
                      default=False, dest="dump",
                      help="dump text files with piece names (overwrites old files)")
    parser.add_option("-c", "--commit", action="store_true",
                      default=False, dest="commit",
                      help="commit piece names from text files to s3os")
    parser.add_option("-o", "--optimize", action="store_true",
                      default=False, dest="optimize",
                      help="optimize s3o files")

    options, args = parser.parse_args()
    if len(args) < 1:
        parser.error("insufficient arguments")

    dump = options.dump
    commit = options.commit
    optimize = options.optimize
    
    if dump and (commit or optimize):
        parser.error("-d cannot be mixed with other options")
    
    if len(args) == 1 and os.path.isdir(args[0]):
        filenames = s3o_walk(args[0])
    else:
        filenames = args

    delta_total = 0

    if dump:
        for filename in filenames:
            dump_s3o(filename)
    else:
        total_changed = 0
        for filename in filenames:
            changed = update_s3o(filename, commit = commit, optimize = optimize)
            if changed:
                print filename
                total_changed += 1
            
        print "Total: %s files changed" % (total_changed,)

        
        
            #update_piece_names(model.root_piece)
            # optimized_data = model.serialize()

            # delta_size = len(optimized_data) - len(data)

            # delta_total += delta_size
            # if not silence_output:
                # print("modified %s: "
                      # "size change: %+d bytes" % (filename, delta_size))

            # if not dry:
                # input_file.seek(0)
                # input_file.truncate()
                # input_file.write(optimized_data)

    #print("total size difference: %s" % sizeof_fmt(delta_total))
