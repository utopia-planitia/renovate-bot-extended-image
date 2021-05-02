FROM renovate/renovate:24.119.14@sha256:020a484aa101688e3f3f7268f3496f7c7f6eb3966edf3a7f753c68e332d6c647

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
