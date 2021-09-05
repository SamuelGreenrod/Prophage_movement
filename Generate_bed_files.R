### Convert prophage positions to .bed file

## This should be run separately for each prophage changing the appropriate labels each time.

# Dependencies - if not already installed then remove # from "install.packages" and run as normal.

#install.packages("dplyr")
#install.packages("data.table")
library(dplyr)
library(data.table)

# Make a table of prophage 5kb flanking region coordinates
Prophage_table <- read.csv("Prophage_table.csv") #Input required is a .csv with columns (column titles in brackets) containing bacterial isolate name ("Isolate"), Contig name ("Contig"), coordinate at start of prophage ("Prophage_start"), coordinate at end of prophage ("Prophage_end"), and contig length ("Contig_length")
Prophage_table <- within(Prophage_table, Upstream_flank_start <- ifelse(Prophage_start-5000 >= 0, Prophage_start-5000,0)) # Add new column titled "Upstream_flank_start" with start coordinate of 5kb region upstream of prophage (or to the beginning of contig)
Prophage_table <- within(Prophage_table, Downstream_flank_end <- ifelse(Prophage_end+5000<=Contig_length,Prophage_end+5000,Contig_length)) # Add new column titled "Downstream_flank_end" with end coordinate of 5kb region downstream of prophage (or to the end of contig)


# Make tables containing prophage flanking region start and end coordinates
Upstream_flank <- Prophage_table[, c("ï..Isolate","Contig","Upstream_flank_start","Prophage_start")] # Make table containing Isolate, Contig name, start of upstream 5kb flanking region, and end of upstream 5kb flanking region
Downstream_flank <- Prophage_table[, c("ï..Isolate","Contig","Downstream_flank_end","Prophage_end")]  # Make table containing Isolate, Contig name, start of upstream 5kb flanking region, and end of upstream 5kb flanking region


# Draft assemblies often have contigs in opposite orientations, meaning the up and downstream coordinates are reversed.
# This makes prophage flanking region tables with coordinates all in a standardised orientation.
Upstream_flank_oriented <- Upstream_flank
Upstream_flank_oriented$Upstream_flank_start <- pmin(Upstream_flank$Upstream_flank_start,Upstream_flank$Prophage_start) #Puts lowest value between upstream flanking region start and prophage start in left-most column 
Upstream_flank_oriented$Prophage_start <- pmax(Upstream_flank$Upstream_flank_start,Upstream_flank$Prophage_start) #Puts highest value between upstream flanking region start and prophage start in right-most column 

Downstream_flank_oriented <- Downstream_flank
Downstream_flank_oriented$Downstream_flank_end <- pmin(Downstream_flank$Downstream_flank_end,Downstream_flank$Prophage_end) #Puts lowest value between downstream flanking region end and prophage end in left-most column
Downstream_flank_oriented$Prophage_end <- pmax(Downstream_flank$Downstream_flank_end,Downstream_flank$Prophage_end) #Puts lowest value between downstream flanking region end and prophage end in left-most column



# Bind together tables and combine the starts and ends of upstream and downstream regions into the same columns
All_flanking_regions <- rbindlist(list(Upstream_flank_oriented,Downstream_flank_oriented),use.names = FALSE)
names(All_flanking_regions)[3] <- "Flank_start"
names(All_flanking_regions)[4] <- "Flank_end"


# Generate bed files for each isolate containing the contig, flanking region start, and flanking region end of both the up and downstream flanking regions.

# Make a function to write the contig, flank start, and flank end to a .bed file. 
# Change the "prophage" part of "prophage.bed" to the name of your prophage.
Write_bed  = function(DF) {
  write.table(DF[, -1],paste0(unique(DF$ï..Isolate),"prophage.bed"), sep="\t",col.names = F, row.names = F)
  return(DF)
}

# Group data by isolate (combine both up and downstream flanking regions) and run function to generate bed files.
All_flanking_regions %>% 
  group_by(ï..Isolate) %>% 
  do(Write_bed(.))
