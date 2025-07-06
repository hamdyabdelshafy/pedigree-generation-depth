###############################################################
# R SCRIPT: Calculate Number of Generations in Pedigree Data  #
# ----------------------------------------------------------- #
# This script builds a pedigree, calculates generation depth, #
# and tells you the maximum number of generations in the data #
#                                                             #
# NO PROGRAMMING EXPERIENCE IS REQUIRED                       #
#                                                             #
# Author: Hamdy Abdel-Shafy                                   #
###############################################################

### STEP 1: Install and load required packages
# Only needed once — R will skip if already installed
install.packages("pedigreemm")
install.packages("readxl")
install.packages("igraph")

library(pedigreemm)
library(readxl)
library(igraph)

### STEP 2: Load your own pedigree data from Excel
# -----------------------------------------------------------
# File name must be: ped_milkData.xlsx (in your working directory)
# Required columns (case-sensitive): animal, sire, dam
# Notes:
# - Use "0" or blank for unknown sire/dam → will be converted to NA
# - All known sires and dams must appear in the 'animal' column

# Read the Excel file (first sheet by default)
ped <- read_excel("ped_milkData.xlsx")

# Replace any "0" entries with NA (indicating unknown parentage)
ped[ped == "0"] <- NA

# Convert all columns to character for consistency
ped <- as.data.frame(lapply(ped, as.character), stringsAsFactors = FALSE)

# View the first few rows
head(ped)

### STEP 2.1: Ensure all parents exist in the 'animal' column
# -----------------------------------------------------------
# Any known sire/dam not listed as an animal will cause an error.
# This section adds missing parents as founders (with unknown ancestry).

all_parents <- unique(c(ped$sire, ped$dam))
all_parents <- setdiff(all_parents, NA)
missing_parents <- setdiff(all_parents, ped$animal)

if (length(missing_parents) > 0) {
  missing_df <- data.frame(
    animal = missing_parents,
    sire = NA,
    dam = NA,
    stringsAsFactors = FALSE
  )
  ped <- rbind(ped, missing_df)
  cat("✅ Missing parent IDs were added to the pedigree.\n")
}

cat("✅ Total number of animals in pedigree after fixing:", nrow(ped), "\n")

### STEP 2.2: Reorder pedigree (parents before offspring)
# -----------------------------------------------------------
# This is REQUIRED by the 'pedigree()' function from the pedigreemm package.

edges <- na.omit(data.frame(
  from = c(ped$sire, ped$dam),
  to = c(ped$animal, ped$animal),
  stringsAsFactors = FALSE
))

g <- graph_from_data_frame(edges, directed = TRUE)
sorted_ids <- topo_sort(g, mode = "out")  # Ensures parents come before offspring
sorted_ids <- as_ids(sorted_ids)

# Reorder the pedigree rows accordingly
ped <- ped[match(sorted_ids, ped$animal), ]

cat("✅ Pedigree reordered successfully (parents precede offspring).\n")

### STEP 3: Build pedigree object
# -----------------------------------------------------------
ped_obj <- with(ped, pedigree(sire = sire, dam = dam, label = animal))

### STEP 4: Extract pedigree components (needed for next step)
# -----------------------------------------------------------
# Create lookup to map internal pedigree IDs back to animal labels
id_map <- setNames(ped$animal, as.character(1:nrow(ped)))

sire_ids <- as.character(ped_obj@sire)
dam_ids  <- as.character(ped_obj@dam)

sire_vec <- id_map[sire_ids]
dam_vec  <- id_map[dam_ids]

names(sire_vec) <- ped$animal
names(dam_vec)  <- ped$animal
label_vec <- ped$animal

### STEP 5: Function to calculate generation depth
# -----------------------------------------------------------
# This function works recursively. Founders (no parents) = generation 0

get_generation_depth <- function(label_vec, sire_vec, dam_vec) {
  gen_depth <- setNames(rep(NA, length(label_vec)), label_vec)

  compute_depth <- function(animal) {
    if (!is.na(gen_depth[animal])) return(gen_depth[animal])
    
    sire <- sire_vec[animal]
    dam  <- dam_vec[animal]

    if (is.na(sire) && is.na(dam)) {
      gen_depth[animal] <<- 0
    } else {
      sire_depth <- if (!is.na(sire)) compute_depth(sire) else -1
      dam_depth  <- if (!is.na(dam))  compute_depth(dam)  else -1
      gen_depth[animal] <<- max(sire_depth, dam_depth) + 1
    }

    return(gen_depth[animal])
  }

  for (animal in label_vec) {
    compute_depth(animal)
  }

  return(data.frame(animal = label_vec, generation = gen_depth[label_vec]))
}

### STEP 6: Apply the function and view results
# -----------------------------------------------------------
generation_info <- get_generation_depth(label_vec, sire_vec, dam_vec)

# View generation assigned to each animal
print(generation_info)

# Get the maximum generation depth
max_generation <- max(generation_info$generation, na.rm = TRUE)
cat("\n Maximum number of generations in the dataset:", max_generation, "\n")

# Optional summary: animals per generation
cat("\n Distribution of animals per generation:\n")
print(table(generation_info$generation))

###############################################################
# END OF SCRIPT                                               #
###############################################################
