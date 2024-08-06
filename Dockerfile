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
    libpango1.0-dev libopenexr-dev libopenjp2-7-dev

# Install libcgif
RUN cd /tmp && \
  curl -fsSLO https://github.com/dloebl/cgif/archive/refs/tags/v${LIBCGIF_VERSION}.tar.gz && \
  tar zxf v${LIBCGIF_VERSION}.tar.gz && \
  cd v${LIBCGIF_VERSION} && \
  meson setup --prefix=/usr/local build && \
  meson install -C build && \
  ldconfig

RUN cd /tmp && \
  curl -fsSLO https://github.com/libvips/libvips/releases/download/v${LIBVIPS_VERSION}/vips-${LIBVIPS_VERSION}.tar.xz && \
  tar xf vips-${LIBVIPS_VERSION}.tar.xz && \
  cd vips-${LIBVIPS_VERSION} && \
  meson setup build-dir --buildtype=release --libdir=lib --prefix=/usr/local && \
  cd build-dir && \
  ninja && ninja install && ldconfig

#ENV LD_LIBRARY_PATH="/vips/lib:$LD_LIBRARY_PATH"
#ENV PKG_CONFIG_PATH="/vips/lib/pkgconfig:$PKG_CONFIG_PATH"

#RUN ldconfig

ENV VIPS_WARNING=0
ENV MALLOC_ARENA_MAX=2

CMD ["/bin/bash"]


#    libgif-dev libxml2-dev \
#    swig libmagickwand-dev libopenslide-dev \
#    libaom-dev

#16 0.191 # core options
#16 0.191
#16 0.191 option('deprecated',
#16 0.191   type: 'boolean',
#16 0.191   value: true,
#16 0.191   description: 'Build deprecated components')
#16 0.191
#16 0.191 option('examples',
#16 0.191   type: 'boolean',
#16 0.191   value: true,
#16 0.191   description: 'Build example programs')
#16 0.191
#16 0.191 option('cplusplus',
#16 0.191   type: 'boolean',
#16 0.191   value: true,
#16 0.191   description: 'Build C++ API')
#16 0.191
#16 0.191 option('doxygen',
#16 0.191   type: 'boolean',
#16 0.191   value: false,
#16 0.191   description: 'Build C++ documentation')
#16 0.191
#16 0.191 option('gtk_doc',
#16 0.191   type: 'boolean',
#16 0.191   value: false,
#16 0.191   description: 'Build GTK-doc documentation')
#16 0.191
#16 0.191 option('modules',
#16 0.191   type: 'feature',
#16 0.191   value: 'auto',
#16 0.191   description: 'Build dynamic modules')
#16 0.191
#16 0.191 option('introspection',
#16 0.191   type: 'feature',
#16 0.191   value: 'auto',
#16 0.191   description: 'Build GObject introspection data')
#16 0.191
#16 0.191 option('vapi',
#16 0.191   type: 'boolean',
#16 0.191   value: false,
#16 0.191   description: 'Build VAPI')
#16 0.191
#16 0.191 # External libraries
#16 0.191
#16 0.191 option('cfitsio',
#16 0.191   type: 'feature',
#16 0.191   value: 'auto',
#16 0.191   description: 'Build with cfitsio')
#16 0.191
#16 0.191 option('cgif',
#16 0.191   type: 'feature',
#16 0.191   value: 'auto',
#16 0.191   description: 'Build with cgif')
#16 0.191
#16 0.191 option('exif',
#16 0.191   type: 'feature',
#16 0.191   type: 'feature',
#16 0.191   value: 'auto',
#16 0.191   description: 'Build with rsvg')
#16 0.191
#16 0.191 option('spng',
#16 0.191   type: 'feature',
#16 0.191   value: 'auto',
#16 0.191   description: 'Build with spng')
#16 0.191
#16 0.191 option('tiff',
#16 0.191   type: 'feature',
#16 0.191   value: 'auto',
#16 0.191   description: 'Build with tiff')
#16 0.191
#16 0.191 option('webp',
#16 0.191   type: 'feature',
#16 0.191   value: 'auto',
#16 0.191   description: 'Build with libwebp')
#16 0.191
#16 0.191 option('zlib',
#16 0.191   type: 'feature',
#16 0.191   value: 'auto',
#16 0.191   description: 'Build with zlib')
#16 0.191
#16 0.191 # not external libraries, but we have options to disable them to reduce
#16 0.191 # the potential attack surface
#16 0.191
#16 0.191 option('nsgif',
#16 0.191   type: 'boolean',
#16 0.191   value: true,
#16 0.191   description: 'Build with nsgif')
#16 0.191
#16 0.191 option('ppm',
#16 0.191   type: 'boolean',
#16 0.191   value: true,
#16 0.191   description: 'Build with ppm')
#16 0.191
#16 0.191 option('analyze',
#16 0.191   type: 'boolean',
#16 0.191   value: true,
#16 0.191   description: 'Build with analyze')
#16 0.191
#16 0.191 option('radiance',
#16 0.191   type: 'boolean',
#16 0.191   value: true,
#16 0.191   description: 'Build with radiance')
