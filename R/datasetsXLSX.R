#' datasetsXLSX()
#'
#' Function to export several datasets and/or figures from R to an .xlsx-file. The function creates an overview sheet and separate sheets
#' for each dataset/figure.
#'
#' When including figures, the heights and widths need to be specified as a vector. For example, say you have one dataset and two figures
#' that you would like to export. widths = c(5,6) then suggests that the first figure will be 5 inches wide, the second 6. To include a figure either
#' save it as a ggplot object or indicate a file path to an existing file (possible formats: png, jpg, bmp).
#'
#' @param file file name of the spreadsheet. The extension ".xlsx" is added automatically.
#' @param maintitle Title to be put on the first (overview) sheet.
#' @param datasets datasets or plots to be included.
#' @param plot_widths width of figure in inch (1 inch = 2.54 cm). See details.
#' @param plot_heights height of figure in inch (1 inch = 2.54 cm). See details.
#' @param sheetnames names of the sheet tabs.
#' @param titles titles of the different sheets.
#' @param logo file path to the logo to be included in the index-sheet. Can be "statzh" or "zh". Defaults to "statzh".
#' @param titlesource source to be mentioned on the title sheet beneath the title
#' @param sources source of the data. Defaults to "statzh".
#' @param metadata1 metadata information to be included. Defaults to NA.
#' @param auftrag_id order number.
#' @param contact contact information on the title sheet. Defaults to "statzh"
#' @param homepage web address to be put on the title sheet. Default to "statzh"
#' @param openinghours openinghours written on the title sheet. Defaults to Data Shop
#' @param grouplines Column for second header(s). Format: List e.g list(c(2,4,6))
#' @param group_names Name(s) of the second header(s). Format: List e.g list(c("title 1", "title 2", "title 3"))
#' @param overwrite overwrites the existing excel files with the same file name. default to FALSE
#' @keywords datasetsXLSX
#' @export
#' @examples
#'\donttest{
#' \dontrun{
#'
#'
#'
#'# Example with two datasets and no figure
#'dat1 <- mtcars
#'dat2 <- PlantGrowth
#'
#'datasetsXLSX(file="twoDatasets", # '.xlsx' wird automatisch hinzugef\u00fcgt
#'             datasets = list(dat1, dat2),
#'             titles = c("mtcars-Datensatz","PlantGrowth-Datensatz"),
#'             grouplines = list(c(1)),
#'             group_names = list(c("name_of_second_header")),  #produces a second header in the first sheet
#'             sources = c("Source: Henderson and Velleman (1981).
#'             Building multiple regression models interactively. Biometrics, 37, 391–411.",
#'                         "Dobson, A. J. (1983) An Introduction to Statistical
#'                         Modelling. London: Chapman and Hall."),
#'             metadata1 = c("Bemerkungen zum mtcars-Datensatz: x",
#'                           "Bemerkungen zum PlantGrowth-Datensatz: x"),
#'             sheetnames = c("Autos","Blumen"),
#'             maintitle = "Autos und Pflanzen",
#'             titlesource = "statzh",
#'             logo = "statzh",
#'             auftrag_id="A2021_0000",
#'             contact = "statzh",
#'             homepage = "statzh",
#'             openinghours = "statzh",
#'             overwrite = T)
#'
#'# Example with two datasets and one figure
#'
#'dat1 <- mtcars
#'dat2 <- PlantGrowth
#'fig <- ggplot(mtcars, aes(x=disp))+
#'                  geom_histogram()
#'
#'datasetsXLSX(file="twoDatasetsandFigure",        # '.xlsx' wird automatisch hinzugef\u00fcgt
#'             datasets = list(dat1, dat2, fig),   # fig als ggplot Objekt oder File Path
#'             titles = c("mtcars-Datensatz","PlantGrowth-Datensatz", "Histogramm"),
#'             plot_widths = c(5),
#'             plot_heights = c(5),
#'             sources = c("Source: Henderson and Velleman (1981).
#'             Building multiple regression models interactively. Biometrics, 37, 391–411.",
#'                         "Source: Dobson, A. J. (1983) An Introduction to
#'                         Statistical Modelling. London: Chapman and Hall."),
#'             metadata1 = c("Bemerkungen zum mtcars-Datensatz: x",
#'                          "Bemerkungen zum PlantGrowth-Datensatz: x"),
#'             sheetnames = c("Autos","Blumen", "Histogramm"),
#'             maintitle = "Autos und Pflanzen",
#'             titlesource = "statzh",
#'             logo="statzh",
#'             auftrag_id="A2021_0000",
#'             contact = "statzh",
#'             homepage = "statzh",
#'             openinghours = "statzh",
#'             overwrite = T)
#'}
#'}



