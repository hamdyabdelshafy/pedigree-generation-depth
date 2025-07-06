# Calculate Pedigree Generation Depth in R

This R script calculates the **number of generations** in pedigree data for livestock or other animals. It is designed for users with **no prior programming experience**, and includes both an example dataset and instructions for using your own data from Excel or CSV files.

---
### Author: **Hamdy Abdel-Shafy**  
### Date: July 2025  
### Affiliation: Department of Animal Production, Faculty of Agriculture, Cairo University
---

## 📦 Requirements

- R (version 3.5 or higher recommended)
- R package: [`pedigreemm`](https://cran.r-project.org/package=pedigreemm)

To install the package, run:

```r
install.packages("pedigreemm")
```

---

## 📜 What the Script Does

- Loads or builds a pedigree data frame.
- Constructs a pedigree object using the `pedigreemm` package.
- Converts internal pedigree indices to actual animal IDs.
- Computes the **generation depth** of each animal recursively.
- Outputs:
  - A table showing the generation number for each animal.
  - The **maximum number of generations** in the dataset.
  - A summary of how many animals exist in each generation.

---

## 🧪 Example Pedigree

The script starts with an example of 6 animals:

| Animal | Sire | Dam |
|--------|------|-----|
| A      | —    | —   |
| B      | —    | —   |
| C      | A    | B   |
| D      | A    | B   |
| E      | C    | D   |
| F      | C    | D   |

This forms a 3-level (2-generation) pedigree:
- **Generation 0**: A, B (founders)
- **Generation 1**: C, D (offspring of founders)
- **Generation 2**: E, F (grand-offspring)

---

## 📁 Using Your Own Data

To use your own pedigree file:

1. Prepare a CSV file with **three columns**:
   - `animal`
   - `sire`
   - `dam`

2. Format guidelines:
   - Use `NA` or leave blank for unknown parents.
   - Ensure animal IDs are consistent and match between offspring and parents.
   - Every known sire or dam **must also appear in the animal column**.
   - Avoid mixing numbers and characters inconsistently (e.g., don’t use "001" in one place and "1" elsewhere).

3. Example row:
   ```
   animal,sire,dam
   E,C,D
   ```

4. Load the file in R using:

```r
your_ped <- read.csv("path/to/your/file.csv", na.strings = c("", "NA"))
ped <- your_ped
```

Then continue from Step 3 in the script.

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
