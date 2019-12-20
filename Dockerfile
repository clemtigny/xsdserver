FROM golang as build
RUN apt-get update
RUN apt-get install -y libxml2 libxml2-dev
WORKDIR /go/src/app
COPY . .

RUN go get -d -v ./...
RUN go build -o /go/bin/xsdv

FROM scratch
COPY --from=build /go/bin/xsdv /go/bin/xsdv
COPY ./config.yml /go/bin/config.yml
ENTRYPOINT [ "/go/bin/xsdv" ]