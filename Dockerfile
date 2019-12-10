FROM rocker/verse:3.6.1
LABEL maintainer="Daniel Falster"
LABEL email="daniel.falster@unsw.edu.au"

# Install major libraries
RUN    apt-get update \
    && apt-get -y install tcl8.6-dev tk8.6-dev \
         zip \
         unzip

# ---------------------------------------------

ENV NB_USER rstudio
ENV NB_UID 1000

# And set ENV for R! It doesn't read from the environment...
RUN echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron
RUN echo "export PATH=${PATH}" >> ${HOME}/.profile

# The `rsession` binary that is called by nbrsessionproxy to start R doesn't seem to start
# without this being explicitly set
ENV LD_LIBRARY_PATH /usr/local/lib/R/lib

ENV HOME /home/${NB_USER}
WORKDIR ${HOME}

# ---------------------------------------------

## Copies your repo files into the Docker Container
USER root
COPY . ${HOME}
RUN chown -R ${NB_USER} ${HOME}

## Become normal user again
USER ${NB_USER}

# ---------------------------------------------
# Add custom installations here

## Install packages using DESCRIPTION file 

RUN if [ -f DESCRIPTION ]; then R --quiet -e "options(repos = list(CRAN = 'http://mran.revolutionanalytics.com/snapshot/2019-08-26/')); devtools::install_deps()"; fi
