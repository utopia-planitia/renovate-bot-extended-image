FROM renovate/renovate:24.98.8@sha256:7350d077ab84e5f50ad40f32c40546702b567dba42aa31d31af880034ffc4a0f

USER root

RUN apt update

RUN apt install -y curl jq

RUN pip3 install yq

ENV MSORT_VERSION=v0.1.0
RUN go install github.com/utopia-planitia/msort@${MSORT_VERSION}

# checks
RUN curl --version
RUN jq --version
RUN yq --version
RUN go version

USER ubuntu
