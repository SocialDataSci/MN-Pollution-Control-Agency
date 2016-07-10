# R Script to download the What's In My Neighborhood dataset from the
# Minnesota Pollution Control Agency. Coverts the DBF file to CSV
# format using the foreign package.

DOWNLOAD_URL <- 'ftp://files.pca.state.mn.us/pub/spatialdata/wimn_sites.zip'
ZIP_FILE <- 'wimn_sites.zip'
DBF_FILE <- 'wimn_sites_mpca.dbf'
CSV_FILE <- 'wimn_sites_mpca.csv'

if (!file.exists(CSV_FILE)) {
  if (!file.exists(DBF_FILE)) {
    if (!file.exists(ZIP_FILE)) {
      download.file(DOWNLOAD_URL, ZIP_FILE)
    }
    unzip(ZIP_FILE, files=DBF_FILE)
  }
  data <- foreign::read.dbf(DBF_FILE)
  write.csv(data, CSV_FILE, row.names=F)
}