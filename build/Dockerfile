# The values to use are defined .env
ARG IRIS_IMAGE="intersystems/iris-community"
ARG IRIS_IMAGE_TAG="2024.2"

FROM ${IRIS_IMAGE}:${IRIS_IMAGE_TAG}

USER 51773 

COPY ./build /opt/irisbuild
COPY ./src /opt/irisbuild/src

ENV ISC_CPF_MERGE_FILE=/opt/irisbuild/merge.cpf

RUN iris start IRIS && \
	iris session IRIS < /opt/irisbuild/buildIRIS.os && \
	iris stop IRIS quietly