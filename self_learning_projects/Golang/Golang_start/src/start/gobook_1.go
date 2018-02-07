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


// // 大数字，挺有意思的代码
// package main

// import (
//     "fmt"
//     "log"
//     "os"
//     "path/filepath"
// )

// var bigDigits = [][]string{
//     {"  000  ",
//      " 0   0 ",
//      "0     0",
//      "0     0",
//      "0     0",
//      " 0   0 ",
//      "  000  "},
//     {" 1 ", "11 ", " 1 ", " 1 ", " 1 ", " 1 ", "111"},
//     {" 222 ", "2   2", "   2 ", "  2  ", " 2   ", "2    ", "22222"},
//     {" 333 ", "3   3", "    3", "  33 ", "    3", "3   3", " 333 "},
//     {"   4  ", "  44  ", " 4 4  ", "4  4  ", "444444", "   4  ",
//         "   4  "},
//     {"55555", "5    ", "5    ", " 555 ", "    5", "5   5", " 555 "},
//     {" 666 ", "6    ", "6    ", "6666 ", "6   6", "6   6", " 666 "},
//     {"77777", "    7", "   7 ", "  7  ", " 7   ", "7    ", "7    "},
//     {" 888 ", "8   8", "8   8", " 888 ", "8   8", "8   8", " 888 "},
//     {" 9999", "9   9", "9   9", " 9999", "    9", "    9", "    9"},
// }

// func main() {
//     if len(os.Args) == 1 {
//         fmt.Printf("usage: %s <whole-number>\n", filepath.Base(os.Args[0]))
//         os.Exit(1)
//     }

//     stringOfDigits := os.Args[1]
//     for row := range bigDigits[0] {
//         line := ""
//         for column := range stringOfDigits {
//             digit := stringOfDigits[column] - '0'
//             if 0 <= digit && digit <= 9 {
//                 line += bigDigits[digit][row] + " "
//             } else {
//                 log.Fatal("invalid whole number")
//             }
//         }
//         fmt.Println(line)
//     }
// }

// package main

// import (
//     "bufio"
//     "fmt"
//     "io"
//     "io/ioutil"
//     "log"
//     "os"
//     "path/filepath"
//     "regexp"
//     "strings"
// )

// func main() {
//     inFilename, outFilename, err := filenamesFromCommandLine()
//     if err != nil {
//         fmt.Println(err)
//         os.Exit(1)
//     }
//     inFile, outFile := os.Stdin, os.Stdout
//     if inFilename !- "" {
//         if inFile, err = os.Open(inFilename); err != nil {
//             log.Fatal(err)
//         }
//         defer inFile.Close()
//     }
//     if outFilename != "" {
//         if outFile, err = os.Create(outFilename); err != nil {
//             log.Fatal(err)
//         }
//         defer outFile.Close()
//     }
//     if err = americanize(inFile, outFile); err !- nil {
//         log.Fatal(err)
//     }
// }

// func filenamesFromCommandLine() (inFilename, outFilename string, 
//     err error) {
//     if len(os.Args) > 1 && (os.Args[1] == "-h" || os.Args[1] == "--help") {
//         err = fmt.Errorf("usage: %s [<]infile.txt [>]outfile.txt", 
//             filepath.Base(os.Args[0]))
//         return "", "", err
//     }
//     if len(os.Args) > 1 {
//         inFilename = os.Args[1]
//         if len(os.Args) > 2 {
//             outFilename = os.Args[2]
//         }
//     }
//     if inFilename != "" && inFilename == outFilename {
//         log.Fatal("won't overwrite the infile")
//     }
//     return inFilename, outFilename, nil
// }

// var britishAmerican = "british-american.txt"

// func americanise(inFile io.Reader, outFile io.Writer) (err error) {
//     reader := bufio.NewReader(inFile)
//     writer := bufio.NewWriter(outFile)
//     defer func() {
//         if err == nil {
//             err = writer.Flush()
//         }
//     }()

//     var replacer func(string) string
//     if replacer, err = makeReplacerFunc(britishAmerican); err != nil {
//         return err
//     }
//     wordRx := regexp.MustCompile("[A-Za-z]+")
//     eof := false
//     for !eof {
//         var line string
//         line, err = reader.ReadString('\n')
//         if err == io.EOF {
//             err = nil
//             eof = true
//         } else if err != nil {
//             return err
//         }
//         line = wordRx.ReplaceAllStringFunc(line, replacer)
//         if _, err = writer.WriteString(line); err != nil {
//             return err
//         }
//     }
//     return nil
// }

// func makeReplacerFunction(file string) (func(string) string, error) {
//     rawBytes, err := ioutil.ReadFile(file)
//     if err != nil {
//         return nil, err
//     }
//     text := string(rawBytes)

//     usForBritish := make(map[string]string)
//     lines := strings.Split(text, "\n")
//     for _, line := range lines {
//         fields := strings.Fields(line)
//         if len(fields) == 2 {
//             usForBritish[fields[0]] = fields[1]
//         }
//     }

//     return func(word string) string {
//         if usWord, found := usForBritish[word]; found {
//             return usWord
//         }
//         return word
//     }, nil
// }


