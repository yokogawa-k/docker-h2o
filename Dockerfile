FROM debian:latest
MAINTAINER Kazuya Yokogawa "yokogawa-k@klab.com"

RUN apt-get update \
    && apt-get --no-install-recommends -y install \
        curl \
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

ENV H2O_VERSION 1.1.1
RUN curl -LO https://github.com/h2o/h2o/archive/v${H2O_VERSION}.tar.gz \
    && tar xzf v${H2O_VERSION}.tar.gz \
    && cd h2o-${H2O_VERSION} \
    && cmake . \
    && make -j $(nproc) \
    && make install \
    && cd / \
    && rm -rf /h2o-${H2O_VERSION}

ENTRYPOINT ["h2o"]
CMD ["--help"]

