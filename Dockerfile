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
    meson setup --prefix=/usr/local build && \
    meson install -C build && ldconfig && \
    echo $LD_LIBRARY_PATH && \
    echo $PKG_CONFIG_PATH

RUN cd /tmp && \
  curl -fsSLO https://github.com/libvips/libvips/releases/download/v${LIBVIPS_VERSION}/vips-${LIBVIPS_VERSION}.tar.xz && \
  tar xf vips-${LIBVIPS_VERSION}.tar.xz && \
  cd vips-${LIBVIPS_VERSION} && \
  meson setup build-dir --buildtype=release --libdir=lib --prefix=/usr/local && \
  cd build-dir && \
  ninja && ninja install && ldconfig

ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

RUN ldconfig

ENV VIPS_WARNING=0
ENV MALLOC_ARENA_MAX=2

CMD ["/bin/bash"]

#8 3.068   Build options
#8 3.068                           enable debug: NO
#8 3.068                      enable deprecated: YES
#8 3.068                         enable modules: YES
#8 3.068                         enable gtk-doc: NO
#8 3.068                         enable doxygen: NO
#8 3.068                   enable introspection: NO
#8 3.068                        enable examples: YES
#8 3.068                       enable cplusplus: YES
#8 3.068                   enable RAD load/save: YES
#8 3.068              enable Analyze7 load/save: YES
#8 3.068                   enable PPM load/save: YES
#8 3.068                        enable GIF load: YES
#8 3.068
#8 3.068   Optional external packages
#8 3.068                      use fftw for FFTs: YES
#8 3.068              SIMD support with highway: NO
#8 3.068              accelerate loops with ORC: YES
#8 3.068          ICC profile support with lcms: NO
#8 3.068                                   zlib: YES
#8 3.068         text rendering with pangocairo: YES
#8 3.068      font file support with fontconfig: YES
#8 3.068     EXIF metadata support with libexif: YES
#8 3.068
#8 3.068   External image format libraries
#8 3.068            JPEG load/save with libjpeg: YES
#8 3.068              JXL load/save with libjxl: NO (dynamic module: NO)
#8 3.068       JPEG2000 load/save with OpenJPEG: YES
#8 3.068             PNG load/save with libspng: NO
#8 3.068              PNG load/save with libpng: YES
#8 3.068          selected quantisation package: imagequant
#8 3.068            TIFF load/save with libtiff: YES
#8 3.068     image pyramid save with libarchive: YES
#8 3.068       HEIC/AVIF load/save with libheif: NO (dynamic module: NO)
#8 3.068            WebP load/save with libwebp: YES
#8 3.068                   PDF load with PDFium: NO
#8 3.068             PDF load with poppler-glib: YES (dynamic module: YES)
#8 3.068                  SVG load with librsvg: YES
#8 3.068                  EXR load with OpenEXR: YES
#8 3.068                         OpenSlide load: NO (dynamic module: NO)
#8 3.068              Matlab load with libmatio: YES
#8 3.068           NIfTI load/save with niftiio: NO
#8 3.068            FITS load/save with cfitsio: YES
#8 3.068                     GIF save with cgif: YES
#8 3.068                selected Magick package: none (dynamic module: NO)
#8 3.068                     Magick API version: none
#8 3.068                            Magick load: NO
#8 3.068                            Magick save: NO

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
