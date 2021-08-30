import argparse
import os
import pybedtools
from pybedtools import BedTool

parser = argparse.ArgumentParser()
parser.add_argument("-a", "--assembly", help="Input unicycler assembly")
parser.add_argument("-b", "--bedfile", help="Input flanking region bed file")
parser.add_argument("-db", "--blastdb", help="Input reference blast database for flanking region search")
parser.add_argument("-o", "--output", help="Output name for blast results")

args = parser.parse_args()

path = os.getcwd()

a = pybedtools.BedTool(str(path)+ "/"+ str(args.bedfile))
fasta = pybedtools.example_filename(str(path)+ "/" + str(args.assembly))
a = a.sequence(fi=fasta)
b = a.save_seqs(str(path)+ "/output.fa")

cmd = "blastn -query output.fa -db " + str(args.blastdb) + " -out " + str(args.output) + " -outfmt 6"
os.system(cmd)

