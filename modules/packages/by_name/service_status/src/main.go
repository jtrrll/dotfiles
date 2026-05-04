package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"slices"
	"strings"

	"github.com/urfave/cli/v3"
)

type ServiceStatus struct {
	Name     string `json:"name"`
	State    string `json:"state"`
	Detail   string `json:"detail,omitempty"`
	Schedule string `json:"schedule,omitempty"`
	Kind     string `json:"kind,omitempty"`
}

type PortInfo struct {
	Port    int    `json:"port"`
	Process string `json:"process"`
	PID     string `json:"pid"`
	Address string `json:"address"`
}

var version = "dev"

func main() {
	cmd := &cli.Command{
		Name:    "service-status",
		Usage:   "Serves managed background service status over HTTP",
		Version: version,
		Flags: []cli.Flag{
			&cli.IntFlag{
				Name:  "port",
				Usage: "HTTP listen port",
				Value: 5679,
			},
			&cli.StringFlag{
				Name:  "prefix",
				Usage: "Service label prefix to filter by",
				Value: defaultPrefix,
			},
		},
		Action: func(ctx context.Context, cmd *cli.Command) error {
			port := cmd.Int("port")
			prefix := cmd.String("prefix")

			querier := newQuerier(prefix)

			http.HandleFunc("/status", statusHandler(querier))
			http.HandleFunc("/ports", portsHandler())

			addr := fmt.Sprintf("127.0.0.1:%d", port)
			log.Printf("listening on %s (prefix=%q)", addr, prefix)
			return http.ListenAndServe(addr, nil)
		},
	}

	if err := cmd.Run(context.Background(), os.Args); err != nil {
		log.Fatal(err)
	}
}

func statusHandler(querier Querier) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		statuses, err := querier.QueryAll()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		slices.SortFunc(statuses, func(a, b ServiceStatus) int {
			return strings.Compare(a.Name, b.Name)
		})

		w.Header().Set("Content-Type", "application/json")
		if err := json.NewEncoder(w).Encode(statuses); err != nil {
			log.Printf("failed to encode response: %v", err)
		}
	}
}

func portsHandler() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ports, err := listPorts()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		slices.SortFunc(ports, func(a, b PortInfo) int {
			return a.Port - b.Port
		})

		w.Header().Set("Content-Type", "application/json")
		if err := json.NewEncoder(w).Encode(ports); err != nil {
			log.Printf("failed to encode response: %v", err)
		}
	}
}
