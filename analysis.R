
# Packages -----------------

library(downloader)
library(stringr)
library(datastorr)
library(baad.data)
library(multcomp)
library(doBy)
library(mgcv)
library(lmerTest)
library(car)
library(MuMIn)
library(hier.part)
library(gtools)
library(magicaxis)
library(RColorBrewer)
library(hexbin)
library(xtable)
library(knitr)
library(png)
library(grid)
library(gridBase)
library(gridExtra)
library(tinytex)

# source function scripts -----------------
source("R/data_processing.R")
source("R/tables_stats.R")
source("R/figures.R")
source("R/functions-figures.R")
source("R/signifletters.R")
source("R/build.R")
source("R/manuscript_functions.R")

# Data --------------------------------------
baad_all <- baad_data("1.0.0")
baad_climate1 <- addWorldClimMAPMAT(baad_all, "data/worldclimmapmat.rds")
baad_mapmat <- prepare_baadmapmat(baad_climate1)
world_mapmat <- prepare_worldmapmat("data/worldclim_landcover_climspace_withcover.rds")
baad_climate2 <- addMImgdd0(baad_climate1, "data/MI_mGDDD_landcover_filtered.rds")
baad_climate3 <- addPET(baad_climate2, "data/zomerpet.rds")
dataset <- prepare_dataset_1(baad_climate3, plantations=TRUE)
# download_baad("downloads/baad.rds")
cfg <- extract_baad_dictionary(baad_all)

# Stats & tables --------------------------------------
basalafit <- BasalA_fit(baad_all)
table_varpart_gam_old <- make_table_gamr2MATMAP_old(dataset)
table_varpart_gam <- make_table_gamr2MATARID(dataset)
table_varpart_lmer <-  mixedr2(dataset)
table_hierpart <- make_table_hierpart(dataset)
afas <- af_as_stat(dataset)
msas <- ms_as_stat(dataset)
table_samplesize <- make_samplesize_table(dataset)

# Figures --------------------------------------
# comment this out because can't download from internet within the virtual machine.
# dir.create('downloads')
# download_tree_png("downloads/ian-symbol-eucalyptus-spp-1.png")

dir.create('figures')

pdf("figures/Figure1.pdf", width = 8, height = 4)
figure1(baad_mapmat, world_mapmat, "downloads/ian-symbol-eucalyptus-spp-1.png")
dev.off()

pdf("figures/Figure2.pdf", width = 8, height = 4)
figure2(dataset)
dev.off()

pdf("figures/Figure3.pdf", width = 8, height = 6)
figure3(dataset)
dev.off()

pdf("figures/Figure4.pdf", width = 8, height = 4)
figure4(dataset, nbin=75)
dev.off()

pdf("figures/Figure5.pdf", width = 8, height = 4)
figure5(dataset)
dev.off()

pdf("figures/Figure6.pdf", width = 8, height = 4)
figure6(dataset)
dev.off()

pdf("figures/FigureS1.pdf", width = 6, height = 6)
figureS1(baad_mapmat, world_mapmat)
dev.off()

pdf("figures/FigureS2.pdf", width = 8, height = 4)
figureS2(table_hierpart,table_varpart_gam_old,table_varpart_lmer)
dev.off()

pdf("figures/FigureS3.pdf", width = 8, height = 4)
figureS3(dataset)
dev.off()

pdf("figures/FigureS4.pdf", width = 8, height = 4)
figureS4(dataset)
dev.off()

pdf("figures/FigureS5.pdf", width = 8, height = 4)
figureS5(dataset)
dev.off()

# Documents -------------
knitr::knit("ms/manuscript.Rnw", output = "ms/manuscript.tex")
pdflatex("ms/manuscript.tex")

knitr::knit("ms/manuscript_suppinfo.Rnw", output = "ms/manuscript_suppinfo.tex")
pdflatex("ms/manuscript_suppinfo.tex")

