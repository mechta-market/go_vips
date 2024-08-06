FROM golang:1.22.3-bullseye as builder

ARG LIBVIPS_VERSION=8.15.2

# Installs libvips + required libraries
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    ca-certificates curl meson \
    build-essential pkg-config libglib2.0-dev libexpat1-dev

RUN cd /tmp
RUN curl -fsSLO https://github.com/libvips/libvips/releases/download/v${LIBVIPS_VERSION}/vips-${LIBVIPS_VERSION}.tar.xz
RUN ls -l
RUN tar xf vips-${LIBVIPS_VERSION}.tar.xz
RUN pwd
RUN ls -l
RUN cd /tmp/vips-${LIBVIPS_VERSION}
RUN meson setup build-dir --buildtype=release --prefix=/vips
RUN ls -l
RUN cd build-dir
RUN ls -l
RUN ninja
RUN ninja install
RUN ldconfig
RUN ls -l /vips/lib
RUN ls -l /usr/local/lib | grep vips
RUN ls -l /vips/lib/pkgconfig

#    libjpeg62-turbo-dev libpng-dev \
#    libwebp-dev libtiff5-dev libgif-dev libexif-dev libxml2-dev libpoppler-glib-dev \
#    swig libmagickwand-dev libpango1.0-dev libmatio-dev libopenslide-dev libcfitsio-dev \
#    libgsf-1-dev fftw3-dev liborc-0.4-dev librsvg2-dev libimagequant-dev libaom-dev && \
#    cd /tmp && \
#    curl -fsSLO https://github.com/libvips/libvips/releases/download/v${LIBVIPS_VERSION}/vips-${LIBVIPS_VERSION}.tar.gz && \
#    tar zvxf vips-${LIBVIPS_VERSION}.tar.gz && \
#    cd /tmp/vips-${LIBVIPS_VERSION} && \
#    CFLAGS="-g -O3" CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0 -g -O3" \
#      ./configure \
#      --disable-debug \
#      --disable-dependency-tracking \
#      --disable-introspection \
#      --disable-static \
#      --enable-gtk-doc-html=no \
#      --enable-gtk-doc=no \
#      --enable-pyvips8=no \
#      --prefix=/vips && \
#    make && \
#    make install && \
#    ldconfig

ENV LD_LIBRARY_PATH="/vips/lib:/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/vips/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig:/usr/X11/lib/pkgconfig"

ENV VIPS_WARNING=0
ENV MALLOC_ARENA_MAX=2

CMD ["/bin/bash"]
