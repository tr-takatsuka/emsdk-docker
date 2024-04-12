FROM ubuntu:22.04

RUN apt update \
 && apt -y upgrade \
 && apt clean && rm -rf /var/lib/apt/lists/*

# timezone Asia/Tokyo ############
RUN apt update \
 && apt -y install tzdata \
 && apt clean && rm -rf /var/lib/apt/lists/*
ENV TZ=Asia/Tokyo

# build-essential ####################
RUN apt update \
 && apt -y install --no-install-recommends build-essential \
 && apt clean && rm -rf /var/lib/apt/lists/*

# tools ##########################
RUN apt update \
 && apt -y install git cmake wget python3 \
 && apt clean && rm -rf /var/lib/apt/lists/*

# emscripten ##########################
ARG EMSCRIPTEN_VERSION=3.1.56
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
ARG BOOST_VERSION=1.84.0
RUN wget https://github.com/boostorg/boost/releases/download/boost-${BOOST_VERSION}/boost-${BOOST_VERSION}.tar.xz \
 && tar xvf boost-${BOOST_VERSION}.tar.xz \
 && cd boost-${BOOST_VERSION} \
 && ./bootstrap.sh \
 && ./b2 headers \
 && mkdir -p /opt/include \
 && cp -rl boost /opt/include/boost/ \
 && cd ..\
 && rm -f boost*.tar.xz \
 && rm -rf boost-${BOOST_VERSION} 
ENV EMCC_CFLAGS="-I /opt/include"

