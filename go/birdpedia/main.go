package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	// The "HandleFunc" method accepts a path and a function as arguments
	http.HandleFunc("/", handler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello World from Larryyyyyyyyyyyyyyyyy!")
}
