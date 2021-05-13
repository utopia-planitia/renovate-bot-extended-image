FROM renovate/renovate:25.19.2@sha256:547b5edd9910c7e81dd24e76750d764ab706469eda23c2b060f1b27c29cf5094

USER root

RUN apt update

RUN apt install -y curl jq

RUN pip3 install yq

USER ubuntu

ENV MSORT_VERSION=v0.1.0
RUN go install github.com/utopia-planitia/msort@${MSORT_VERSION}

# checks
RUN curl --version
RUN jq --version
RUN yq --version
RUN go version
RUN renovate --version
