# Prophage_movement
These scripts can be used to track prophage movement in cloesly related/clonal populations using short read data. They were created due to a dearth of tools available to track prophage movement using short read data, and have been adapted to account for inaccurate prophage boundaries in multi-contig assemblies. 

The first script (R) generates bed files containing the genome coordinates of 5kb (or to end of contig) regions up and downstream of prophages identified in draft bacterial assemblies using prophage identification tools such as PHASTER (available at: https://phaster.ca/). Using 5kb regions should account for prophage boundary errors made by the prophage identification tools but can be increased to larger regions in the R script. Moreover, as prophages often sit at contig boundaries in draft assemblies (due to repetitive regions), the use of 5kb regions up and downstream of the prophages allows the tracking of prophage movement via the 5kb region opposite the contig boundary. 

The second script (Python) functions by parsing out the 5kb flanking regions from the draft assemblies and blasting them against a complete assembled reference genome. The output is a blast table showing the genome coordinates of the flanking regions. If flanking regions map to similar reference genomic positions in all isolates then the prophages have likely not moved. However, if one or both of the flanking regions are in different positions, then the prophages may have moved (if only one region moves then the prophage has likely moved but the contig-proximate position may be within the prophage boundary).

Please feel free to use and adapt these scripts for your own data! If you have any issues then please create a GitHub issue.

# Requirements

R script requirements can be seen in the script.

The Python script was tested with the following dependencies but may work for earlier or later versions (although Python v3 is required).

* [Python](https://www.python.org/) v3.9.5
* [Pybedtools](https://daler.github.io/pybedtools/) v0.8.2
* [BLAST+](ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/) v2.10.1

# Installation

At the moment there is no conda or pip installation. Therefore just download the scripts to the appropriate working directories.

# Generating bed files

The R script accepts as input a .csv file containing prophage coordinates from draft assemblies. These should have five columns with the titles: "Isolate", "Contig", "Start", "End", "Size" where the columns contain:
* Isolate -> name of bacterial assembly containing prophage
* Contig -> contig number in bacterial assembly
* Start -> start coordinate of prophage in assembly
* End -> end coordinate of prophage in assembly
* Size -> full length of the contig in bp
  
The R script should be modified (See R script notes) to include your .csv with the prophage coordinates. Further, the output bed file name should be modified to include the prophage name.

# Detecting prophage movement

The python script accepts three input files:
* A draft bacterial isolate assembly
* A bed file containing prophage flanking region coordinates for the bacterial assembly (generated using R script)
* A well assembled closely related reference assembly (e.g ancestral assembly)

## Usage

`-a, --assembly` path/to/bacterial_draft_assembly.fa

`-b, --bedfile` path/to/prophage_bedfile_for_draft_assembly.bed

`-db, --blastdb` path/to/reference.fna. This must be blast database made using `makeblastdb -in reference.fna -db nucl`

`-o, --output` output file containing blast results (add extension)

Example command:
```
python Prophage_movement.py --assembly assembly.fna --bedfile bedfile.bed --blastdb reference.fna --output Blast_output.txt
```

# Output

The output is a blast table with columns showing from left to right:
* Query sequence ID (prophage flanking region)
* Subject sequence ID (Reference chromosome/contig)
* Percent identity
* Alignment length
* Number of mismatches
* Number of gap openings
* Start of alignment in query
* End of alignment in query
* Start of alignment in subject
* End of alignment in subject
* Expect value
* Bitscore
