#' @title Dataset `population`
# population = read.csv('inst/extdata/population.csv')
# # usethis::use_data(population, overwrite=TRUE)

#' @title Dataset `control`
#' @details A subset of dataset `population`
# control = population[is.na(population$interpretation),]
# # usethis::use_data(cohort, overwrite=TRUE)

#' @title Dataset `cohort`
#' @details A subset of dataset `population`
# cohort = population[!is.na(population$interpretation),]
# # usethis::use_data(control, overwrite=TRUE)

# --- --- ---

#' @title Dataset `orgids`
#' @export
# orgids = read.csv('inst/extdata/orgids.csv')
# # usethis::use_data(orgids, overwrite=TRUE)

#' @title Dataset `staphids`
# staph = read.csv('inst/extdata/staphids.csv')
# # usethis::use_data(staphids, overwrite=TRUE)

# --- --- ---

#' @title Dataset `coinfx`
# orgids = read.csv('inst/extdata/coinfx.csv')
# # usethis::use_data(coinfx, overwrite=TRUE)

#' @title Dataset `n_coinfx`
# orgids = read.csv('inst/extdata/n_coinfx.csv')
# # usethis::use_data(n_coinfx, overwrite=TRUE)