datasetsXLSX <- function(file,
                         datasets,
                         titles,
                         plot_widths = NULL,
                         plot_heights = NULL,
                         grouplines = NA,
                         group_names = NA,
                         sources= "statzh",
                         metadata1=NA,
                         sheetnames,
                         maintitle,
                         titlesource = "statzh",
                         logo="statzh",
                         auftrag_id = NULL,
                         contact = "statzh",
                         homepage = "statzh",
                         openinghours = "statzh",
                         overwrite = F
){

  if(!any(is.na(group_names)) & any(is.na(grouplines))){
    stop("if a second header is wanted, the grouplines have to be specified")
  }

  wb <- openxlsx::createWorkbook("data")

  dataframes_index <- which(vapply(datasets, is.data.frame, TRUE))

  dataframe_datasets <- datasets[dataframes_index]
  dataframe_sheetnames <- sheetnames[dataframes_index]
  dataframe_titles <- titles[dataframes_index]
  dataframe_sources <- sources[dataframes_index]
  dataframe_metadata1 <- metadata1[dataframes_index]
  dataframe_grouplines <- grouplines[dataframes_index]
  dataframe_group_names <- group_names[dataframes_index]


  plot_index <- which(vapply(datasets, function(x) length(setdiff(class(x), c("gg", "ggplot", "histogram", "character"))) == 0, TRUE))

  plot_datasets <- datasets[plot_index]
  plot_sheetnames <- sheetnames[plot_index]

  insert_index_sheet(wb, logo, contact, homepage, openinghours, titlesource, auftrag_id, maintitle)


  if(length(dataframes_index) > 0){

    purrr::pwalk(list(
      dataframe_datasets,
      dataframe_sheetnames,
      dataframe_titles,
      dataframe_sources,
      dataframe_metadata1,
      dataframe_grouplines,
      dataframe_group_names
      ),
      ~insert_worksheet_nh(
        data = ..1,
        wb = wb,
        sheetname = ..2,
        title = ..3,
        source = ..4,
        metadata = ..5,
        grouplines = ..6,
        group_names = ..7
      ))

  }

  if(length(plot_index)>0){

    temp_list <- purrr::pmap(list(
      plot_datasets,
      plot_sheetnames,
      plot_widths,
      plot_heights
    ), ~insert_worksheet_image(
      image = ..1,
      wb = wb,
      sheetname = ..2,
      width = ..3,
      height = ..4))
  }else{
    temp_list <- NA
  }


  hyperlink_table <- data.frame(
    sheetnames = sheetnames,
    titles = titles,
    sheet_row = c(seq(15,15+length(sheetnames)-1))
  )

  purrr::pwalk(hyperlink_table, ~insert_hyperlinks(wb, ..1, ..2, ..3))

  openxlsx::saveWorkbook(wb, paste(file, ".xlsx", sep = ""), overwrite = overwrite)

  if(!is.na(temp_list)){
    purrr::walk(temp_list, unlink)
  }
}


insert_hyperlinks <- function(wb, sheetname, title, sheet_row){
  openxlsx::writeData(wb,
                      sheet = "Inhalt",
                      x = title,
                      xy = c("C", sheet_row)
  )

  openxlsx::addStyle(wb
                     ,sheet = "Inhalt"
                     ,style = hyperlink_style()
                     ,rows = sheet_row
                     ,cols = 3
  )

  openxlsx::mergeCells(wb, sheet = "Inhalt", cols = 3:8, rows = sheet_row)

  worksheet <- wb$sheetOrder[1]

  field_t <- wb$worksheets[[worksheet]]$sheet_data$t
  field_t[length(field_t)] <- 3

  field_v <- wb$worksheets[[worksheet]]$sheet_data$v
  field_v[length(field_v)] <- NA

  field_f <- wb$worksheets[[worksheet]]$sheet_data$f
  field_f[length(field_f)] <- paste0("<f>=HYPERLINK(&quot;#&apos;",sheetname,"&apos;!A1&quot;, &quot;",title,"&quot;)</f>")

  wb$worksheets[[worksheet]]$sheet_data$t <- as.integer(field_t)
  wb$worksheets[[worksheet]]$sheet_data$v <- field_v
  wb$worksheets[[worksheet]]$sheet_data$f <- field_f
}


hyperlink_style <- function(){
  openxlsx::createStyle(
    fontName = "Calibri",
    fontSize = 11,
    fontColour = "blue",
    textDecoration = "underline"

  )
}


