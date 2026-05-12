FROM golang:1.26.3-alpine3.22@sha256:be93003ee861b3b91b6ebcb22678524947e0cd786c2df3f32af520006b1e54f5

# Add image labels
LABEL org.opencontainers.image.title jx-goreleaser-image
LABEL org.opencontainers.image.description custom go releaser image for Jenkins X
LABEL org.opencontainers.image.vendor Jenkins X
LABEL com.docker.extension.publisher-url https://jenkins-x.io/

RUN apk add --no-cache bash \
    curl \
    git \
    make \
    build-base

# Install syft
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin v1.43.0 &&\
    chmod +x /usr/local/bin/syft &&\
    syft --version

# Install cosign
COPY --from=ghcr.io/sigstore/cosign/cosign:v2.5.0@sha256:e82eb6d42ccb6bc048d8d9e5e598e4d5178e1af6c00e54e02c9b0569c5f3ec11 /ko-app/cosign /usr/local/bin/cosign
RUN cosign version

# Install goreleaser
RUN curl -L https://github.com/goreleaser/goreleaser/releases/download/v2.15.3/goreleaser_Linux_x86_64.tar.gz | tar xzv &&\
    rm -rf README.md completions manpages &&\
    mv goreleaser /usr/local/bin &&\
    goreleaser -v
