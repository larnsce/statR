# flush_left: schiebt title, subtitle und caption an den linken Grafikrand

#' flush_left
#'
#' Function to flush title, subtitle and caption to the lefthand side of the graphics device
#' @param g ggplot object
#' @keywords flush left
#' @export
#' @examples
#'
#' flush_left(ggplot(mtcars, aes( x = cyl))+
#' geom_bar()+
#' labs(title = "Titel", subtitle = "Untertitel", caption = "Datenquelle"))



flush_left <- function(g, ...){

  xout <- ggplotGrob(g)

  xout$layout$l[xout$layout$name == "title"] <- 1
  xout$layout$l[xout$layout$name == "subtitle"] <- 1
  xout$layout$l[xout$layout$name == "caption"] <- 1

  grid.arrange(xout)
}
