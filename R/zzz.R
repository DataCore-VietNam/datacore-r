.onAttach <- function(libname, pkgname) {
  ver <- utils::packageVersion("datacore")
  packageStartupMessage(
    sprintf("datacore %s - Vietnamese financial data. ", ver),
    "Set DATACORE_API_KEY or pass api_key to datacore_client().\n",
    "Docs: https://datacore-vietnam.github.io/datacore-r/"
  )
}
