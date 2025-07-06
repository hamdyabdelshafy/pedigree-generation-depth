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

# STEP 1: Install and load required package (only once)
# If already installed, this will be skipped automatically
install.packages("pedigreemm")
library(pedigreemm)

# ------------------------------------------------------------
# STEP 2: Example data (you can delete this later and use your own)
# Sample pedigree with 6 animals
# A and B have no known parents → founders
# C and D are their offspring
# E and F are offspringof C and D → 3 generations total

ped <- data.frame(
  animal = c("A", "B", "C", "D", "E", "F"),
  sire   = c(NA, NA, "A", "A", "C", "C"),
  dam    = c(NA, NA, "B", "B", "D", "D"),
  stringsAsFactors = FALSE
)

# ------------------------------------------------------------
# STEP 3: Build pedigree object
ped_obj <- with(ped, pedigree(sire = sire, dam = dam, label = animal))

# ------------------------------------------------------------
# STEP 4: Extract pedigree components (required for generation function)
# Lookup table: internal ID → label
id_map <- setNames(ped$animal, as.character(1:nrow(ped)))

# Convert sire/dam from numeric IDs back to animal names
sire_ids <- as.character(ped_obj@sire)
dam_ids  <- as.character(ped_obj@dam)

sire_vec <- id_map[sire_ids]
dam_vec  <- id_map[dam_ids]

# Assign names (animal labels)
names(sire_vec) <- ped$animal
names(dam_vec)  <- ped$animal
label_vec <- ped$animal


# ------------------------------------------------------------
# STEP 5: Function to compute generation depth for each animal
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

# ------------------------------------------------------------
# STEP 6: Run the function and get generation info
generation_info <- get_generation_depth(label_vec, sire_vec, dam_vec)

# Show generation info
print(generation_info)

# Show maximum generation number in the data
max_generation <- max(generation_info$generation, na.rm = TRUE)
cat("\nMaximum number of generations in the dataset:", max_generation, "\n")

# ------------------------------------------------------------
# STEP 7 (OPTIONAL): View how many animals exist per generation
cat("\nDistribution of animals per generation:\n")
print(table(generation_info$generation))

#################################################################
# OPTIONAL: Using your own pedigree file (Excel or CSV)
# -------------------------------------------------------------
# 1. Prepare your file as a CSV or Excel file (CSV is easier).
# 2. It must have 3 columns: "animal", "sire", "dam"
# 3. Use blank cells or "NA" for unknown parents
# 4. Save as: my_pedigree.csv

# If your data is in a CSV file:
# --------------------------------
# library(readr)   # if not installed: install.packages("readr")
# your_ped <- read_csv("path/to/your/my_pedigree.csv")

# Or using base R:
# your_ped <- read.csv("path/to/your/my_pedigree.csv", na.strings = c("", "NA"))

# Then replace the sample data:
# ped <- your_ped

# and repeat Steps 3 to 6.

# --> Advice on formatting your data:
# - Column names must be: animal, sire, dam (all lowercase recommended)
# - IDs must be consistent (e.g., no space before or after names)
# - Use empty cells or NA for missing parents
# - All parents must also appear in the animal column if known
# - Don't use numeric-only IDs if some IDs contain letters

#################################################################
# END OF SCRIPT
#################################################################
