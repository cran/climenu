## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE  # Set to FALSE since interactive examples can't run in vignettes
)

## ----setup--------------------------------------------------------------------
# library(climenu)

## ----install, eval=FALSE------------------------------------------------------
# # Install from CRAN
# install.packages("climenu")

## ----single-basic-------------------------------------------------------------
# # Basic single selection
# colors <- c("Red", "Green", "Blue", "Yellow", "Purple")
# choice <- menu(colors, prompt = "Choose your favorite color:")
# 
# # The user navigates with arrow keys (↑/↓) or vi keys (j/k)
# # Press Enter to select
# # Returns: "Blue" (for example)

## ----select-direct------------------------------------------------------------
# choice <- select(
#   choices = c("Yes", "No", "Maybe"),
#   prompt = "Do you agree?"
# )

## ----checkbox-basic-----------------------------------------------------------
# # Using menu() with checkbox type
# toppings <- c("Pepperoni", "Mushrooms", "Olives", "Onions", "Extra Cheese")
# selected <- menu(
#   toppings,
#   type = "checkbox",
#   prompt = "Select pizza toppings:"
# )
# 
# # Or use checkbox() directly
# selected <- checkbox(
#   choices = toppings,
#   prompt = "Select pizza toppings:"
# )
# 
# # User navigates with arrow keys, toggles with Space, confirms with Enter
# # Returns: c("Pepperoni", "Extra Cheese", "Mushrooms")

## ----preselect-value----------------------------------------------------------
# # Pre-select by value
# selected <- checkbox(
#   choices = c("Option A", "Option B", "Option C", "Option D"),
#   selected = c("Option A", "Option C"),
#   prompt = "Modify your selection:"
# )
# # Options A and C will be checked initially

## ----preselect-index----------------------------------------------------------
# # Pre-select by index
# selected <- checkbox(
#   choices = c("Option A", "Option B", "Option C", "Option D"),
#   selected = c(1, 3),  # First and third items
#   prompt = "Modify your selection:"
# )

## ----preselect-single---------------------------------------------------------
# # Start with cursor on the second option
# choice <- select(
#   choices = c("Small", "Medium", "Large"),
#   selected = 2,  # or "Medium"
#   prompt = "Select size:"
# )

## ----return-index-------------------------------------------------------------
# # Single selection - returns integer
# index <- select(
#   choices = c("First", "Second", "Third"),
#   return_index = TRUE
# )
# # Returns: 2 (if user selected "Second")
# 
# # Multiple selection - returns integer vector
# indices <- checkbox(
#   choices = c("Alpha", "Beta", "Gamma", "Delta"),
#   return_index = TRUE
# )
# # Returns: c(1, 3, 4) (if user selected Alpha, Gamma, Delta)

## ----select-all---------------------------------------------------------------
# # Enable the "Select all" option
# methods <- checkbox(
#   choices = c("method_a", "method_b", "method_c", "method_d"),
#   allow_select_all = TRUE,
#   prompt = "Select methods to run:"
# )
# # The first item in the menu will be "Select all" / "Deselect all"
# # It toggles all items at once and is never included in the result

## ----config-wizard------------------------------------------------------------
# # Ask user to configure application settings
# cat("\n=== Application Configuration ===\n")
# 
# # Choose environment
# env <- select(
#   choices = c("Development", "Staging", "Production"),
#   prompt = "Select environment:"
# )
# 
# # Enable features
# features <- checkbox(
#   choices = c("Logging", "Caching", "Analytics", "Debug Mode"),
#   selected = c("Logging", "Caching"),  # Sensible defaults
#   prompt = "Enable features:"
# )
# 
# # Choose log level
# log_level <- select(
#   choices = c("ERROR", "WARN", "INFO", "DEBUG", "TRACE"),
#   selected = "INFO",
#   prompt = "Select log level:"
# )
# 
# # Build configuration
# config <- list(
#   environment = env,
#   features = features,
#   log_level = log_level
# )
# 
# cat("\nConfiguration complete!\n")
# print(config)

## ----data-pipeline------------------------------------------------------------
# # Select datasets to process
# available_datasets <- c(
#   "sales_2023.csv",
#   "sales_2024.csv",
#   "customers.csv",
#   "products.csv",
#   "inventory.csv"
# )
# 
# datasets <- checkbox(
#   choices = available_datasets,
#   prompt = "Select datasets to process:"
# )
# 
# if (is.null(datasets)) {
#   cat("Processing cancelled.\n")
# } else {
#   # Choose processing method
#   method <- select(
#     choices = c("Fast (approximate)", "Standard", "Thorough (slow)"),
#     prompt = "Select processing method:"
#   )
# 
#   cat("\nProcessing", length(datasets), "datasets using", method, "method...\n")
#   # ... processing logic here ...
# }

## ----file-indices-------------------------------------------------------------
# # Get list of files
# files <- list.files(pattern = "\\.csv$")
# 
# if (length(files) == 0) {
#   cat("No CSV files found.\n")
# } else {
#   # Let user select files, get indices
#   indices <- checkbox(
#     choices = files,
#     return_index = TRUE,
#     prompt = "Select files to delete:"
#   )
# 
#   if (!is.null(indices) && length(indices) > 0) {
#     files_to_delete <- files[indices]
# 
#     # Confirm deletion
#     confirm <- select(
#       choices = c("Yes, delete them", "No, cancel"),
#       prompt = paste("Delete", length(files_to_delete), "file(s)?")
#     )
# 
#     if (confirm == "Yes, delete them") {
#       file.remove(files_to_delete)
#       cat("Deleted", length(files_to_delete), "file(s).\n")
#     }
#   }
# }

## ----handle-null--------------------------------------------------------------
# choice <- select(c("Continue", "Skip", "Abort"))
# 
# if (is.null(choice)) {
#   cat("User cancelled the operation.\n")
#   # Handle cancellation appropriately
#   stop("Operation cancelled by user")
# }
# 
# # Safe to proceed with choice
# cat("User selected:", choice, "\n")

## ----non-interactive----------------------------------------------------------
# # This will work in both interactive and non-interactive modes
# choice <- select(
#   choices = c("Option 1", "Option 2", "Option 3"),
#   selected = 1  # Fallback for non-interactive
# )
# 
# # In non-interactive mode: issues warning and returns "Option 1"
# # In interactive mode: shows menu and waits for user input

## ----package-example----------------------------------------------------------
# #' Interactive configuration function
# #' @export
# configure_analysis <- function() {
#   # Check if interactive
#   if (!interactive()) {
#     cli::cli_inform("Using default configuration (non-interactive mode)")
#     return(get_default_config())
#   }
# 
#   # Show interactive menu
#   method <- climenu::select(
#     choices = c("Linear Model", "Random Forest", "Neural Network"),
#     prompt = "Select analysis method:"
#   )
# 
#   if (is.null(method)) {
#     cli::cli_abort("Configuration cancelled by user")
#   }
# 
#   # ... rest of configuration logic ...
# 
#   return(config)
# }

