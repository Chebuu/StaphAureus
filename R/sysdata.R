population = read.csv(system.file('extdata/population.csv', package='StaphAureus'))
usethis::use_data(population, overwrite=TRUE)
control = population[is.na(population$interpretation),]
usethis::use_data(cohort, overwrite=TRUE)
cohort = population[!is.na(population$interpretation),]
usethis::use_data(control, overwrite=TRUE)

orgids = data.frame(
  org_name = c(
    "POSITIVE FOR METHICILLIN RESISTANT STAPH AUREUS",
    "STAPH AUREUS COAG +",
    "STAPHYLOCOCCUS EPIDERMIDIS",
    "STAPHYLOCOCCUS HOMINIS",
    "STAPHYLOCOCCUS LUGDUNENSIS",
    "STAPHYLOCOCCUS SAPROPHYTICUS, PRESUMPTIVE IDENTIFICATION",
    "STAPHYLOCOCCUS SPECIES",
    "STAPHYLOCOCCUS, COAGULASE NEGATIVE",
    "STAPHYLOCOCCUS, COAGULASE NEGATIVE, PRESUMPTIVELY NOT S. SAPROPHYTICUS",
  ),
  org_itemid = c(
    80293,
    80023,
    80024,
    80162,
    80255,
    80138,
    80155,
    80262
  )
)
usethis::use_data(orgids, overwrite=TRUE)
