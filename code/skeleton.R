# Setup --------
# Install the sample design package if needed!
if (!("sample.design" %in% installed.packages())) {
  devtools::install_github("nstauffer/sample.design")
}

# Set the data source paths
path_spatial <- ""
path_tabular <- ""
path_outputs <- ""

# Load in the data --------
# Spatial stuff
# Sample frame
frame_spdf <- rgdal::readOGR(dsn = path_spatial,
                               layer = "",
                               stringsAsFactors = FALSE)

# Strata
strata_spdf <- rgdal::readOGR(dsn = path_spatial,
                               layer = "",
                               stringsAsFactors = FALSE)

# The master sample points
# This takes a little while because this is a lot of points
load("C:/full/path/to/TerrestrialMasterSample2015.RData",
     verbose = TRUE)

# Tabular stuff
# Strata lookup table
lut_path <- paste0(path_tabular, "/", "")
strata_lut <- read.csv(lut_path,
                       stringsAsFactors = FALSE)

# Point allocation table
allocation_path <- paste0(path_tabular, "/", "")
read.csv(allocation_path,
         stringsAsFactors = FALSE)

# Prep data --------
# Restrict the master sample
# It's fastest to start doing this with filtering rather than spatially
points_population <- mastersample[mastersample$STATE %in% c("CO"), ]

# Then with that smaller subset do the spatial bit
points_population <- sample.design::attribute.shapefile(spdf1 = points_population,
                                                        spdf2 = strata_spdf,
                                                        attributefield = "BPS_GROUPS")

# Draw --------
design <- sample.design::draw(design_name = "Whatever",
                              strata_spdf = strata_spdf,
                              stratum_field = "STRATUM",
                              sampleframe_spdf = frame_spdf,
                              points.spdf = mastersample,
                              strata_lut = NULL,
                              strata_lut_field = NULL,
                              design_object = NULL,
                              panel_names = c("2019", "2020", "2021", "2022", "2023"),
                              panel_sample_size = 50,
                              points_min = 3,
                              oversample_proportion = 0.25,
                              oversample_min = 3,
                              seed_number = 112358)


# Wrangle outputs --------