% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fit_model.R
\name{fit_model}
\alias{fit_model}
\title{Fit VAST to data}
\usage{
fit_model(settings, Lat_i, Lon_i, t_iz, c_iz, b_i, a_i, v_i = rep(0,
  length(b_i)), working_dir = paste0(getwd(), "/"), Xconfig_zcp = NULL,
  X_gtp = NULL, X_itp = NULL, Q_ik = NULL, newtonsteps = 1,
  extrapolation_args = list(), spatial_args = list(),
  optimize_args = list(), model_args = list(), silent = TRUE,
  run_model = TRUE, test_fit = TRUE, ...)
}
\arguments{
\item{settings}{Output from \code{make_settings}}

\item{Lat_i}{Latitude for each sample}

\item{Lon_i}{Longitude for each sample}

\item{t_iz}{Matrix where each row species the time for each observation i (if t_iz is a vector, it is coerced to a matrix with one column; if it is a matrix with two or more columns, it specifies multiple times for each observation, e.g., both year and season)}

\item{c_iz}{Category (e.g., species, length-bin) for each observation i}

\item{b_i}{Sampled biomass for each observation i}

\item{a_i}{Sampled area for each observation i}

\item{v_i}{OPTIONAL, sampling category (e.g., vessel or tow) associated with overdispersed variation for each observation i}

\item{Xconfig_zcp}{OPTIONAL, 3D array of settings for each dynamic density covariate, where the first dimension corresponds to 1st or 2nd linear predictors, second dimension corresponds to model category, and third dimension corresponds to each density covariate
\describe{
  \item{Xconfig_zcp[z,c,p]=0}{\code{X_itp[,,p]} has no effect on linear predictor z for category c}
  \item{Xconfig_zcp[z,c,p]=1}{\code{X_itp[,,p]} has a linear effect on linear predictor z for category c}
  \item{Xconfig_zcp[z,c,p]=2}{\code{X_itp[,,p]} has a spatially varying, zero-centered linear effect on linear predictor z for category c}
  \item{Xconfig_zcp[z,c,p]=3}{\code{X_itp[,,p]} has a spatially varying linear effect on linear predictor z for category c}
}}

\item{X_gtp}{array of density covariates for each extrapolation-grid cell g, time t, and covariate p; if missing, assumed to not include covariates}

\item{X_itp}{array of density covariates for each extrapolation-grid cell i, time t, and covariate p}

\item{Q_ik}{matrix of catchability covariates (e.g., measured variables affecting catch rates but not caused by variation in species density) for each observation i}

\item{newtonsteps}{number of extra newton steps to take after optimization (alternative to \code{loopnum})}

\item{extrapolation_args}{tagged list of optional arguments to pass to \code{FishStatsUtils::make_extrapolation_info}}

\item{spatial_args}{tagged list of optional arguments to pass to \code{FishStatsUtils::make_spatial_info}}

\item{optimize_args}{tagged list of optional arguments to pass to \code{TMBhelper::Optimize}}

\item{model_args}{tagged list of optional arguments to pass to \code{VAST::make_model}}

\item{run_model}{Boolean indicating whether to run the model or simply return the inputs and built TMB object}

\item{test_fit}{Boolean indicating whether to apply \code{VAST::check_fit} before calculating standard errors, to test for parameters hitting bounds etc; defaults to TRUE}

\item{...}{additional parameters to pass to \code{VAST::make_data}}
}
\value{
Returns a tagged list of internal objects, the TMB object, and slot \code{parameter_estimates} containing the MLE estimates
}
\description{
\code{fit_model} fits a spatio-temporal model to data
}
\details{
This function is the user-interface for the functions that determine the extrapolation-grid, define spatial objects, assemble data, build model, and estimate parameters.
}
\examples{
\dontrun{
# Load packages
library(TMB)
library(VAST)

# load data set
# see `?load_example` for list of stocks with example data
# that are installed automatically with `FishStatsUtils`.
example = load_example( data_set="EBS_pollock" )

# Make settings
settings = make_settings( n_x=50, Region=example$Region, purpose="index",
  strata.limits=example$strata.limits )

# Run model
fit = fit_model( "settings"=settings, "Lat_i"=example$sampling_data[,'Lat'],
  "Lon_i"=example$sampling_data[,'Lon'], "t_i"=example$sampling_data[,'Year'],
  "c_i"=rep(0,nrow(example$sampling_data)), "b_i"=example$sampling_data[,'Catch_KG'],
  "a_i"=example$sampling_data[,'AreaSwept_km2'], "v_i"=example$sampling_data[,'Vessel'] )

# Plot results
plot_results( settings=settings, fit=fit )
}

}
\seealso{
\code{?VAST} for general documentation, \code{?make_settings} for generic settings, \code{?fit_model} for model fitting, and \code{?plot_results} for generic plots

Other wrapper functions: \code{\link{make_settings}},
  \code{\link{plot_results}}
}
\concept{wrapper functions}
