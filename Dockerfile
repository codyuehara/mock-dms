FROM registry.access.redhat.com/ubi8/ubi

RUN dnf install -y \
        gcc-c++ \
        cmake \
        make \
        openssl-devel \
        libatomic \
        pkgconf \
        which \
        tar \
        git && \
    dnf clean all

# ------------------------------------------------------------
# Copy dependencies into container
# ------------------------------------------------------------
COPY deps/asio-asio-1-31-0/asio /opt/asio
COPY deps/memory-0.7-4 /opt/memory
COPY deps/src /opt/fastdds-repos
COPY deps/tinyxml2-9.0.0 /opt/tinyxml2

# ------------------------------------------------------------
# Build tinyml2
# ------------------------------------------------------------
RUN cd /opt/tinyxml2 \
    && mkdir build && cd build \
    && cmake -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DBUILD_SHARED_LIBS=OFF .. \
    && make -j$(nproc) \
    && make install

# ------------------------------------------------------------
# Build fastcdr
# ------------------------------------------------------------
RUN cd /opt/fastdds-repos/fastcdr \
    && mkdir build && cd build \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local \
    && make -j$(nproc) \
    && make install

# ------------------------------------------------------------
# Build foonathan/memory v0.7-4
# ------------------------------------------------------------
RUN cd /opt/memory \
    && mkdir build && cd build \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local \
    && make -j$(nproc) \
    && make install

# ------------------------------------------------------------
# Build fastdds
# ------------------------------------------------------------
RUN cd /opt/fastdds-repos/fastdds \
    && mkdir build && cd build \
    && cmake -DAsio_INCLUDE_DIR=/opt/asio/include .. -DCMAKE_INSTALL_PREFIX=/usr/local \
    && make -j$(nproc) \
    && make install

# ------------------------------------------------------------
# Build example pub/sub
# ------------------------------------------------------------
RUN mkdir -p /app/example
COPY ./example /app/example
RUN cd /app/example \
    && mkdir build && cd build \
    && cmake -S .. \
    && cmake --build . 

WORKDIR /app

#ENV LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"

CMD ["/bin/bash"]
