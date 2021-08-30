# Prophage_movement
These scripts can be used to track prophage movement in clonal (or close to) populations using short read data. They were created due to a dearth of tools available to track prophage movement using short read data, and have been adapted to account for inaccurate prophage boundaries in multi-contig assemblies. 

The first script (R) functions by identifying the genome coordinates of 5kb (or to end of contig) regions up and downstream of prophages identified using prophage identification tools such as PHASTER (available at: https://phaster.ca/) and generating a bed file that can be used in downstream analyses. By using 5kb regions, this should account for prophage boundaries errors that may have occurred during prophage identification. Further, by using 5kb regions either side of the prophage, if a prophage sits near a contig boundary, the 5kb region on the opposite side can still be used to track prophage movement. The second script (Python) functions by parsing out the 5kb flanking regions from the draft assemblies and blasting them against a complete assembled reference genome. The output is a blast table showing the genome coordinates of the flanking regions.

# Generating bed files

The R script accepts as input a .csv file containing prophage coordinates from draft assemblies. These should have five columns with the titles: "Isolate", "Contig", "Start", "End", "Size" where the columns contain:
* Isolate -> name of bacterial assembly containing prophage
* Contig -> contig number in bacterial assembly
* Start -> start coordinate of prophage in assembly
* End -> end coordinate of prophage in assembly
* Size -> full length of the contig in bp
  
The R script should be modified (See R script notes) to include your file.csv with the prophage coordinates. Further, the output bed file name should be modified to include the prophage name.

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
