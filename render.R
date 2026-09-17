library(tidyverse)
library(quarto)
library(fs)
library(stringr)

# ------------------------------------------------------------
# Configuration
# ------------------------------------------------------------

spreadsheet <- "data/participants.csv"
template <- "agreement.qmd"
output_dir <- "rendered_agreements"

# ------------------------------------------------------------
# Read participant data
# ------------------------------------------------------------

participants <- read_csv(spreadsheet, show_col_types = FALSE)

participants <- participants |>
  janitor::clean_names()


# ------------------------------------------------------------
# Check required columns
# ------------------------------------------------------------

required_columns <- c(
  "id",
  "name",
  "department_faculty_lab",
  "email"
)

missing_columns <- setdiff(
  required_columns,
  names(participants)
)

if (length(missing_columns) > 0) {
  stop(
    "The following required columns are missing from the spreadsheet: ",
    paste(missing_columns, collapse = ", ")
  )
}

# ------------------------------------------------------------
# Create output directory
# ------------------------------------------------------------

dir_create(output_dir)

# ------------------------------------------------------------
# Function for safe filenames
# ------------------------------------------------------------

safe_filename <- function(name) {
  name |>
    str_replace_all("[^A-Za-z0-9]+", "_") |>
    str_replace_all("^_|_$", "")
}

# ------------------------------------------------------------
# Render one agreement per participant
# ------------------------------------------------------------

for (i in seq_len(nrow(participants))) {

  p <- participants[i, ]

  id <- as.character(p$id)
  name <- as.character(p$name)

  message(
    "\nRendering agreement for ",
    name,
    " (",
    id,
    ")..."
  )

  # Filename for final PDF
  filename <- paste0(
    safe_filename(name),
    "_Open_Scholarship_Champion_Agreement.pdf"
  )

  # ----------------------------------------------------------
  # Render in the directory containing agreement.qmd
  # ----------------------------------------------------------

  quarto_render(
    input = template,
    execute_params = list(
      id = id,
      name = name,
      department_faculty_lab = as.character(p$department_faculty_lab),
      email = as.character(p$email)
    ),
    quiet = FALSE
  )

  # ----------------------------------------------------------
  # Quarto/Typst creates agreement.pdf beside agreement.qmd
  # ----------------------------------------------------------

  rendered_pdf <- path_ext_remove(template) |> paste0(".pdf")

  # Check that the PDF was actually created
  if (!file_exists(rendered_pdf)) {
    stop(
      "Quarto completed, but the expected PDF was not found: ",
      rendered_pdf
    )
  }

  # ----------------------------------------------------------
  # Move PDF to the participant output directory
  # ----------------------------------------------------------

  final_pdf <- path(output_dir, filename)

  file_move(
    rendered_pdf,
    final_pdf
  )

  message(
    "  Created: ",
    final_pdf
  )
}

message(
  "\nDone! ",
  nrow(participants),
  " participant agreements generated."
)
