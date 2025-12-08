FROM ubuntu:22.04

# Build arguments (customizable)
ARG EMSCRIPTEN_VERSION=3.1.56
ARG BOOST_VERSION=1.84.0

## timezone Asia/Tokyo ############
#RUN apt update \
# && apt -y install tzdata \
# && apt clean && rm -rf /var/lib/apt/lists/*
#ENV TZ=Asia/Tokyo

# tools install ####################
RUN apt update \
 && apt -y install --no-install-recommends \
  build-essential \
  git \
  cmake \
  wget \
  ca-certificates \
  python3 \
 && apt clean && rm -rf /var/lib/apt/lists/*

# emscripten ##########################
ARG EMSDKDIR=/opt/emsdk
RUN git clone https://github.com/emscripten-core/emsdk.git ${EMSDKDIR}
RUN cd ${EMSDKDIR} \
 && ./emsdk install ${EMSCRIPTEN_VERSION} \
 && ./emsdk activate ${EMSCRIPTEN_VERSION}
RUN echo "source ${EMSDKDIR}/emsdk_env.sh" >> ~/.bash_profile
RUN echo '#!/bin/bash\nexec /bin/bash -l -c "$*"' > /opt/entrypoint.sh \
 && chmod +x /opt/entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]


# boost ##########################
RUN set -eux; \
    # 1:～1.84.0 2:1.85.0～
    FILE1="boost-${BOOST_VERSION}.tar.xz"; \
    FILE2="boost-${BOOST_VERSION}-b2-nodocs.tar.xz"; \
    BASEURL="https://github.com/boostorg/boost/releases/download/boost-${BOOST_VERSION}"; \
    \
    # まず旧形式、ダメなら新形式
    (wget -q "${BASEURL}/${FILE1}" -O boost.tar.xz || wget -q "${BASEURL}/${FILE2}" -O boost.tar.xz); \
    \
    # 展開してフォルダ名を取得
    tar xvf boost.tar.xz; \
    DIR=$(tar tf boost.tar.xz | head -1 | cut -d/ -f1); \
    \
    cd "${DIR}"; \
    ./bootstrap.sh; \
    ./b2 headers; \
    mkdir -p /opt/include; \
    cp -rl boost /opt/include/boost/; \
    cd ..; \
    rm -f boost.tar.xz; \
    rm -rf "${DIR}"
ENV EMCC_CFLAGS="-I /opt/include"

