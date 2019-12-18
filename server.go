package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"gopkg.in/yaml.v2"
)

// Config : The server configuration
type Config struct {
	Port string
}

func index(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "XSD validation server")
}

func main() {
    source, err := ioutil.ReadFile("config.yml")

    if err != nil {
        panic(err)
    }

	var config Config
	fmt.Println(string(source))
	err = yaml.Unmarshal(source, &config)
    if err != nil {
        panic(err)
    }

	http.HandleFunc("/", index)
	log.Println("Running server on port ", config.Port)
	log.Fatal(http.ListenAndServe(":" + config.Port, nil));
}
