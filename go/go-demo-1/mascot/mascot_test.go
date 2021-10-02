package mascot_test

import (
	"testing"

	"example.com/go-demo-1/mascot"
)

func TestMascot(t *testing.T) {
	if mascot.BestMascott() != "Go Gopher" {
		t.Fatal("wrong mascot!!!!!")
	}
}
