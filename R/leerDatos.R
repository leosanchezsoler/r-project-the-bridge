#' @title  leer_datos
#' 
#' @description función que lee archivos csv. Es llamada por la función main
#' 
#' @param config
#' @param path
#' 
#' @return datos
#' @author leosanchezsoler

leer_datos <- function(config, path){
  lista_csv <- list()
  
  for (i in config&data$predictors){
    
    tryCatch(expr = {
      
      path_datos <- paste0(path, 'data/', i)
      datos <- data.table::fread(path_datos, sep = config$sep,
                                 encoding = 'UTF- 8', data.table = F, header = T)
    
    }, error <- function(e){
      
        logerror('No se ha encontrado ningún dataset la ruta. Por favor, compruébalo y revisa config.xml',
                 logger = 'log')
      stop()

    })
    
    if (nrow(datos) == 0 | ncol(datos) == 0){
      
      logerror('Ha habido un error al leer los datos, comprueba el formato y revisa tu dataset',
               logger = 'log')
      stop()
    }
    
    lista_df[[i]] <- datos
  }

  loginfo('asignando target', logger = 'log')
  
  target <- read_target(config, path)
  
  lista_pred_target <- list(predictoras = lista_df, target = target)
  
  return(lista_pred_target)
}


#' @title leer_target
#' 
#' @description es llamada por main y se encarga de leer el target
#' 
#' @param config
#' @param path
#' 
#' @return target
#' @import data.table
#' @import logging
#' 
#' @author leosanchezsoler

leer_target <- function(config, path){
  path_target <- paste0(path, 'data/', config$data$target)
  
  tryCatch(expr = {
    target <- data.table::fread(path_target, sep = config$sep,
                                encoding = 'UTF-8', data.table = F, header = T)
    
  }, error = function(e){
    
    logerror('No se ha encontrado el target en la ruta. Por favor, compruébalo y revisa config.xml',
             logger = 'log')
    stop()
    
    })
  return(target)
}
