FROM debian:trixie
ARG HANDBRAKE_GIT_URL
RUN apt-get update &&\
  apt-get install -y\
    git\
    build-essential\
    make\
    cmake\
    yasm\
    meson\
    nasm\
    cargo\
    cargo-c\
    pkg-config\
    libtool\
    libtool-bin\
    libglib2.0-dev\
    libgtk-3-dev\
    libavcodec-dev\
    libavformat-dev\
    libswscale-dev\
    libavutil-dev\
    libvpx-dev\
    libx264-dev\
    libx265-dev\
    libnuma-dev\
    autoconf\
    automake\
    build-essential\
    libass-dev\
    libbz2-dev\
    libfontconfig-dev\
    libfreetype6-dev\
    libfribidi-dev\
    libharfbuzz-dev\
    libjansson-dev\
    liblzma-dev\
    libmp3lame-dev\
    libnuma-dev\
    libogg-dev\
    libopus-dev\
    libsamplerate0-dev\
    libspeex-dev\
    libtheora-dev\
    libturbojpeg0-dev\
    libvorbis-dev\
    libx264-dev\
    libxml2-dev\
    libvpx-dev\
    zlib1g-dev\
    m4\
    nasm\
    ninja-build\
    patch\
    python3\
    pkg-config\
    tar\
    zlib1g-dev\
    appstream\
    desktop-file-utils\
    gettext\
    gstreamer1.0-libav\
    gstreamer1.0-plugins-good\
    libgstreamer-plugins-base1.0-dev\
    libgtk-4-dev\
    libva-dev\
    libva-glx2\
    libva-x11-2 &&\
  git clone ${HANDBRAKE_GIT_URL} /tmp/handbrake

WORKDIR /tmp/handbrake
RUN ./configure\
  --force\
  --launch-jobs=$(nproc)\
  --enable-gtk\
  --enable-x265\
  --disable-nvenc\
  --disable-nvdec\
  --disable-qsv\
  --disable-amfdec\
  --disable-libdovi\
  --launch
CMD ["/bin/bash"]
