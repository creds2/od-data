Transport energy analysis at the origin-destination level
================

<!-- README.md is generated from README.Rmd. Please edit that file -->
Introduction
============

Energy use is an inherently ephemeral phenomenon. Although, as the second law of thermodynamics states, energy cannot be created or destroyed, *useful energy* in the fossil fuel age exists only during the relatively short span between non-renewable sources being extracted and burned. In the coming renewable energy age, useful energy will exist for even less time, between conversion of environmental energy fluxes into electricity, transmission, and comparatively costly temporary storage. The second law of thermodynamics tells us that what we call energy use is in fact energy conversion, and every conversion results in less useful energy, in continuous and ubiquitous energy converters with varying power levels and load profiles. In the context of passenger transport, the prime example of these conversions is in the privately owned car, often the most powerful energy converter people have access to.

The act of travel involves moving across geographic space. Because of this, policies to address unsustainably high levels transport energy use can target 3 main areas: trip origins, typically residential locations where journeys begin; trip destinations, typically 'trip generators' such as school, hospitals and work places where trips end; and places in between, typically transport infrastructure. Of these three potential areas for policy intervention, most of the focus has been on the first. This makes sense from a citizen-focussed policy perspective, enabling residential areas with excessive transport energy use to be identified. However, from an energy systems perspective, it makes sense to identify opportunties across all three areas to intervene. Transport infrastructure can be modified to enable shift to low energy modes and encourage reductions in long distance travel; destinations can discourage driving and flying to reach them through parking costs and subsidising public transport modes to work, to provide a couple of examples.

The spatially distributed nature of transport energy use makes it not only possible, but useful, to analyse it across geographic space. The fundamental unit of aggregate geographic transport behaviour analysis, that accounts for origins, destinations and the spaces in between, is data at the origin-destination data. This paper sets out a case for analysing and visualising transport analysis at this OD level.

-   Something on different levels of energy analysis.

-   Something on visualisation of spatial phenomena, e.g. building on (Rae 2009)

Exploration of energy use at the OD in national commuter data
=============================================================

OD datasets are 'implicitly geographic': their coordinates are not contained in the data, but associated with another data object, typically a zone or a zone centroid. An example demonstrating OD data is shown below, which respresents 2.4 million desire lines at the MSOA-MSOA level in England and Wales. The dataset shows the overall travel to work patterns across the UK, based on 21.6 million people in which both origin and destination were reported in the 2011 Census. This represents 81% of all commuters in the open access origin-destination data contained in the file `wu03ew_v2.csv`, which can be downloaded from <http://wicid.ukdataservice.ac.uk/> as follows:

by the number of car km used for travel to work, which can be downloaded, read-in and plotted as follows:

<img src="overview_map1.png" width="100%" />

Based on the estimate of the average energy use per km being 2.5 MJ, and that these return trips are made on average 200 times per year, with a circuity of 1.3, we can estimate the total energy use of the 'high energy commutes' as follows:

That represents ~10 petajoules (PJ), only for the top 20,000 most energy intensive commutes. That may seem like alot, but represents only a fraction of the UK's total energy use of [~200 Mtoe](https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/729451/DUKES_PN.pdf) (8400 PJ).

References
==========

Rae, Alasdair. 2009. “From Spatial Interaction Data to Spatial Interaction Information? Geovisualisation and Spatial Structures of Migration from the 2001 UK Census.” *Computers, Environment and Urban Systems* 33 (3): 161–78. doi:[10.1016/j.compenvurbsys.2009.01.007](https://doi.org/10.1016/j.compenvurbsys.2009.01.007).
