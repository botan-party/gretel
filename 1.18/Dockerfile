FROM openjdk:17.0.1-jdk-slim-bullseye

ARG VERSION
ENV VERSION=${VERSION}

# version check
RUN if !( expr ${VERSION} : ^1\.18\.[0-9]* ) ; then \
        echo 'Invalid version. Use a other Dockerfile.' >&2; \
        exit 1; \
    fi

RUN apt update -y && \
    apt upgrade -y && \
    apt install -y \
        curl \
        git \
        screen

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

RUN groupadd --gid 1000 snake && \
    useradd -s /bin/bash  --uid 1000 --gid 1000 -m steve
USER steve
ENV TMP_DIR=/home/steve/tmp/spigot
ENV OPT_DIR=/home/steve/opt/spigot

# setup
RUN mkdir -p ${TMP_DIR} && \
    mkdir -p ${OPT_DIR}
WORKDIR ${TMP_DIR}
RUN curl -o ${TMP_DIR}/BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar && \
    java -jar ${TMP_DIR}/BuildTools.jar --rev ${VERSION} && \
    mv ${TMP_DIR}/spigot-${VERSION}.jar ${OPT_DIR}/spigot-server.jar

WORKDIR ${OPT_DIR}
