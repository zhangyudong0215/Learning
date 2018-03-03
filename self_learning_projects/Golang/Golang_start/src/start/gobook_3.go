package main

import (
	"fmt"
	"strconv"
	"strings"
)

func main() {
	a := []int{1, 2, 3, 4}
	b := make([]string, 4)
	for index, num := range a {
		b[index] = strconv.Itoa(num)
	}
	s := strings.Join(b, "")
	fmt.Println(s)
}
