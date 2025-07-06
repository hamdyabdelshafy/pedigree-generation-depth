# Calculate Pedigree Generation Depth in R

This R script calculates the **number of generations** in pedigree data for livestock or other animals. It is designed for users with **no prior programming experience**, and includes both an example dataset and instructions for using your own data from Excel.

---
### Author: **Hamdy Abdel-Shafy**  
### Date: July 2025  
### Affiliation: Department of Animal Production, Faculty of Agriculture, Cairo University
---

This GitHub repository contains **two R scripts** for calculating the **generation depth** in pedigree data for livestock or other animals.
Both scripts are designed to assist **users with little or no programming experience**, but they differ in complexity and application:

## 📂 Available Scripts

### 1. `simple_pedigree_generation.R`  ✅ *Beginner Friendly*

This script is ideal for learning and basic testing. It includes:
- A small, built-in example pedigree.
- Step-by-step construction of a pedigree object.
- Recursive calculation of generation depth.
- Easy-to-follow structure with inline comments.

**Recommended if you're just getting started.**

---

### 2. `pedigree_generation_realData.R` 🔍 *Advanced / Real Data Ready*

This script extends the functionality to work with **real-world pedigree data** (e.g., from farm records or breeding programs), and includes robust handling of:
- Excel file import (`ped_milkData.xlsx`)
- Missing parent IDs (e.g., dams or sires that are not listed as animals)
- Pedigree reordering (ensures that parents precede offspring, as required by `pedigreemm`)

**Use this version if you're working with actual data files, especially when:**
- Some sires or dams are not initially listed in the dataset.
- Parent-offspring records are out of order.
- Your data comes from Excel and uses `"0"` or empty cells for unknown parents.

---

## 📦 Requirements

- R (version 3.5 or higher recommended)
- R packages:
  - [`pedigreemm`](https://cran.r-project.org/package=pedigreemm)
  - [`readxl`](https://cran.r-project.org/package=readxl) – for reading Excel files
  - [`igraph`](https://cran.r-project.org/package=igraph) – for pedigree sorting

To install all required packages, run:

```r
install.packages(c("pedigreemm", "readxl", "igraph"))
````

---

## 📜 What the Script(s) Do

* Load or build a pedigree data frame
* Construct a pedigree object using the `pedigreemm` package
* Optionally sort real data so that all sires and dams precede offspring
* Automatically add missing parents if not listed in the animal column
* Compute the **generation depth** of each animal using a recursive function
* Output:

  * A table showing the generation number for each animal
  * The **maximum number of generations**
  * A summary of how many animals exist per generation

---

## 🧪 Example Pedigree (used in the simple version)

| Animal | Sire | Dam |
| ------ | ---- | --- |
| A      | —    | —   |
| B      | —    | —   |
| C      | A    | B   |
| D      | A    | B   |
| E      | C    | D   |
| F      | C    | D   |

This forms a 3-level (2-generation) pedigree:

* **Generation 0**: A, B (founders)
* **Generation 1**: C, D (offspring of founders)
* **Generation 2**: E, F (grand-offspring)

---

## 📁 Using Your Own Data

Both scripts can be adapted to use your own pedigree file.

### Format guidelines:

* Must include columns: `animal`, `sire`, and `dam`
* Use `NA`, `"0"`, or blank cells for unknown parents
* Ensure parent IDs match exactly with animal IDs (no extra spaces or inconsistent formatting)
* Avoid mixing numbers and text (e.g., use `"101"` consistently, not `"101 "` or `"A101"`)

### File types supported:

* `.csv` (for the simple script)
* `.xlsx` (for the real-data script)

### Example for reading your data:

```r
# For CSV
your_ped <- read.csv("my_pedigree.csv", na.strings = c("", "NA", "0"))

# For Excel (real-data script)
library(readxl)
your_ped <- read_excel("ped_milkData.xlsx")
your_ped[your_ped == "0"] <- NA
```

---

## 💬 Output Example

```r
  animal generation
1      A          0
2      B          0
3      C          1
4      D          1
5      E          2
6      F          2

Maximum number of generations in the dataset: 2

Distribution of animals per generation:
0 1 2 
2 2 2
```

---

## 📄 License

This script is licensed under the [MIT License](LICENSE).
