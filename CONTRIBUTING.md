# Contributing to datacore

Thanks for your interest. All contributions – bug reports, documentation
fixes, new features – are welcome.

## Quick start

1.  Fork the repo and clone your fork
2.  Create a branch: `git checkout -b feat/your-thing`
3.  Make changes and add tests
4.  Run checks locally (see below)
5.  Commit using [Conventional
    Commits](https://www.conventionalcommits.org/)
6.  Open a PR against `main`

## Local checks

``` r

# Install dev dependencies
pak::pak(c("devtools", "lintr", "styler", "rcmdcheck"))

# Format code
styler::style_pkg()

# Lint
lintr::lint_package()

# Run tests
devtools::test()

# Full CRAN check
devtools::check()
```

Or via Make:

``` bash
make style   # styler
make lint    # lintr
make test    # testthat
make check   # R CMD check --as-cran
```

## Commit format

    feat: add dc_timeseries() for high-frequency data
    fix: handle null volume in HOSE OHLC response
    docs: add tidyquant integration example
    test: cover 429 retry path
    chore: bump httr2 minimum to 1.1.0

## Code style

- Follow the [tidyverse style guide](https://style.tidyverse.org/)
- `styler` enforces formatting; `lintr` catches issues
- Internal helpers go in `R/utils.R` with `@noRd`; exported functions
  get full `@param`/`@return`/`@examples` roxygen blocks
- All user-visible changes get a test in `tests/testthat/`

## Reporting issues

Please include:

- What you expected vs. what happened
- Minimal reproducible example (code +
  [`sessionInfo()`](https://rdrr.io/r/utils/sessionInfo.html) output)
- OS, R version, and package version

## License

By contributing you agree your contributions are licensed under
[MIT](https://DataCore-VietNam.github.io/datacore-r/LICENSE.md).
