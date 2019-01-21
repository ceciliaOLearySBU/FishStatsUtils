
#.onLoad <- function(libname, pkgname) {
#}

.onAttach <- function(libname, pkgname) {
  if( !"INLA" %in% utils::installed.packages()[,1] ){
    packageStartupMessage("Installing package: INLA...")
    #utils::install.packages("INLA", repos="https://www.math.ntnu.no/inla/R/stable")
    utils::install.packages("INLA", repos=c(getOption("repos"), INLA="https://inla.r-inla-download.org/R/stable"), dep=TRUE)
  }
  packageStartupMessage("Installing dependencies while setting repos...")
  Dep = c(
    "graphics",
    "utils",
    "mapproj",
    "maptools",
    "deldir",
    "PBSmapping",
    "RANN",
    "stats",
    "colorspace",
    "RandomFields",
    "RandomFieldsUtils",
    "shape",
    "devtools",
    "mixtools",
    "sp",
    "maps",
    "mapdata",
    "TMB",
    "MatrixModels",
    "rgdal",
    "abind",
    "corpcor",
    "pander",
    "formatR"
  )
  utils::install.packages( pkgs=Dep, repos='http://cran.us.r-project.org' )
  #if( !"TMB" %in% utils::installed.packages()[,1] ){
  #  packageStartupMessage("Installing TMB...")
  #  devtools::install_github("kaskr/adcomp/TMB")
  #}
  if( !"TMBhelper" %in% utils::installed.packages()[,1] ){
    packageStartupMessage("Installing package: TMBhelper...")
    devtools::install_github("kaskr/TMB_contrib_R/TMBhelper")
  }
  if( !"ThorsonUtilities" %in% utils::installed.packages()[,1] ){
    packageStartupMessage("Installing package: ThorsonUtilities...")
    devtools::install_github("james-thorson/utilities")
  }
}
