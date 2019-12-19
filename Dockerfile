FROM golang
RUN apt-get update
RUN apt-get install -y libxml2 libxml2-dev
WORKDIR /go/src/app
COPY . .

RUN go get -d -v ./...
RUN go build -v ./...
RUN ./app