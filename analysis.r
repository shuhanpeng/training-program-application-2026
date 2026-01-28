# ---------------------------------------------------------

# Melbourne Bioinformatics Training Program

# This exercise to assess your familiarity with R and git. Please follow
# the instructions on the README page and link to your repo in your application.
# If you do not link to your repo, your application will be automatically denied.

# Leave all code you used in this R script with comments as appropriate.
# Let us know if you have any questions!


# You can use the resources available on our training website for help:
# Intro to R: https://mbite.org/intro-to-r
# Version Control with Git: https://mbite.org/intro-to-git/

# ----------------------------------------------------------

# Load libraries -------------------
# You may use base R or tidyverse for this exercise

# ex. library(tidyverse)
library(tidyverse)
library(dplyr)
library(ggplot2)

# Load data here ----------------------
# Load each file with a meaningful variable name.
# file paths
metadata_file <- "~/Library/CloudStorage/OneDrive-TheUniversityofMelbourne/git/training-program-application-2026/data/GSE60450_filtered_metadata.csv"
expression_file <- "~/Library/CloudStorage/OneDrive-TheUniversityofMelbourne/git/training-program-application-2026/data/GSE60450_GeneLevel_Normalized(CPM.and.TMM)_data.csv"
results_dir <- "~/Library/CloudStorage/OneDrive-TheUniversityofMelbourne/git/training-program-application-2026/results"

# Load data
metadata <- read.csv(metadata_file)
colnames(metadata)[c(1, 4)] <- c("sample_id", "developmental_stage")
gene_expression <- read.csv(expression_file)
colnames(gene_expression)[1] <- "ensembl_gene_id"

# Inspect the data -------------------------

# What are the dimensions of each data set? (How many rows/columns in each?)
# Keep the code here for each file.

## Expression data
dim(gene_expression)
nrow(gene_expression) # number of rows
ncol(gene_expression) # number of columns

## Metadata
dim(metadata)

# Prepare/combine the data for plotting ------------------------
# How can you combine this data into one data.frame?
# expression data to long format
expression_long <- gene_expression %>%
  pivot_longer(cols = -c(ensembl_gene_id, gene_symbol),
               names_to = "sample_id",
               values_to = "expression")
# check sample ids match
all(colnames(gene_expression)[-c(1,2)] %in% metadata$sample_id)
# combine with metadata
combined_data <- expression_long %>%
  left_join(metadata, by = "sample_id")

# Plot the data --------------------------
## Plot the expression by cell type
## Can use boxplot() or geom_boxplot() in ggplot2
p <- ggplot(combined_data, aes(x = immunophenotype, y = expression)) +
  geom_boxplot() +
  labs(title = paste("Expression by cell type"),
       x = "Cell type",
       y = "Expression (CPM, TMM-normalised)") +
  theme_bw()

## Save the plot
### Show code for saving the plot with ggsave() or a similar function
pdf_file <- file.path(results_dir, "expression_by_celltype_boxplot.pdf")
ggsave(filename = pdf_file, plot = p, width = 12, height = 8)