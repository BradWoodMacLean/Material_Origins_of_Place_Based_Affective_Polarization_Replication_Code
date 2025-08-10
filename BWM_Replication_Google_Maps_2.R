# 4_Google_Maps_Data

## PART 2 Google Maps Data

api_key <- "" # Super secret code here

cultural_types <- c(
  "book_store", "library", "museum", "art_gallery",
  "church", "mosque", "synagogue", "hindu_temple",
  "movie_theater", "cafe", "university", "night_club",
  "shopping_mall" , "tourist_attraction" , "spa" , "gym",
  "beauty_salon", "doctor"
)

# --- FUNCTION TO QUERY GOOGLE PLACES ---
get_places_count <- function(lat, lng, place_type, radius, key = api_key) {
  url <- "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
  parsed <- httr::GET(url, query = list(
    location = sprintf("%f,%f", lat, lng),
    radius   = radius,
    type     = place_type,
    key      = key
  )) %>%
    httr::content(as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON(flatten = TRUE)
  
  status <- parsed$status
  message("Status: ", status)
  
  if (status == "OK") {
    return(length(parsed$results))
  } else if (status == "ZERO_RESULTS") {
    return(0)
  } else {
    # Something unexpected happened—log it and return 0
    warning("Places API returned ", status, 
            " for type=", place_type, 
            " at (", lat, ",", lng, ")")
    return(0)
  }
}

# --- PREPARE AND FILTER RESPONDENTS ---
dat <- dat %>%
  filter(!is.na(location_latitude), !is.na(location_longitude), !is.na(placetype_best)) %>%
  mutate(
    location_latitude = as.numeric(location_latitude),
    location_longitude = as.numeric(location_longitude),
    radius_m = case_when(
      placetype_best == 1 ~ 1000,   # Urban
      placetype_best == 2 ~ 1000,   # Suburban
      placetype_best == 3 ~ 1000,   # Rural
      TRUE ~ 1000                   # Default fallback
    )
  )

# --- LOOP OVER RESPONDENTS TO GET CULTURAL SCORES ---
cultural_scores <- numeric(nrow(dat))  # Preallocate

for (i in seq_len(nrow(dat))) {
  lat <- dat$location_latitude[i]
  lng <- dat$location_longitude[i]
  radius <- dat$radius_m[i]
  
  total <- 0
  
  if (is.na(lat) || is.na(lng) || is.na(radius)) {
    warning("Missing lat/lng/radius for row ", i)
    cultural_scores[i] <- NA
    next
  }
  
  for (type in cultural_types) {
    Sys.sleep(0.05) # speed adjust as needed when replicating
    count <- tryCatch({
      val <- get_places_count(lat, lng, type, radius)
      if (length(val) == 1 && is.numeric(val)) {
        val
      } else {
        warning("Unexpected result format for type ", type, " at row ", i)
        0
      }
    }, error = function(e) {
      warning(paste("API error at row", i, ":", e$message))
      0
    })
    
    total <- total + count
  }
  
  # Double-check total is valid before assigning
  if (length(total) == 1 && is.numeric(total)) {
    cultural_scores[i] <- total
    cat("Done:", dat$response_id[i], "| Score:", total, "| Radius:", radius, "\n")
  } else {
    warning("Invalid total at row ", i)
    cultural_scores[i] <- NA
  }
}

# --- ATTACH RESULT TO DATASET ---
dat$cultural_score <- cultural_scores

summary(dat$cultural_score)

hist(dat$cultural_score, breaks = 30, col = "steelblue", main = "Distribution of Cultural Scores")

dat %>%
  group_by(placetype_best) %>%
  summarize(
    mean_score = mean(cultural_score, na.rm = TRUE),
    median_score = median(cultural_score, na.rm = TRUE),
    n = n()
  )

#write.csv(dat, "cultural_scores_output.csv", row.names = FALSE)
