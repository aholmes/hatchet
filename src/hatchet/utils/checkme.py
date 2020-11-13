import os.path
import argparse
from . import TotalCounting as tc
from . import ArgParsing as ap
from .Supporting import *
from . import Supporting as sp
from hatchet import config


def parse_arguments(args=None):
    description = ""
    parser = argparse.ArgumentParser(description=description)
    parser.add_argument("-N","--normal", required=True, type=str, help="BAM file corresponding to matched normal sample")
    parser.add_argument("-T","--tumors", required=True, type=str, nargs='+', help="BAM files corresponding to samples from the same tumor")
    parser.add_argument("-b","--size", required=True, type=str, help="Size of the bins, specified as a full number or using the notations either \"kb\" or \"Mb\"")
    parser.add_argument("-S","--samples", required=False, default=config.bin.samples, type=str, nargs='+', help="Sample names for each BAM, given in the same order where the normal name is first (default: inferred from file names)")
    parser.add_argument("-o", "--output", required=True, type=str, help="Output filename")
    args = parser.parse_args(args)
    return args


def main(args=None):
    log(msg="# Parsing and checking input arguments\n", level="STEP")
    try:
        args = parse_arguments(args)

        # Parse BAM files, check their existence, and infer or parse the corresponding sample names
        normalbaf = args.normal
        if not os.path.isfile(normalbaf): raise ValueError(sp.error("The specified normal BAM file does not exist"))
        tumors = args.tumors
        for tumor in tumors:
            if(not os.path.isfile(tumor)): raise ValueError(sp.error("The specified normal BAM file does not exist"))
        names = args.samples
        if names != None and (len(tumors)+1) != len(names):
            raise ValueError(sp.error("A sample name must be provided for each corresponding BAM: both for each normal sample and each tumor sample"))
        normal = ()
        samples = set()
        if names is None:
            normal = (normalbaf, os.path.splitext(os.path.basename(normalbaf))[0] )
            for tumor in tumors:
                samples.add((tumor, os.path.splitext(os.path.basename(tumor))[0]))
        else:
            normal = (normalbaf, names[0])
            for i in range(len(tumors)):
                samples.add((tumors[i], names[i+1]))

        # Check and parse the given size
        size = 0
        try:
            if args.size[-2:] == "kb":
                size = int(args.size[:-2]) * 1000
            elif args.size[-2:] == "Mb":
                size = int(args.size[:-2]) * 1000000
            else:
                size = int(args.size)
        except:
            raise ValueError(sp.error("Size must be a number, optionally ending with either \"kb\" or \"Mb\"!"))

    except Exception as e:
        with open(args.output, 'w') as f:
            f.write(str(e) + '\n\n')

    else:
        with open(args.output, 'w') as f:
            f.write('normal='+str(normal) + '\n')
            f.write('samples='+str(samples) + '\n')
            f.write('size='+str(size) + '\n')


if __name__ == '__main__':
    main()