insert_index_sheet <- function(wb, logo, contact, homepage, openinghours, titlesource, auftrag_id, maintitle){
  # Create index sheet
  openxlsx::addWorksheet(wb,"Inhalt")

  #  hide gridlines
  openxlsx::showGridLines(wb
                          ,sheet = "Inhalt"
                          ,showGridLines = F
  )

  # set col widths
  openxlsx::setColWidths(wb
                         ,"Inhalt"
                         ,cols = 1
                         ,widths = 1
  )

  # insert logo

  if(!is.null(logo)){

    if(logo=="statzh") {

      logo <- paste0(.libPaths(),"/statR/extdata/Stempel_STAT-01.png")

      #
      logo <- logo[file.exists(paste0(.libPaths(),"/statR/extdata/Stempel_STAT-01.png"))]

      openxlsx::insertImage(wb,
                            "Inhalt",
                            file=logo,
                            startRow = 2,
                            startCol = 2,
                            width = 2.5,
                            height = 0.9,
                            units = "in")

    } else if(logo == "zh"){

      logo <- paste0(.libPaths(),"/statR/extdata/Stempel_Kanton_ZH.png")

      #
      logo <- logo[file.exists(paste0(.libPaths(),"/statR/extdata/Stempel_Kanton_ZH.png"))]

      openxlsx::insertImage(wb,
                            "Inhalt",
                            file=logo,
                            startRow = 2,
                            startCol = 2,
                            width = 2.5,
                            height = 0.9,
                            units = "in")


    } else if(file.exists(logo)) {

      openxlsx::insertImage(wb, i, logo, width = 2.145, height = 0.7865,
                            units = "in")
    }
    if(!file.exists(logo)) {

      message("no logo found and / or added")
    }

  }

  # contact

  if(!is.null(contact)){
    if(any(grepl(contact, pattern = "statzh"))) {
      contact <- c("Datashop"
                   ,"Tel.:  +41 43 259 75 00",
                   "datashop@statistik.zh.ch")
      openxlsx::writeData(wb
                          ,sheet = "Inhalt"
                          ,contact
                          ,xy = c("O", 2)
      )
    } else {
      openxlsx::writeData(wb
                          ,sheet = "Inhalt"
                          ,contact
                          ,xy = c("O", 2))
    }

  }


  if(!is.null(homepage)){

    if(any(grepl(homepage, pattern = "statzh"))) {

      homepage <- "http://www.statistik.zh.ch"
      class(homepage) <- 'hyperlink'
      openxlsx::writeData(wb
                          ,"Inhalt"
                          ,x = homepage
                          ,xy = c("O", 5))
    } else {
      class(homepage) <- 'hyperlink'
      openxlsx::writeData(wb
                          ,"Inhalt"
                          ,x = homepage
                          ,xy = c("O", 5))
    }

  }



  if(!is.null(openinghours)){

    if(any(grepl(openinghours, pattern = "statzh"))) {

      openinghours <- c("B\u00fcrozeiten"
                        ,"Montag bis Freitag"
                        ,"09:00 bis 12:00"
                        ,"13:00 bis 16:00")

      openxlsx::writeData(wb
                          ,sheet = "Inhalt"
                          ,openinghours
                          ,xy = c("R", 2)

      )

    } else {

      openxlsx::writeData(wb
                          ,sheet = "Inhalt"
                          ,openinghours
                          ,xy = c("R", 2))

    }

  }


  # headerline
  headerline <- openxlsx::createStyle(border="Bottom", borderColour = "#009ee0",borderStyle = getOption("openxlsx.borderStyle", "thick"))
  openxlsx::addStyle(wb
                     ,"Inhalt"
                     ,headerline
                     ,rows = 6
                     ,cols = 1:20
                     ,gridExpand = TRUE
                     ,stack = TRUE
  )

  #Erstellungsdatum
  openxlsx::writeData(wb
                      ,"Inhalt"
                      ,paste("Erstellt am "
                             ,format(Sys.Date(), format="%d.%m.%Y"))
                      ,xy = c("O", 8)
  )


  if (!is.null(auftrag_id)){
    # Auftragsnummer
    openxlsx::writeData(wb
                        ,sheet = "Inhalt"
                        ,paste("Auftragsnr.:", auftrag_id)
                        ,xy = c("O", 9)
    )
  }

  # title
  titleStyle <- openxlsx::createStyle(fontSize=20, textDecoration="bold",fontName="Arial", halign = "left")
  openxlsx::addStyle(wb
                     ,"Inhalt"
                     ,titleStyle
                     ,rows = 10
                     ,cols = 3
                     ,gridExpand = TRUE
  )

  openxlsx::writeData(wb
                      ,"Inhalt"
                      ,x = maintitle
                      ,headerStyle=titleStyle
                      ,xy = c("C", 10)
  )


  if(any(grepl(titlesource, pattern = "statzh"))){

    # source
    openxlsx::writeData(wb
                        ,"Inhalt"
                        ,"Quelle: Statistisches Amt des Kantons Z\u00fcrich"
                        ,xy = c("C", 11)
    )

  }else {

    openxlsx::writeData(wb
                        ,"Inhalt"
                        , titlesource
                        ,xy = c("C", 11))

  }




  # subtitle
  subtitleStyle <- openxlsx::createStyle(fontSize=11, textDecoration="bold",fontName="Arial", halign = "left")
  openxlsx::addStyle(wb
                     ,sheet = "Inhalt"
                     ,subtitleStyle
                     ,rows = 14
                     ,cols = 3
                     ,gridExpand = TRUE
  )

  openxlsx::writeData(wb
                      ,sheet = "Inhalt"
                      ,x = "Inhalt"
                      ,headerStyle=subtitleStyle
                      ,xy = c("C", 13)
  )

}
