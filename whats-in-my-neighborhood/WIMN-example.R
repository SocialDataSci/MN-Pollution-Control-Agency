# Sample R script to access the What's in my Neighborhood Database
# from the Minnesota Pollution Control Agency.

# The script requires the "bigrquery" package. Type the following command
# in an R session to install this package:

# > install.packages('bigrquery')

# To request access to this database, send an email to David Radcliffe (dradcliffe@gmail.com).
# You will need a Google account.


library(bigrquery)
sql <- 'select * from [MN_PCA:wimn] where ZIP_CODE = "55109"'
data <- query_exec(sql, project='social-data-science')
