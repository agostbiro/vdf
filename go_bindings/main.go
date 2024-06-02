package main

import (
	"fmt"
	"github.com/agostbiro/vdf/go_bindings/generated/vdf"
	"time"
)

const intSizeBits = uint16(2048)
const difficulty = uint64(10000)

func main() {
	fmt.Println("Test prove/verify")
	solution := vdf.WesolowskiSolve(intSizeBits, []byte{0x01, 0x02, 0x03}, difficulty)
	isOk := vdf.WesolowskiVerify(intSizeBits, []byte{0x01, 0x02, 0x03}, difficulty, solution)
	if !isOk {
		panic("Prove/verify failed")
	} else {
		fmt.Println("Prove/verify succeeded")
	}

	fmt.Println("Benchmarking Rust VDF")
	start := time.Now()

	challenge := []byte{0x01, 0x02, 0x03}
	for i := 0; i < 10; i++ {
		challenge = vdf.WesolowskiSolve(intSizeBits, challenge, difficulty)
	}

	elapsed := time.Since(start)
	fmt.Printf("Benchmarking Rust VDF took %s\n", elapsed)
}
