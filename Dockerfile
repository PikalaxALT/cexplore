FROM devkitpro/devkitarm

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install apt-transport-https wget dirmngr build-essential git binutils-arm-none-eabi libsndfile1-dev libpng-dev python3 && curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get -y install nodejs \
    && rm -rf /var/lib/apt/lists/*
COPY agbcc /agbcc
COPY new_agbcc /new_agbcc
COPY agbcc_arm /agbcc_arm
RUN cd /agbcc && ./build.sh && ./install.sh /agbcc_build
RUN cd /new_agbcc && ./build.sh && mkdir -p /agbcc_build/tools/agbcc && mkdir -p /agbcc_build/tools/agbcc/bin && cp agbcc /agbcc_build/tools/agbcc/bin/new_agbcc
RUN cd /agbcc_arm && ./build.sh && ./install.sh /agbcc_build
RUN mkdir -p /pretrepos && cd /pretrepos && git clone https://github.com/pret/pokeemerald && git clone https://github.com/pret/pokeruby && git clone https://github.com/pret/pokefirered && git clone https://github.com/laqieer/fireemblem8u.git
RUN cd /pretrepos/pokeemerald && make tools && cd /pretrepos/pokeruby && make tools && cd /pretrepos/pokefirered && make tools && cd /pretrepos/fireemblem8u && make tools
RUN mkdir -p /frontends
COPY pycc.py /frontends/
COPY pycat.py /frontends/
COPY compiler-explorer /ce/
RUN mkdir -p /scripts/
COPY update-repos.sh /scripts/
ENTRYPOINT cd /ce && make EXTRA_ARGS='--language C'
