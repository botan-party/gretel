FROM alpine:3.15.0

ARG VERSION
ENV VERSION=${VERSION}

RUN apk update && \
    apk add \
        curl \
        git \
        screen

# version check
# TODO : Once stable openjdk18 is released, use in 1.19
RUN if expr ${VERSION} : "^1\.[0-9]|1[0-6]\.[0-9]*$" > /dev/null ; then \
        apk add openjdk8; \
    elif expr ${VERSION} : "^1\.17\.[0-9]*$" > /dev/null ; then \
        apk add openjdk16; \
    elif expr ${VERSION} : "^1\.18\.[0-9]*$" > /dev/null ; then \
        apk add openjdk17; \
    elif expr ${VERSION} : "^1\.19\.[0-9]*$" > /dev/null ; then \
            apk add openjdk17; \
    else \
        echo 'Invalid version.' >&2; \
        exit 1; \
    fi

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

ARG GID=1000
ARG UID=1000
RUN addgroup -g ${GID} steve && \
    adduser -u ${UID} -G steve -D steve

ENV TMP_DIR=/tmp/spigot
ENV OPT_DIR=/opt/spigot
RUN mkdir -p ${TMP_DIR} -p ${OPT_DIR} && \
    chown steve:steve ${TMP_DIR} && \
    chown steve:steve ${OPT_DIR}

USER steve

# setup
WORKDIR ${TMP_DIR}
RUN curl -o ${TMP_DIR}/BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar && \
    java -jar ${TMP_DIR}/BuildTools.jar --rev ${VERSION} && \
    mv ${TMP_DIR}/spigot-${VERSION}.jar ${TMP_DIR}/spigot-server.jar

WORKDIR ${OPT_DIR}
