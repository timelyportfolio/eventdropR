#' Create an EventDrop timeline
#'
#' eventdrop provides an interactive \code{d3.js} htmlwidget
#' for \href{https://github.com/marmelab/EventDrop}{EventDrop}
#' timelines.
#'
#' @import htmlwidgets
#'
#' @export
eventdrop <- function(
  data = NULL, name = NULL, date = NULL, ...,
  width = NULL, height = NULL, elementId = NULL
) {

  # forward options using x
  x = list(
    data = data,
    name = name,
    date = date,
    options = list(...)
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'eventdrop',
    x = x,
    width = width,
    height = height,
    package = 'eventdropR',
    elementId = elementId
  )
}

#' Shiny bindings for eventdrop
#'
#' Output and render functions for using eventdrop within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a eventdrop
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name eventdrop-shiny
#'
#' @export
eventdropOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'eventdrop', width, height, package = 'eventdropR')
}

#' @rdname eventdrop-shiny
#' @export
renderEventdrop <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, eventdropOutput, env, quoted = TRUE)
}

#' @import htmltools
#' @keywords internal
eventdrop_html <- function(id, style, class, ...){
  tagList(
    tags$div( id = id, class = class, style = style, ...),
    d3r::d3_dep_v4()
  )
}
