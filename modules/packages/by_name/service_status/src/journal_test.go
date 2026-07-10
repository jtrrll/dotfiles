package main

import "testing"

func TestParseBoot(t *testing.T) {
	cases := []struct {
		raw   string
		want  boot
		valid bool
	}{
		{"current", bootCurrent, true},
		{"previous", bootPrevious, true},
		{"", bootCurrent, true},
		{"CURRENT", "", false},
		{"-1", "", false},
		{"; rm -rf /", "", false},
		{"0 --output=cat", "", false},
	}

	for _, tc := range cases {
		got, ok := parseBoot(tc.raw)
		if ok != tc.valid {
			t.Errorf("parseBoot(%q) valid = %v, want %v", tc.raw, ok, tc.valid)
			continue
		}
		if ok && got != tc.want {
			t.Errorf("parseBoot(%q) = %q, want %q", tc.raw, got, tc.want)
		}
	}
}
