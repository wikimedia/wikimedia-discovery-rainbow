R CMD BATCH desktop.R &&
R CMD BATCH mobile.R &&
R CMD BATCH app.R &&
R CMD BATCH api.R &&
R CMD BATCH failures.R &&
python core.py &&
R CMD BATCH rm -rf .RData