EDA-III
================

``` r
devtools::install_github('chebuu/StaphAureus')

library(StaphAureus)

## Imports:
# library(gt)
# library(grid)
# library(dplyr)
# library(ggplot2)
# library(cowplot)
# library(gridExtra)
# library(kableExtra)
```

### Study Population

``` sql
-- Confirmed positive and negative samples
drop materialized view if exists populataion cascade;
create materialized view population as
select 
    pt.subject_id, 
    mb.hadm_id, 
    pt.expire_flag, 
    mb.org_name, 
    mb.isolate_num, 
    mb.interpretation 
from microbiologyevents mb
left join patients pt 
  on mb.subject_id = pt.subject_id
  and mb.org_name ilike any (
    array [ '%STAPH%+%', '%STAPH%NEG%']
  )
group by 
  pt.subject_id, 
  mb.hadm_id, 
  mb.org_name, 
  mb.isolate_num, 
  mb.interpretation,
  pt.expire_flag
```

Interpretation levels: 

`"R"`    - Positive test result (resistant) 

`"S"`    - Positive test result (susceptible) 

`"I"`    - Positive test result (intermediate) 

`"P"`    - Positive test result (S/R not tested) 

`"None"` - Negative test result (NULL value) 

### Negative Control

All NULL `population` test interpretation values.

``` sql
-- Confirmed negative subset
drop materialized view if exists control cascade;
create materialized view control as
select * from population where interpretation is NULL
```

### Positive Cohort COAG(+)/COAG(-)

All non-NULL `population` test interpretation values.

``` sql
-- Confirmed positive subset
drop materialized view if exists cohort cascade;
create materialized view cohort as
select * from population where interpretation is not NULL
```

``` r
data(cohort)

(
  cohort.hist.isolates <<- {
    cohort.iso.table <<- cohort %>%
    distinct_at(
      vars(subject_id, org_name, isolate_num)
    ) %>%
    mutate(
      org_name = case_when(
        grepl('NEG', org_name) ~ 'COAG (-)',
        grepl('+', org_name)   ~ 'COAG (+)'
      )
    )
  } %>% 
  ggplot(aes(x=isolate_num)) +
    geom_histogram(stat='count') +
    facet_grid(~org_name) +
    labs(
      title = 'Staph isolates by coagulase',
      subtitle = '(confirmed positive)'
    ) +
    theme_bw() + theme(
      plot.title.position = 'plot',
      plot.title = element_text(hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5)
    ) 
)
```

<img src="./EDA-III_files/figure-gfm/cohort_iso-1.png" style="display: block; margin: auto;" />

``` r

(
  cohort.hist.mortality <- {
    cohort.mort.table <<- cohort %>%
    group_by(
      subject_id, org_name, isolate_num, expire_flag
    ) %>%
    mutate(
      org_name = case_when(
        grepl('NEG', org_name) ~ 'COAG (-)',
        grepl('+', org_name)   ~ 'COAG (+)'
      )
    )
  } %>% 
  ggplot(aes(x=isolate_num)) +
    geom_histogram(stat='count') +
    facet_grid(~org_name + expire_flag) +
    labs(
      title = 'Patient mortality by coagulase/isolate',
      subtitle = '(confirmed positive)'
    ) + 
    theme_bw() + theme(
      plot.title.position = 'plot',
      plot.title = element_text(hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5)
    ) 
)
```

<img src="./EDA-III_files/figure-gfm/cohort_mrt-1.png" style="display: block; margin: auto;" />

``` r
cohort.iso.table -> cohort.table

.displayP <- cohort.table %>% filter(grepl('\\+', org_name))
gt(.displayP %>% head(6)) %>%
  fmt_number(columns = vars(isolate_num), decimals = 0) %>%
  fmt_passthrough(columns = vars(subject_id, org_name)) %>%
  tab_header(
    title = md('COAG (+)'),
    subtitle = sprintf('(N=%s)', nrow(.displayP))
  ) %>%
  tab_source_note(md('Subsample of cohort (confirmed positive)'))
```

<!--html_preserve-->

<div id="cbetwlwkzr" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">

<thead class="gt_header">

<tr>

<th colspan="3" class="gt_heading gt_title gt_font_normal" style>

COAG (+)

</th>

</tr>

<tr>

<th colspan="3" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>

(N=994)

</th>

</tr>

</thead>

<thead class="gt_col_headings">

<tr>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

subject\_id

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

