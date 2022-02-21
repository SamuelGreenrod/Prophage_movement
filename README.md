# Prophage_movement
This repository contains early-stage scripts which can be used to track prophage movement in very closely related/clonal populations using short read data. They were created due to a dearth of tools available to track prophage movement using short read data, and have been adapted to account for inaccurate prophage boundaries in multi-contig assemblies. 

The first script (R) generates bed files containing the genome coordinates of 5kb (or to end of contig) regions up and downstream of prophages identified in draft bacterial assemblies using prophage identification tools such as PHASTER (available at: https://phaster.ca/). Using 5kb regions should account for prophage boundary errors made by the prophage identification tools but can be increased to greater lengths in the R script. Moreover, as prophages often sit at contig boundaries in draft assemblies (due to repetitive regions), the use of 5kb regions up and downstream of the prophages allows the tracking of prophage movement via the 5kb region on the opposite side to the contig boundary. The required input for the R script is a table of prophage coordinates for each draft assembly.

The second script (Python) parses out the 5kb flanking regions from the draft assemblies and blasts them against a complete assembled reference genome. The output is a blast table showing the genome coordinates of the flanking regions in the reference. There are a few potential outcomes which can be expected:

* All flanking regions map to similar reference genomic positions (within one prophage length) in all isolates - the prophages have likely not moved. 
* Flanking regions map to different reference genomic positions (but are still one prophage length apart) - the prophages have likely moved.
* Contig boundary-proximate flanking regions are all in the same place but flanking regions on opposite side have moved - prophages have likely moved, but the contig boundary-proximate region may be within the prophage boundary (therefore maps to the prophage in the reference).

Importantly, the reference used must be very closely related to the isolates analysed such as an ancestral strain in an evolution experiment or an isolate from a generally clonal population. This is because mapping prophage flanking regions to a reference assumes that the reference and query sequences are syntenic - if the isolates are not syntenic then the flanking regions may map to different parts of the reference even with no prophage movement. 

If you have any problems using these scripts then please create a GitHub issue. Also, if you have any advice or comments to improve the scripts then please also add an issue and we can discuss updating the scripts. Thank you and I hope this is useful!

# Requirements

R script requirements can be seen in the script.

The Python script was tested with the following dependencies but may work for earlier or later versions (although Python v3 is required).

* [Python](https://www.python.org/) v3.9.5
* [Pybedtools](https://daler.github.io/pybedtools/) v0.8.2
* [BLAST+](ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/) v2.10.1

# Installation

At the moment there is no conda or pip installation. Therefore, please just download the scripts to the appropriate working directories.

# Generating bed files

The R script accepts as input a .csv file containing prophage coordinates from draft assemblies. These should have five columns with the titles: "Isolate", "Contig", "Prophage_start", "Prophage_end", "Contig_length" where the columns contain:
* Isolate -> name of bacterial assembly containing prophage
* Contig -> contig number in bacterial assembly
* Prophage_start -> start coordinate of prophage in assembly
* Prophage_end -> end coordinate of prophage in assembly
* Contig_length -> full length of the contig in bp

The scripts were tested using prophage coordinates generated using the PHASTER tool (https://phaster.ca/) with draft assemblies constructed using Unicycler Illumina-only assembly (https://github.com/rrwick/Unicycler).

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
