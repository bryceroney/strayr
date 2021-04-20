

#' @title Import SEIFA Data from ABS Spreadsheet
#' @description The function will download all LGA SEIFA data to a temporary excel file and merge sheets into a long `data.frame`
#' @param indexes character vector matching available SEIFA indexes:
#' \itemize{
#'   \item{irsed}{Index of Relative Socio-economic Disadvantage}
#'   \item{irsead}{Index of Relative Socio-economic Advantage and Disadvantage}
#'   \item{ier}{Index of Economic Resources}
#'   \item{ieo}{Index of Education and Occupation}
#' }
#' @param spatial_area character value for the desired spatial area. MUst be one of:
#' \itemize{
#'   \item{sa1}{download size 51.6 mb}
#'   \item{sa2}{download size 1.9 mb}
#'   \item{lga}{download size 660 kb}
#'   \item{postcode}
#'   \item{suburb}
#' }
#'
#' @importFrom purrr map_dfr
#' @importFrom utils download.file
#' @importFrom dplyr starts_with
#'
#' @note For All SEIFA spreadsheets go to https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/2033.0.55.0012016?OpenDocument
#' @export
seifa_scores <- function(indexes = c('irsed', 'irsead', 'ier', 'ieo'), spatial_area = c('sa1','sa2','sa3','lga','postcode')) {

  # match excel sheet names to indexes
  stopifnot(all(indexes %in% c('irsed', 'irsead', 'ier', 'ieo')))

  sheet_names <- c('irsed'   = 'Table 2',
                   'irsead'  = 'Table 3',
                   'ier'     = 'Table 4',
                   'ieo'     = 'Table 5')

  sheet_names <- sheet_names[indexes]


  # match spatial areas to specific urls
  spatial_area <- match.arg(spatial_area, several.ok = FALSE)

  urls <- c('sa1' = 'https://www.abs.gov.au/ausstats/subscriber.nsf/log?openagent&2033055001%20-%20sa1%20indexes.xls&2033.0.55.001&Data%20Cubes&40A0EFDE970A1511CA25825D000F8E8D&0&2016&27.03.2018&Latest',
            'sa2' = 'https://www.abs.gov.au/ausstats/subscriber.nsf/log?openagent&2033055001%20-%20sa2%20indexes.xls&2033.0.55.001&Data%20Cubes&C9F7AD36397CB43DCA25825D000F917C&0&2016&27.03.2018&Latest',
            'lga' = 'https://www.abs.gov.au/ausstats/subscriber.nsf/log?openagent&2033055001%20-%20lga%20indexes.xls&2033.0.55.001&Data%20Cubes&5604C75C214CD3D0CA25825D000F91AE&0&2016&27.03.2018&Latest',
            'postcode' = 'https://www.abs.gov.au/ausstats/subscriber.nsf/log?openagent&2033055001%20-%20poa%20indexes.xls&2033.0.55.001&Data%20Cubes&DC124D1DAC3D9FDDCA25825D000F9267&0&2016&27.03.2018&Latest',
            'suburb' = 'https://www.abs.gov.au/ausstats/subscriber.nsf/log?openagent&2033055001%20-%20ssc%20indexes.xls&2033.0.55.001&Data%20Cubes&863031D939DE8105CA25825D000F91D2&0&2016&27.03.2018&Latest')

  url <- urls[spatial_area]

  filename <- tempfile(fileext = '.xls')

  try(
    download.file(url, destfile = filename, mode = 'wb')
  )

  ind <- map_dfr(sheet_names, ~ get_seifa_index_sheet(filename, .x, spatial_area), .id = 'seifa_index')

  return(ind)

}


#' @title Parse SEIFA index Spreadsheet
#' @description This is a helper function used by \code{\link{seifa_scores}}. The function can also
#' be used independently if you have already downloaded one of the SEIFA index score spreadsheets
#' from link{https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/2033.0.55.0012016?OpenDocument}
#'
#' @param filename character name of temporary file when spreadsheet downloaded
#' @param sheetname character name of the sheet to be imported
#' @param spatial_area character
#'
#' @import readxl
#' @importFrom dplyr select mutate relocate
#' @return data.frame
#' @export
#'
#' @examples
get_seifa_index_sheet <- function(filename, sheetname, spatial_area = c('sa1','sa2','sa3','lga','postcode')) {

  spatial_area <- match.arg(spatial_area, several.ok = FALSE)

  column_names <- c('area_code',
                    'area_name',
                    'population',
                    'score',
                    'blank1',
                    'rank_aus',
                    'decile_aus',
                    'percentile_aus',
                    'blank2',
                    'state',
                    'rank_state',
                    'decile_state',
                    'percentile_state',
                    'min_score_sa1_area',
                    'max_score_sa1_area',
                    'percent_usual_resident_pop_without_sa1_score')

  if (spatial_area == 'sa1') {
    column_names <- c('sa1_7_code',
                      'sa1_11_code',
                      'population',
                      'score',
                      'blank1',
                      'rank_aus',
                      'decile_aus',
                      'percentile_aus',
                      'blank2',
                      'state',
                      'rank_state',
                      'decile_state',
                      'percentile_state')
  }

  df <- read_excel(filename,
                   sheetname,
                   skip = 6,
                   col_names = column_names) %>%
    select(-starts_with('blank')) %>%
    mutate(spatial_area = spatial_area) %>%
    relocate(spatial_area)

  return(df)

}