package main

import (
    "fmt"
    "net/http"
)

func main() {
    http.HandleFunc("/", HelloEndpoint)
    http.ListenAndServe(":80", nil)
}

func HelloEndpoint(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "%s, %s!", "Hello World", r.URL.Path[1:])
}
