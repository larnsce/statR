% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/datasetsXLSX.R
\name{datasetsXLSX}
\alias{datasetsXLSX}
\title{datasetsXLSX()}
\usage{
datasetsXLSX(
  file,
  datasets,
  titles,
  plot_widths = NULL,
  plot_heights = NULL,
  grouplines = NA,
  group_names = NA,
  sources = "statzh",
  metadata1 = NA,
  sheetnames,
  maintitle,
  titlesource = "statzh",
  logo = "statzh",
  auftrag_id = NULL,
  contact = "statzh",
  homepage = "statzh",
  openinghours = "statzh",
  overwrite = F
)
}
\arguments{
\item{file}{file name of the spreadsheet. The extension ".xlsx" is added automatically.}

\item{datasets}{datasets or plots to be included.}

\item{titles}{titles of the different sheets.}

\item{plot_widths}{width of figure in inch (1 inch = 2.54 cm). See details.}

\item{plot_heights}{height of figure in inch (1 inch = 2.54 cm). See details.}

\item{grouplines}{Column for second header(s). Format: List e.g list(c(2,4,6))}

\item{group_names}{Name(s) of the second header(s). Format: List e.g list(c("title 1", "title 2", "title 3"))}

\item{sources}{source of the data. Defaults to "statzh".}

\item{metadata1}{metadata information to be included. Defaults to NA.}

\item{sheetnames}{names of the sheet tabs.}

\item{maintitle}{Title to be put on the first (overview) sheet.}

\item{titlesource}{source to be mentioned on the title sheet beneath the title}

\item{logo}{file path to the logo to be included in the index-sheet. Can be "statzh" or "zh". Defaults to "statzh".}

\item{auftrag_id}{order number.}

\item{contact}{contact information on the title sheet. Defaults to "statzh"}

\item{homepage}{web address to be put on the title sheet. Default to "statzh"}

\item{openinghours}{openinghours written on the title sheet. Defaults to Data Shop}

\item{overwrite}{overwrites the existing excel files with the same file name. default to FALSE}
}
\description{
Function to export several datasets and/or figures from R to an .xlsx-file. The function creates an overview sheet and separate sheets
for each dataset/figure.
}
\details{
When including figures, the heights and widths need to be specified as a vector. For example, say you have one dataset and two figures
that you would like to export. widths = c(5,6) then suggests that the first figure will be 5 inches wide, the second 6. To include a figure either
save it as a ggplot object or indicate a file path to an existing file (possible formats: png, jpg, bmp).
}
\examples{
\donttest{
\dontrun{



# Example with two datasets and no figure
dat1 <- mtcars
dat2 <- PlantGrowth

datasetsXLSX(file="twoDatasets", # '.xlsx' wird automatisch hinzugef\u00fcgt
            datasets = list(dat1, dat2),
            titles = c("mtcars-Datensatz","PlantGrowth-Datensatz"),
            grouplines = list(c(1)),
            group_names = list(c("name_of_second_header")),  #produces a second header in the first sheet
            sources = c("Source: Henderson and Velleman (1981).
            Building multiple regression models interactively. Biometrics, 37, 391–411.",
                        "Dobson, A. J. (1983) An Introduction to Statistical
                        Modelling. London: Chapman and Hall."),
            metadata1 = c("Bemerkungen zum mtcars-Datensatz: x",
                          "Bemerkungen zum PlantGrowth-Datensatz: x"),
            sheetnames = c("Autos","Blumen"),
            maintitle = "Autos und Pflanzen",
            titlesource = "statzh",
            logo = "statzh",
            auftrag_id="A2021_0000",
            contact = "statzh",
            homepage = "statzh",
            openinghours = "statzh",
            overwrite = T)

# Example with two datasets and one figure

dat1 <- mtcars
dat2 <- PlantGrowth
fig <- ggplot(mtcars, aes(x=disp))+
                 geom_histogram()

datasetsXLSX(file="twoDatasetsandFigure",        # '.xlsx' wird automatisch hinzugef\u00fcgt
            datasets = list(dat1, dat2, fig),   # fig als ggplot Objekt oder File Path
            titles = c("mtcars-Datensatz","PlantGrowth-Datensatz", "Histogramm"),
            plot_widths = c(5),
            plot_heights = c(5),
            sources = c("Source: Henderson and Velleman (1981).
            Building multiple regression models interactively. Biometrics, 37, 391–411.",
                        "Source: Dobson, A. J. (1983) An Introduction to
                        Statistical Modelling. London: Chapman and Hall."),
            metadata1 = c("Bemerkungen zum mtcars-Datensatz: x",
                         "Bemerkungen zum PlantGrowth-Datensatz: x"),
            sheetnames = c("Autos","Blumen", "Histogramm"),
            maintitle = "Autos und Pflanzen",
            titlesource = "statzh",
            logo="statzh",
            auftrag_id="A2021_0000",
            contact = "statzh",
            homepage = "statzh",
            openinghours = "statzh",
            overwrite = T)
}
}
}
\keyword{datasetsXLSX}
