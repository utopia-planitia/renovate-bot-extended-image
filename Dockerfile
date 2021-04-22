FROM renovate/renovate:24.119.6@sha256:913ec9890673df54db565766a9cec14a24a26823b35af9d27f72382c39ca2405

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