org\_name

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

isolate\_num

</th>

</tr>

</thead>

<tbody class="gt_table_body">

<tr>

<td class="gt_row gt_right">

9

</td>

<td class="gt_row gt_left">

COAG (+)

</td>

<td class="gt_row gt_right">

1

</td>

</tr>

<tr>

<td class="gt_row gt_right">

31

</td>

<td class="gt_row gt_left">

COAG (+)

</td>

<td class="gt_row gt_right">

1

</td>

</tr>

<tr>

<td class="gt_row gt_right">

38

</td>

<td class="gt_row gt_left">

COAG (+)

</td>

<td class="gt_row gt_right">

1

</td>

</tr>

<tr>

<td class="gt_row gt_right">

41

</td>

<td class="gt_row gt_left">

COAG (+)

</td>

<td class="gt_row gt_right">

1

</td>

</tr>

<tr>

<td class="gt_row gt_right">

43

</td>

<td class="gt_row gt_left">

COAG (+)

</td>

<td class="gt_row gt_right">

1

</td>

</tr>

<tr>

<td class="gt_row gt_right">

96

</td>

<td class="gt_row gt_left">

COAG (+)

</td>

<td class="gt_row gt_right">

1

</td>

</tr>

</tbody>

<tfoot class="gt_sourcenotes">

<tr>

<td class="gt_sourcenote" colspan="3">

Subsample of cohort (confirmed positive)

</td>

</tr>

</tfoot>

</table>

</div>

<!--/html_preserve-->

``` r

.displayN <- cohort.table %>% filter(grepl('-', org_name)) 
gt(.displayN %>% head(6)) %>%
  fmt_number(columns = vars(isolate_num), decimals = 0) %>%
  fmt_passthrough(columns = vars(subject_id, org_name)) %>%
  tab_header(
    title = md('COAG (-)'),
    subtitle = sprintf('(N=%s)', nrow(.displayN))
  ) %>%
  tab_source_note(md('Subsample of cohort (confirmed positive)'))
```

<!--html_preserve-->

<div id="bnzbxxrqin" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">

<thead class="gt_header">

<tr>

<th colspan="3" class="gt_heading gt_title gt_font_normal" style>

COAG (-)

</th>

</tr>

<tr>

<th colspan="3" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>

(N=494)

</th>

</tr>

</thead>

<thead class="gt_col_headings">

<tr>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

subject\_id

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">

org\_name

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">

isolate\_num

</th>

</tr>

</thead>

<tbody class="gt_table_body">

<tr>

<td class="gt_row gt_right">

41

</td>

<td class="gt_row gt_left">

COAG (-)

</td>

<td class="gt_row gt_right">

1

</td>

</tr>

<tr>

<td class="gt_row gt_right">

106

</td>

<td class="gt_row gt_left">

COAG (-)

</td>

<td class="gt_row gt_right">

1

</td>

</tr>

<tr>

<td class="gt_row gt_right">

109

</td>

<td class="gt_row gt_left">

COAG (-)

</td>

<td class="gt_row gt_right">

1

</td>

</tr>

<tr>

<td class="gt_row gt_right">

109

</td>

<td class="gt_row gt_left">

COAG (-)

</td>

<td class="gt_row gt_right">

2

</td>

</tr>

<tr>

<td class="gt_row gt_right">

148

</td>

<td class="gt_row gt_left">

COAG (-)

</td>

<td class="gt_row gt_right">

1

</td>

</tr>

<tr>

<td class="gt_row gt_right">

188

</td>

<td class="gt_row gt_left">

COAG (-)

</td>

<td class="gt_row gt_right">

1

</td>

</tr>

</tbody>

<tfoot class="gt_sourcenotes">

<tr>

<td class="gt_sourcenote" colspan="3">

Subsample of cohort (confirmed positive)

</td>

</tr>

</tfoot>

</table>

</div>

<!--/html_preserve-->

NOTE: Positive COAG(-) test results are labeled “Presumptively not *S.saprophyticus*”. 

`308 "STAPHYLOCOCCUS, COAGULASE NEGATIVE" "None"`

`308 "STAPHYLOCOCCUS, COAGULASE NEGATIVE, PRESUMPTIVELY NOT S. SAPROPHYTICUS" "R"`

NOTE: I think most of the NULL interpretations come from MRSA screens.

`"MRSA SCREEN" 80023 "STAPH AUREUS COAG +" "OXACILLIN" "R"`
