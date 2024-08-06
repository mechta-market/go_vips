FROM golang:1.22.3-bullseye as builder

ARG LIBCGIF_VERSION=0.4.1
ARG LIBVIPS_VERSION=8.15.2

# Installs libvips + required libraries
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    ca-certificates curl meson \
    build-essential pkg-config libglib2.0-dev libexpat1-dev \
    libgsf-1-dev libtiff5-dev libjpeg62-turbo-dev libexif-dev librsvg2-dev libpoppler-glib-dev libarchive-dev \
    fftw3-dev libpng-dev libimagequant-dev liborc-0.4-dev libmatio-dev libcfitsio-dev libwebp-dev libniftiio-dev \
    libpango1.0-dev libopenexr-dev libopenjp2-7-dev libopenslide-dev libmagickwand-dev

# Install libcgif
RUN cd /tmp && \
    curl -fsSLO https://github.com/dloebl/cgif/archive/refs/tags/v${LIBCGIF_VERSION}.tar.gz && \
    tar zxf v${LIBCGIF_VERSION}.tar.gz && \
    cd cgif-${LIBCGIF_VERSION} && \
    meson setup --buildtype=release --libdir=lib --prefix=/usr/local build && \
    meson install -C build && ldconfig

RUN cd /tmp && \
  curl -fsSLO https://github.com/libvips/libvips/releases/download/v${LIBVIPS_VERSION}/vips-${LIBVIPS_VERSION}.tar.xz && \
  tar xf vips-${LIBVIPS_VERSION}.tar.xz && \
  cd vips-${LIBVIPS_VERSION} && \
  meson setup --buildtype=release --libdir=lib --default-library=static --prefix=/usr/local build-dir && \
  cd build-dir && \
  ninja && ninja install && ldconfig

RUN ls -lsh /usr/local/lib

ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

#ENV LD_LIBRARY_PATH="/vips/lib:/usr/local/lib:$LD_LIBRARY_PATH"
#ENV PKG_CONFIG_PATH="/vips/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig:/usr/X11/lib/pkgconfig"

RUN ldconfig

ENV VIPS_WARNING=0
ENV MALLOC_ARENA_MAX=2

CMD ["/bin/bash"]
