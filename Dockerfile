#################################################################
# Dockerfile
# Description:      R and required packages to make the NGS alignment with R
# Base Image:       r-base:3.6.3
#################################################################
#R image to be the base in order to build our new image
FROM r-base:3.6.3

#Maintainer and author
MAINTAINER Magdalena Arnal

#Install Ubuntu extensions in order to run r
RUN apt-get update && apt-get install -y \
    wget unzip bzip2 g++ make \
    r-cran-xml \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev
    
ENV PATH=pkg-config:$PATH

#Install packages from CRAN
RUN Rscript -e 'install.packages(c("R.utils","data.table", "gtools", "gplots", "BiocManager"))'

#Install Bioconductor packages first
RUN Rscript -e 'BiocManager::install(c("Biostrings","Rsamtools","Rsubread", "BiocParallel"))'

#Install samtools
WORKDIR /bin
RUN wget https://sourceforge.net/projects/samtools/files/samtools/1.11/samtools-1.11.tar.bz2
RUN tar xvjf samtools-1.11.tar.bz2
WORKDIR /bin/samtools-1.11
RUN make
RUN rm /bin/samtools-1.11.tar.bz2
ENV PATH=$PATH:/bin/samtools-1.11

# Clean up and set Workingdir at Home
RUN apt-get clean
WORKDIR /
