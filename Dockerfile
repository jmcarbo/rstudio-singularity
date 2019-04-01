FROM rocker/rstudio
RUN apt-get update && sudo apt-get install -y \
    build-essential \
    libssl-dev \
    uuid-dev \
    libgpgme11-dev \
    squashfs-tools

RUN apt-get install -y curl wget
ENV VERSION=1.11 
ENV OS=linux 
ENV ARCH=amd64
RUN cd /tmp && wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz && tar -C /usr/local -xzf go$VERSION.$OS-$ARCH.tar.gz

ENV GOPATH=/root/go
ENV PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin

RUN mkdir -p $GOPATH/src/github.com/sylabs && cd $GOPATH/src/github.com/sylabs && git clone https://github.com/sylabs/singularity.git 
RUN cd $GOPATH/src/github.com/sylabs/singularity && go get -u -v github.com/golang/dep/cmd/dep && ./mconfig && make -C builddir
RUN cd $GOPATH/src/github.com/sylabs/singularity && ./mconfig && make -C builddir
RUN cd $GOPATH/src/github.com/sylabs/singularity && make -C builddir install
