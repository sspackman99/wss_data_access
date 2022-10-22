## This script just shows the underpinnings of the function "SDA_query()" from the soilDB package

## I just used this as my base when I created the "getsoil()" function

library(soilDB)

function (q) 
{
    if (!requireNamespace("httr", quietly = TRUE)) 
        stop("please install the `httr` package", call. = FALSE)
    if (!requireNamespace("xml2", quietly = TRUE)) 
        stop("please install the `xml2` package", call. = FALSE)
    if (!requireNamespace("jsonlite", quietly = TRUE)) 
        stop("please install the `jsonlite` package", call. = FALSE)
    if (length(q) > 1) {
        stop("Query vector must be length 1")
    }
    if (nchar(q, type = "bytes") > 2500000) {
        stop("Query string is too long (>2.5 million bytes), consider soilDB::makeChunks() to split inputs into several smaller queries and iterate", 
            call. = FALSE)
    }
    r <- try(httr::POST(url = "https://sdmdataaccess.sc.egov.usda.gov/tabular/post.rest", 
        body = list(query = q, format = "json+columnname+metadata"), 
        encode = "form"), silent = TRUE)
    if (inherits(r, "try-error")) {
        message("Soil Data Access POST request failed, returning try-error\n\n", 
            r)
        return(invisible(r))
    }
    request.status <- try(httr::stop_for_status(r), silent = TRUE)
    if (inherits(request.status, "try-error")) {
        r.content <- httr::content(r, as = "parsed", encoding = "UTF-8")
        error.msg <- xml2::xml_text(r.content)
        message(error.msg)
        return(invisible(request.status))
    }
    r.content <- try(httr::content(r, as = "text", encoding = "UTF-8"), 
        silent = TRUE)
    if (inherits(r.content, "try-error")) 
        return(invisible(r.content))
    d <- try(jsonlite::fromJSON(r.content), silent = TRUE)
    if (inherits(d, "try-error")) 
        return(invisible(d))
    n.tables <- length(d)
    if (n.tables < 1) {
        message("empty result set")
        return(NULL)
    }
    d <- try(lapply(d, .post_process_SDA_result_set), silent = TRUE)
    if (inherits(d, "try-error")) 
        return(invisible(d))
    SDA.ids <- names(d)
    for (i in 1:n.tables) {
        attr(d[[i]], "SDA_id") <- SDA.ids[i]
    }
    if (n.tables > 1) {
        message("multi-part result set, returning a list")
        return(d)
    }
    else {
        message("single result set, returning a data.frame")
        return(d[[1]])
    }
}
