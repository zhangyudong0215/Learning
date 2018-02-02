// package main

// import (
//     "fmt"
//     "os"
//     "strings"
// )

// func main() {
//     who := "world!"
//     if len(os.Args) > 1 {
//          who = strings.Join(os.Args[1:], " ")
//     }
//     fmt.Println("hello", who)
// }

package main

import (
    "fmt"
    "log"
    "os"
    "path/filepath"
)

var bigDigits = [][]string{
    {"  000  ", 
     " 0   0 ", 
     "0     0", 
     "0     0", 
     "0     0", 
     " 0   0 ", 
     "  000  "}, 
     {" 1 ", "11 ", " 1 ", " 1 ", " 1 ", " 1 ", "111"}, 
}

func main() {
    if len(os.Args) == 1 {
        fmt.Printf("usage: %s <whole-number>\n", filepath.Base(os.Args[0]))
        os.Exit(1)
    }

    stringOfDigits := os.Args[1]
    for row := range bigDigits[0] {
        line := ""
        for column := range stringOfDigits {
            digit := stringOfDigits[column] - '0'
            if 0 <= digit && digit <= 9 {
                line += bigDigits[digit][row] + " "
            } else {
                log.Fatal("invalid whole number")
            }
        }
        fmt.Println(line)
    }
}
