Visualising transport energy use: from area to route network levels
================

<!-- README.md is generated from README.Rmd. Please edit that file -->
Notes
=====

*This paper is work in progress. Comments and suggested changes are welcome.*

See the .Rmd file that contains the source code to reproduce the results (code not shown by default)

Papers to cite
--------------

We should probably cite these papers (please add more):

-   Paper on OD data for geodemographics: <http://www.sciencedirect.com/science/article/pii/S0198971516303301>

<!-- [@martin_origin-destination_2018] -->
-   (Alexander et al. 2015; He et al. 2018; Munuzuri et al. 2004)

Introduction
============

<!--
Draft suggestion for a new first paragraph (see comments below)
-->
Passenger transport is one of the main sources of energy use, especially personal cars (reference?). We analyse and visualise passenger transport data from the UK in order to understand which modes of transport are being used across the country. The aim of the study is to enable policy makers to invest in infrastucture which enables low-energy modes of transport, such as public transport and cycling.

Energy use is an inherently ephemeral phenomenon. Although, as the second law of thermodynamics states, energy cannot be created or destroyed, *useful energy* in the fossil fuel age exists only during the relatively short span between non-renewable sources being extracted and burned. In the coming renewable energy age, useful energy will exist for even less time, between conversion of environmental energy fluxes into electricity, transmission, and comparatively costly temporary storage. The second law of thermodynamics tells us that what we call energy use is in fact energy conversion, and every conversion results in less useful energy, in continuous and ubiquitous energy converters with varying power levels and load profiles. In the context of passenger transport, the prime example of these conversions is in the privately owned car, often the most powerful energy converter people have access to. <!--
* I suggest to move this paragraph a bit further. In my opinion, the first paragraph should be a to-the-point summary of our paper. This paragraph is about the physics of energy, which is more background. I added a new first paragraph as suggestion.
* Also, it was quite difficult for me to read, and probably also for other non-native-English/non-specilist-in-energy people. Specifically:
  * A few diffucult words which I had to look up: ephemeral and ubiquitous. Could be due to my bad English.
  * This paragraph is basically a summary of physics about energy. For non-specialists like me, it took me some time to digest, and also raises some questions, such as 
    * What happens with the non-useful energy?
    * How does energy conversion work?
    * What exactly is renewable and non-renewable energy?
* 'the privately owned car': I assume that rental cars are just as bad.
-->

The act of travel involves moving across geographic space. Because of this, policies to address unsustainably high levels transport energy use can target three main areas: trip origins, typically residential locations where journeys begin; trip destinations, typically 'trip generators' such as school, hospitals and work places where trips end; and places in between, typically transport infrastructure. Of these three potential areas for policy intervention, most of the focus has been on the first. This makes sense from a citizen-focussed policy perspective, enabling residential areas with excessive transport energy use to be identified. However, from an energy systems perspective, it makes sense to identify opportunties across all three areas to intervene. Transport infrastructure can be modified to enable shift to low energy modes and encourage reductions in long distance travel; destinations can discourage driving and flying to reach them through parking costs and subsidising public transport modes to work, to provide a couple of examples.

The spatially distributed nature of transport energy use makes it not only possible, but also useful to analyse it across geographic space. We analyse geographic transport behaviour by using aggregated origin-destionation data (OD data), which contains the numbers of people travelling from origin to destination via intermediate points, by mode of transport. This paper sets out a case for analysing and visualising transport analysis at this OD level.

-   Something on different levels of energy analysis.

-   Something on visualisation of spatial phenomena, e.g. building on (Rae 2009)

Levels of visualisation
=======================

OD datasets are 'implicitly geographic': their coordinates are not contained in the data, but associated with another data object, typically a zone or a zone centroid. An example demonstrating OD data is shown below, which respresents 2.4 million desire lines at the MSOA-MSOA level in England and Wales. The dataset shows the overall travel to work patterns across the UK, based on 21.6 million people in which both origin and destination were reported in the 2011 Census. This represents 81% of all commuters in the open access origin-destination data contained in the file `wu03ew_v2.csv`, which can be downloaded from <http://wicid.ukdataservice.ac.uk/> as follows:

by the number of car km used for travel to work, which can be downloaded, read-in and plotted as follows:

<img src="overview_map1.png" width="100%" />

Based on the estimate of the average energy use per km being 2.5 MJ, and that these return trips are made on average 200 times per year, with a circuity of 1.3, we can estimate the total energy use of the 'high energy commutes' as follows:

That represents ~10 petajoules (PJ), only for the top 20,000 most energy intensive commutes. That may seem like alot, but represents only a fraction of the UK's total energy use of [~200 Mtoe](https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/729451/DUKES_PN.pdf) (8400 PJ).

Zone of origin
--------------

The energy use presented at the OD level in the previous section can be aggregated to the zone leve.

Zone of destination
-------------------

Centroids
---------

An issue with visualising zonal data on geographic maps is that the results can over-emphasise attributes large, rural areas (<span class="citeproc-not-found" data-reference-id="ref">**???**</span>).

<img src="energy_origins_destinations.png" width="100%" />

Visualising desires lines
-------------------------

Desire lines
------------

Desire lines with direction
---------------------------

Routes
------

Route networks
--------------

Next steps
==========

A next step for this will be to compare 'high energy origins' and 'high energy destinations' with other energy-related variables.

We will also look at the impact of using route distances rather than straight line distances with an average cirquity.

Route analysis
==============

Route network analysis
======================

References
==========

Alexander, Lauren, Shan Jiang, Mikel Murga, and Marta C Gonz. 2015. “Validation of Origin-Destination Trips by Purpose and Time of Day Inferred from Mobile Phone Data.” *Transportation Research Part B: Methodological*, 1–20. doi:[10.1016/j.trc.2015.02.018](https://doi.org/10.1016/j.trc.2015.02.018).

He, Biao, Yan Zhang, Yu Chen, and Zhihui Gu. 2018. “A Simple Line Clustering Method for Spatial Analysis with Origin-Destination Data and Its Application to Bike-Sharing Movement Data.” *ISPRS International Journal of Geo-Information* 7 (6): 203. doi:[10.3390/ijgi7060203](https://doi.org/10.3390/ijgi7060203).

Munuzuri, J., J. Larraneta, L. Onieva, and P. Cortes. 2004. *Estimation of an Origin-Destination Matrix for Urban Freight Transport. Application to the City of Seville*. Edited by E. Taniguchi and R. G. Thompson. Amsterdam: Elsevier Science Bv.

Rae, Alasdair. 2009. “From Spatial Interaction Data to Spatial Interaction Information? Geovisualisation and Spatial Structures of Migration from the 2001 UK Census.” *Computers, Environment and Urban Systems* 33 (3): 161–78. doi:[10.1016/j.compenvurbsys.2009.01.007](https://doi.org/10.1016/j.compenvurbsys.2009.01.007).
