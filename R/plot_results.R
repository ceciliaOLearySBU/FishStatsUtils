
#' Plot results
#'
#' \code{plot_results} plots diagnostics, results, and indices for a given fitted model
#'
#' This function takes a fitted VAST model and generates a standard set of diagnostic and visualization plots.
#'
#' @param fit Output from \code{fit_model}
#' @inheritParams fit_model
#' @inheritParams plot_maps
#' @param ... additional settings to pass to \code{FishStatsUtils::plot_maps}
#'
#' @return Invisibly returns a tagged list of outputs generated by standard plots.
#'
#' @family wrapper functions
#' @seealso \code{?VAST} for general documentation, \code{?make_settings} for generic settings, \code{?fit_model} for model fitting, and \code{?plot_results} for generic plots
#'
#' @export
plot_results = function( fit, settings, plot_set=3, working_dir=paste0(getwd(),"/"),
  year_labels=fit$year_labels, years_to_plot=fit$years_to_plot, use_biascorr=TRUE, map_list, ... ){

  # Local function -- combine two lists
  combine_lists = function( default, input ){
    output = default
    for( i in seq_along(input) ){
      if( names(input)[i] %in% names(default) ){
        output[[names(input)[i]]] = input[[i]]
      }else{
        output = c( output, input[i] )
      }
    }
    return( output )
  }

  # Make directory
  dir.create(working_dir, showWarnings=FALSE, recursive=TRUE)

  # plot data
  #plot_data(Extrapolation_List=fit$extrapolation_list, Spatial_List=fit$spatial_list, Data_Geostat=Data_Geostat, PlotDir=working_dir )

  # PLot settings
  if( missing(map_list) ){
    message("\n### Obtaining default settings for plotting maps")
    map_list = make_map_info( "Region"=settings$Region, "spatial_list"=fit$spatial_list, "Extrapolation_List"=fit$extrapolation_list )
  }

  # Plot diagnostic for encounter probability
  message("\n### Making plot of encounter probability")
  Enc_prob = plot_encounter_diagnostic( Report=fit$Report, Data_Geostat=cbind("Catch_KG"=fit$data_frame[,'b_i']), DirName=working_dir)

  # Plot anisotropy
  message("\n### Making plot of anisotropy")
  plot_anisotropy( FileName=paste0(working_dir,"Aniso.png"), Report=fit$Report, TmbData=fit$data_list )

  # Plot index
  message("\n### Making plot of abundance index")
  Index = plot_biomass_index( DirName=working_dir, TmbData=fit$data_list, Sdreport=fit$parameter_estimates$SD, Year_Set=year_labels,
    Years2Include=years_to_plot, use_biascorr=use_biascorr )

  # Plot range indices
  message("\n### Making plot of spatial indices")
  plot_range_index(Report=fit$Report, TmbData=fit$data_list, Sdreport=fit$parameter_estimates$SD, Znames=colnames(fit$data_list$Z_xm),
    PlotDir=working_dir, Year_Set=year_labels, use_biascorr=use_biascorr )

  # Plot densities
  message("\n### Making plot of densities")
  plot_args = list(...)
  plot_args = combine_lists( input=plot_args, default=list(plot_set=plot_set, MappingDetails=map_list[["MappingDetails"]], Report=fit$Report, Sdreport=fit$parameter_estimates$SD,
    PlotDF=map_list[["PlotDF"]], MapSizeRatio=map_list[["MapSizeRatio"]], Xlim=map_list[["Xlim"]], Ylim=map_list[["Ylim"]], FileName=working_dir,
    Year_Set=year_labels, Years2Include=years_to_plot, Rotate=map_list[["Rotate"]], Cex=map_list[["Cex"]], Legend=map_list[["Legend"]],
    zone=map_list[["Zone"]], mar=c(0,0,2,0), oma=c(3.5,3.5,0,0), cex=1.8, plot_legend_fig=FALSE) )
  Dens_xt = do.call( what=plot_maps, args=plot_args )

  # Plot quantile-quantile plot
  message("\n### Making Q-Q plot")
  Q = plot_quantile_diagnostic( TmbData=fit$data_list, Report=fit$Report, FileName_PP="Posterior_Predictive",
    FileName_Phist="Posterior_Predictive-Histogram", FileName_QQ="Q-Q_plot", FileName_Qhist="Q-Q_hist", save_dir=working_dir )

  # Pearson residuals
  if( "n_x" %in% names(fit$data_list) ){
    message("\n### Making plot of Pearson residuals")
    plot_residuals(Lat_i=fit$data_frame[,'Lat_i'], Lon_i=fit$data_frame[,'Lon_i'], TmbData=fit$data_list, Report=fit$Report,
      Q=Q, savedir=working_dir, MappingDetails=map_list[["MappingDetails"]], PlotDF=map_list[["PlotDF"]], MapSizeRatio=map_list[["MapSizeRatio"]],
      Xlim=map_list[["Xlim"]], Ylim=map_list[["Ylim"]], FileName=working_dir, Year_Set=year_labels, Years2Include=years_to_plot, Rotate=map_list[["Rotate"]],
      Cex=map_list[["Cex"]], Legend=map_list[["Legend"]], zone=map_list[["Zone"]], mar=c(0,0,2,0), oma=c(3.5,3.5,0,0), cex=1.8)
  }else{
    message("\n### Skipping plot of Pearson residuals")
  }

  # return
  Return = list( "Q"=Q, "Index"=Index, "Dens_xt"=Dens_xt, "map_list"=map_list )
  return( invisible(Return) )
}

