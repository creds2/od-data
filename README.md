Transport energy analysis at the origin-destination level
================

<!-- README.md is generated from README.Rmd. Please edit that file -->
Introduction
============

Energy use is an inherently ephemeral phenomenon. Although, as the second law of thermodynamics states, energy cannot be created or destroyed, *useful energy* in the fossil fuel age exists only during the relatively short span between non-renewable sources being extracted and burned. In the coming renewable energy age, useful energy will exist for even less time, between conversion of environmental energy fluxes into electricity, transmission, and comparatively costly temporary storage. The second law of thermodynamics tells us that what we call energy use is in fact energy conversion, and every conversion results in less useful energy, in continuous and ubiquitous energy converters with varying power levels and load profiles. In the context of passenger transport, the prime example of these conversions is in the privately owned car, often the most powerful energy converter people have access to.

The act of travel involves moving across geographic space. Because of this, policies to address unsustainably high levels transport energy use can target 3 main areas: trip origins, typically residential locations where journeys begin; trip destinations, typically 'trip generators' such as school, hospitals and work places where trips end; and places in between, typically transport infrastructure. Of these three potential areas for policy intervention, most of the focus has been on the first. This makes sense from a citizen-focussed policy perspective, enabling residential areas with excessive transport energy use to be identified. However, from an energy systems perspective, it makes sense to identify opportunties across all three areas to intervene. Transport infrastructure can be modified to enable shift to low energy modes and encourage reductions in long distance travel; destinations can discourage driving and flying to reach them through parking costs and subsidising public transport modes to work, to provide a couple of examples.

The spatially distributed nature of transport energy use makes it not only possible, but useful, to analyse it across geographic space. The fundamental unit of aggregate geographic transport behaviour analysis, that accounts for origins, destinations and the spaces in between, is data at the origin-destination data. This paper sets out a case for analysing and visualising transport analysis at this OD

Introduction: what is OD data?
==============================

``` r
library(stplanr)
```

Representations of OD data
==========================

Origin-destination pairs (long form)
------------------------------------

Perhaps the most common and straightforward representation of OD data is a 'long thin' data frame. This is increasingly the format used by official statistical agencies, including the UK's Office for National Statistics (ONS), who provide origin destination data as a `.csv` file. Typically, the first column is the zone code of origin and the second column is the zone code of the destination, as shown in the code chunk below, which creates an object called `od_data_sample` using the [`pct` package](https://itsleeds.github.io/pct/) (chunk not evaluated for speed):

``` r
remotes::install_github("ITSLeeds/pct")
library(pct)
od_data_all = pct::get_od()
sel_local = 
  od_data_all$geo_code1 %in% cents_sf$geo_code &
  od_data_all$geo_code2 %in% cents_sf$geo_code 
od_data_sample = od_data_all[sel_local, ]
```

Data in this form usually has at least one other colum, representing the amount of travel between the zones. Additional columns represent addition attributes, e.g. a breakdown of flow by time, mode of travel, type of person, or trip purpose. As shown in the output of printing the sample dataset, the dataset we have downloaded contains column names representing mode of travel (car, bicycle etc):

``` r
names(od_data_sample)
```

Each 'mode' column contains an integer, while additional columns contain characters, as demonstrated by printing the data frame:

``` r
od_data_sample
```

Origin destination matrices
---------------------------

Desire lines
------------

The previous two representations of OD data are 'implicitly geographic': their coordinates are not contained in the data, but associated with another data object, typically a zone or a zone centroid. This is clearly problematic because it makes OD data less modular and self standing. A useful way of representing OD data that overcomes this issue is `desire_line` data: geographic lines between origin and destination, with information on flow levels between the two.

This is represented in the file `lines_cars.Rds`, representing the top 20,000 desire lines at the MSOA-MSOA level in England and Wales by the number of car km used for travel to work, which can be downloaded, read-in and plotted as follows:

``` r
u = "https://github.com/ropensci/stplanr/releases/download/0.2.9/lines_cars.Rds"
f = file.path(tempdir(), "lines_cars.Rds")
download.file(u, f)
lines_cars = readRDS(f)
plot(lines_cars["car_km"], lwd = lines_cars$car_km / 1000)
```

Based on the estimate of the average energy use per km being 2.5 MJ, and that these return trips are made on average 200 times per year, with a circuity of 1.3, we can estimate the total energy use of the 'high energy commutes' as follows:

``` r
sum(lines_cars$car_km *
      2.5 * # average energy use per vehicle km 
      220 * # estimated number of commutes/yr
      2.6   # circuity (estimated at 1.3) multiplied by 2 
    ) / 1e9
```

That represents ~10 petajoules (PJ), only for the top 20,000 most energy intensive commutes. That may seem like alot, but represents only a fraction of the UK's total energy use of [~200 Mtoe](https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/729451/DUKES_PN.pdf) (8400 PJ).

References
==========
