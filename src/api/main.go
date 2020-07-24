package main

import (
	"context"
	"fmt"
	"log"
	"net"
	"net/http"
	"os"
	"os/signal"
	"time"
)

const nginxSocket = "/tmp/nginx.socket"
const appInitializedFile = "/tmp/app-initialized"

func homePage(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Welcome to the HomePage Again!")
	fmt.Println("Endpoint Hit: homePage")
}

func serve(ctx context.Context) (e error) {
	mux := http.NewServeMux()
	mux.HandleFunc("/", homePage)
	if e := os.RemoveAll(nginxSocket); e != nil {
		log.Fatal(e)
	}
	if e := os.RemoveAll(appInitializedFile); e != nil {
		log.Fatal(e)
	}
	s := &http.Server{
		Handler: mux,
	}
	go func() {
		l, e := net.Listen("unix", nginxSocket)
		if e != nil {
			log.Fatal(e)
		}
		defer l.Close()
		log.Fatal(s.Serve(l))
	}()
	log.Printf("Server started")
	f, e := os.Create(appInitializedFile)
	if e != nil {
		log.Fatal(e)
	}
	f.Close()
	<-ctx.Done()
	ctxShutdown, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer func() {
		cancel()
	}()

	if e = s.Shutdown(ctxShutdown); e != nil {
		log.Fatalf("server Shutdown Failed:%+s", e)
	}

	log.Printf("server exited properly")

	if e == http.ErrServerClosed {
		e = nil
	}
	return
}

func main() {
	log.Print("Starting server")
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	ctx, cancel := context.WithCancel(context.Background())
	go func() {
		oscall := <-c
		log.Printf("system call:%+v", oscall)
		cancel()
	}()
	if err := serve(ctx); err != nil {
		log.Printf("failed to serve:+%v\n", err)
	}
}
