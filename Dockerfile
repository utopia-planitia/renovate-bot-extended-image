FROM renovate/renovate:24.119.15@sha256:c7921aa1cd0729a97739454ece63c41688fa37f4f556a382c5f440b0fa3efe5f

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
