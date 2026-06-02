## R CMD check results

0 errors | 0 warnings | 0 notes

## Test environments

- local: macOS (aarch64), R 4.4.x
- GitHub Actions: ubuntu-latest (R release, devel, oldrel-1)
- GitHub Actions: macOS-latest (R release)
- GitHub Actions: windows-latest (R release)
- win-builder: R devel

## Notes

This is the first CRAN submission for this package.

All examples that require a live API key are wrapped in `\dontrun{}`.
No internet access is attempted during R CMD check (network calls are
fully intercepted by `httptest2` in the test suite).
