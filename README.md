# Prophage_movement
This package contains scripts to track prophage movement in clonal populations using short read data. The first script is an R script which uses prophage coordinates in draft Illumina assemblies and generates bed files of the flanking regions either side of the prophage. The second script is a Python script which parses out the flanking regions from the draft assembly and blasts it against a reference genome. The output is a blast table showing the genome coordinates of the flanking regions.

# Generating bed files

The R script accepts as input a .csv file containing prophage coordinates from draft assemblies. These should have the format "Isolate	Contig	Start	End	Size" where:
* Isolate = name of bacterial assembly containing prophage
* Contig = contig number in bacterial assembly
* Start = start coordinate of prophage in assembly
* End = end coordinate of prophage in assembly
* Size = full length of the contig in bp
  
The R script should be modified to include your file.csv with the prophage coordinates. Further, the output bed file name should be modified to include the prophage name.

# Detecting prophage movement

The python scripts accepts three input files:
* A draft bacterial isolate assembly
* A bed file containing prophage flanking region coordinates for the bacterial assembly
* A reference assembly 

## Basic Usage

'--assembly' path/to/bacterial_draft_assembly.fa
'--bedfile' path/to/prophage_bedfile_for_draft_assembly.bed
'--blastdb' path/to/reference.fna. This must be blast database made using 'makeblastdb -in reference.fna -db nucl'
'--output' output file containing blast results

Example command:
```
python Prophage_movement.py --assembly assembly.fna --bedfile bedfile.bed --blastdb reference.fna --output Blast_output.txt
```
