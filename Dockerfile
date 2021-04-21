FROM renovate/renovate:24.119.6@sha256:36e955e65360aaa3b3ede98ebb3efd580d774628155a30defbb447622fd143c0

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
