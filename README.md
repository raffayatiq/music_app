### Allows users to catalog their favorite bands

### Automatically populates the bands’ albums and the albums’ tracks and the tracks’ lyrics, using web scrapping with open-uri and nokoGIRI

### Queries the YouTube API to fetch song videos and album playlists. Used Rails to fetch Country Code and added that in the query parameters, in order to only fetch country available videos and playlists (there is currently a bug in the YouTube API which ignores the country code, resulting in country unavailable videos and playlists).
