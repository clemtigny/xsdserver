# Image used to build application
FROM golang as build

# Install dependancies (libxml2)
RUN apt-get update \
 && apt-get install -y libxml2 libxml2-dev

# Copy sources & nuild
WORKDIR /go/src/xsdserver
COPY . .
RUN go get -d -v ./...
RUN go build

# Extract librairies using dynamic linking, and save them
RUN ldd xsdserver                                                   \
      | tr -s '[:blank:]' '\n'                                      \
      | grep '^/'                                                   \
      | xargs -I % sh -c 'mkdir -pv $(dirname ./%); cp -v % ./%;'   \
 && mkdir -pv lib64                                                 \
 && cp -v /lib64/ld-linux-x86-64.so.2 lib64/

# Final image
FROM scratch
WORKDIR /
COPY --from=build /go/src/xsdserver /
ENTRYPOINT [ "/xsdserver" ]
