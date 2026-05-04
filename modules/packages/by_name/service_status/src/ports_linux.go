//go:build linux

package main

import (
	"fmt"
	"os/exec"
	"strconv"
	"strings"
)

func listPorts() ([]PortInfo, error) {
	cmd := exec.Command("ss", "-tlnp")
	output, err := cmd.Output()
	if err != nil {
		return nil, fmt.Errorf("ss: %w", err)
	}

	return parseSsOutput(string(output)), nil
}

func parseSsOutput(output string) []PortInfo {
	var ports []PortInfo

	lines := strings.Split(strings.TrimSpace(output), "\n")
	if len(lines) < 2 {
		return ports
	}

	for _, line := range lines[1:] {
		fields := strings.Fields(line)
		if len(fields) < 5 {
			continue
		}

		localAddr := fields[3]
		port, ok := parsePort(localAddr)
		if !ok {
			continue
		}

		process := parseProcessField(fields[len(fields)-1])

		ports = append(ports, PortInfo{
			Port:    port,
			Process: process,
			PID:     parsePidField(fields[len(fields)-1]),
			Address: localAddr,
		})
	}

	return ports
}

func parsePort(addr string) (int, bool) {
	idx := strings.LastIndex(addr, ":")
	if idx < 0 {
		return 0, false
	}
	port, err := strconv.Atoi(addr[idx+1:])
	if err != nil {
		return 0, false
	}
	return port, true
}

func parseProcessField(field string) string {
	// Format: users:(("process",pid=123,fd=4))
	start := strings.Index(field, "((\"")
	if start < 0 {
		return ""
	}
	end := strings.Index(field[start+3:], "\"")
	if end < 0 {
		return ""
	}
	return field[start+3 : start+3+end]
}

func parsePidField(field string) string {
	// Format: users:(("process",pid=123,fd=4))
	idx := strings.Index(field, "pid=")
	if idx < 0 {
		return ""
	}
	rest := field[idx+4:]
	end := strings.IndexAny(rest, ",)")
	if end < 0 {
		return rest
	}
	return rest[:end]
}
