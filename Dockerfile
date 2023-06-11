FROM rocker/r-ver:4.2.1

MAINTAINER Julien Barde "julien.barde@ird.fr"

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libv8-dev \
	libsodium-dev \
    libsecret-1-dev \
    git
    
#geospatial
RUN /rocker_scripts/install_geospatial.sh

# install R core package dependencies
RUN install2.r --error --skipinstalled --ncpus -1 httpuv
RUN R -e "install.packages(c('remotes','jsonlite','yaml'), repos='https://cran.r-project.org/')"
# clone app
RUN git -C /root/ clone https://github.com/BastienIRD/darwin_core_viewer_BlueCloud_Workshop && echo "OK!"
RUN ln -s /root/darwin_core_viewer_BlueCloud_Workshop /srv/darwin_core_viewer_BlueCloud_Workshop
# install R app package dependencies
RUN R -e "source('./srv/darwin_core_viewer_BlueCloud_Workshop/install.R')"

#etc dirs (for config)
RUN mkdir -p /etc/darwin_core_viewer_BlueCloud_Workshop/

EXPOSE 3838

CMD ["R", "-e shiny::runApp('/srv/darwin_core_viewer_BlueCloud_Workshop',port=3838,host='0.0.0.0')"]


