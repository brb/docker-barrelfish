FROM ubuntu:14.04
MAINTAINER martynasp@gmail.com

ENV GCC_VERSION     4.8.2
ENV GHC_VERSION     7.6.3
ENV CABAL_VERSION   1.22.0.0

RUN apt-get update
RUN apt-get install -y  \
        autoconf        \
        build-essential \
        libgmp-dev      \
        curl            \
        flex            \
        wget            \
        zlib1g-dev      \
    && ln -s /usr/lib/x86_64-linux-gnu/libgmp.so /usr/lib/x86_64-linux-gnu/libgmp.so.3

# gcc (taken from docker-library)

RUN gpg --keyserver pool.sks-keyservers.net --recv-key \
	B215C1633BCA0477615F1B35A5B3A004745C015A \
	B3C42148A44E6983B3E4CC0793FA9B1AB75C61B8 \
	90AA470469D3965A87A5DCB494D03953902C9419 \
	80F98B2E0DAB6C8281BDF541A7C8C3B2F71EDF1C \
	7F74F97C103468EE5D750B583AB00996FC26A641 \
	33C235A34C46AA3FFB293709A328C3A2C3C45C06

RUN curl -SL "http://ftpmirror.gnu.org/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.bz2" -o gcc.tar.bz2 \
	&& curl -SL "http://ftpmirror.gnu.org/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.bz2.sig" -o gcc.tar.bz2.sig
RUN gpg --verify gcc.tar.bz2.sig                                    \
	&& mkdir -p /usr/src/gcc                                        \
	&& tar -xvf gcc.tar.bz2 -C /usr/src/gcc --strip-components=1    \
	&& rm gcc.tar.bz2*                                              \
	&& cd /usr/src/gcc                                              \
	&& ./contrib/download_prerequisites                             \
	&& { rm *.tar.* || true; }                                      \
	&& dir="$(mktemp -d)"                                           \
	&& cd "$dir"                                                    \
	&& /usr/src/gcc/configure                                       \
		--disable-multilib                                          \
		--enable-languages=c,c++                                    \
	&& make -j"$(nproc)"                                            \
	&& make install-strip                                           \
	&& cd ..                                                        \
	&& rm -rf "$dir"

# ghc

RUN curl -sL "http://www.haskell.org/ghc/dist/$GHC_VERSION/ghc-$GHC_VERSION-x86_64-unknown-linux.tar.bz2" -o ghc.tar.bz2
RUN tar xvfj ghc.tar.bz2    \
    && cd ghc-7.6.3         \
    && ./configure          \
    && make install
RUN rm -fr ghc.tar.bz2 ghc-7.6.3

RUN curl -sL "https://www.haskell.org/cabal/release/cabal-install-$CABAL_VERSION/cabal-install-$CABAL_VERSION.tar.gz" -o cabal.tar.gz
RUN tar zxfv cabal.tar.gz                   \
    && cd "cabal-install-$CABAL_VERSION"    \
    && ./bootstrap.sh
ENV PATH /root/.cabal/bin:$PATH
RUN cabal update && cabal install ghc-paths
RUN rm -fr "cabal-install-$CABAL_VERSION" cabal.tar.gz

# misc

RUN apt-get install -y cpio qemu
RUN apt-get purge -y --auto-remove curl gcc g++ wget

CMD ["/bin/bash"]
