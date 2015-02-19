FROM debian:latest
MAINTAINER Kazuya Yokogawa "yokogawa-k@klab.com"

RUN apt-get update \
    && apt-get --no-install-recommends -y install \
        git \
        automake \
        libtool \
        gcc \
        g++ \
        make \
        cmake \
        libssl-dev \
        libyaml-dev \
        libc6-dev \
        ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists 

RUN git clone https://github.com/libuv/libuv.git \
    && cd libuv \
    && ./autogen.sh \
    && ./configure \
    && make -j $(nproc) \
    && make install \
    && cd / \
    && rm -rf /libuv

RUN git clone https://github.com/h2o/h2o.git \
    && cd h2o \
    && cmake . \
    && make -j $(nproc) \
    && make install \
    && cd / \
    && rm -rf /h2o

ENTRYPOINT ["h2o"]
CMD ["--help"]

