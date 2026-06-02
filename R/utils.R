# Internal utilities for the datacore package.

#' Convert a list-of-lists (JSON array of objects) to a tibble.
#'
#' Handles ragged records by filling missing fields with `NA`, preserves column
#' order from the first row that contains each field, and gracefully returns an
#' empty tibble when the input is empty or `NULL`.
#'
#' @keywords internal
#' @noRd
records_to_tibble <- function(x) {
  if (is.null(x) || length(x) == 0L) {
    return(tibble::tibble())
  }
  if (!is.list(x)) {
    rlang::abort("Expected a list of records from the API.")
  }

  # If the API already returned a tabular structure with named columns,
  # pass it straight through.
  if (!is.null(names(x)) && all(nzchar(names(x))) && !any(vapply(x, is.list, logical(1L)))) {
    return(tibble::as_tibble(x))
  }

  # Collect union of column names, preserving order of first appearance.
  all_names <- character()
  for (rec in x) {
    if (is.list(rec)) {
      nm <- names(rec)
      if (!is.null(nm)) {
        all_names <- c(all_names, setdiff(nm, all_names))
      }
    }
  }
  if (length(all_names) == 0L) {
    return(tibble::tibble())
  }

  cols <- lapply(all_names, function(nm) {
    vals <- lapply(x, function(rec) {
      v <- rec[[nm]]
      if (is.null(v)) NA else v
    })
    simplify_column(vals)
  })
  names(cols) <- all_names
  tibble::as_tibble(cols)
}

simplify_column <- function(vals) {
  # If any element is a list/structure, keep as list-column.
  is_atomic <- vapply(
    vals,
    function(v) is.null(v) || (is.atomic(v) && length(v) <= 1L),
    logical(1L)
  )
  if (!all(is_atomic)) {
    return(vals)
  }
  # Replace NULLs with NA so unlist preserves length.
  vals <- lapply(vals, function(v) if (is.null(v) || length(v) == 0L) NA else v)
  # Use common type via c().
  out <- tryCatch(do.call(c, vals), error = function(e) NULL)
  if (is.null(out) || length(out) != length(vals)) {
    return(vals)
  }
  out
}

# Format a vector of symbols for the `symbols=` query param (comma-separated).
format_symbols <- function(symbols) {
  if (is.null(symbols)) return(NULL)
  if (!is.character(symbols)) {
    symbols <- as.character(symbols)
  }
  symbols <- symbols[nzchar(symbols)]
  if (length(symbols) == 0L) return(NULL)
  paste(symbols, collapse = ",")
}

# Format a date-like value to ISO yyyy-mm-dd. Accepts Date, POSIXt, or character.
format_date <- function(x, arg = "date") {
  if (is.null(x)) return(NULL)
  if (inherits(x, "Date")) return(format(x, "%Y-%m-%d"))
  if (inherits(x, "POSIXt")) return(format(x, "%Y-%m-%d"))
  if (is.character(x) && length(x) == 1L) return(x)
  rlang::abort(sprintf("`%s` must be a Date, POSIXt, or yyyy-mm-dd string.", arg))
}
