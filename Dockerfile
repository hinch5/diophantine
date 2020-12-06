FROM ubuntu:18.04 as refal_host

RUN apt-get update
RUN apt-get install -y git dos2unix curl unzip sed g++

# fetch refal-5-lambda
WORKDIR /usr/src
RUN git clone https://github.com/bmstu-iu9/simple-refal-distrib.git

# install refal-5-lambda
WORKDIR /usr/src/simple-refal-distrib
RUN ./bootstrap.sh

ENV PATH="/usr/src/simple-refal-distrib/bin:${PATH}"
ENV RL_MODULE_PATH="/usr/src/simple-refal-distrib/lib:$RL_MODULE_PATH"

# install scp4
WORKDIR /usr/src
RUN curl -LO https://mazdaywik.github.io/direct-link/scp4new-version-05-03-2019-srefc.zip
RUN unzip scp4new-version-05-03-2019-srefc.zip
WORKDIR /usr/src/scp4new-version-05-03-2019-srefc
RUN rlc install
RUN dos2unix doc/install.lst
ENV SHELL="/bin/bash"
RUN ./install linux
RUN sed -i 's/srefc/rlc/g' refcall.bat
RUN ./refcall.bat

ENV PATH="/usr/src/scp4new-version-05-03-2019-srefc:${PATH}"

FROM refal_host

WORKDIR /usr/src/dio
COPY . .

WORKDIR /usr/src/dio

ENTRYPOINT ["./run.sh"]