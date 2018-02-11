// First file of learning the Gobook
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

// package main

// import (
//     "bufio"
//     "fmt"
//     "math"
//     "os"
//     "runtime"
// )

// type polar struct {
//     radius float64
//     theta float64
// }

// type cartesian struct {
//     x float64
//     y float64
// }

// var prompt = "Enter a radius and an angle (in degrees), e.g., 12.5 90, " + "or %s to quit."

// func init() {
//     if runtime.GOOS == "windows" {
//         prompt = fmt.Sprintf(prompt, "Ctrl+Z, Enter")
//     } else { //类 Unix
//         prompt = fmt.Sprintf(prompt, "Ctrl+D")
//     }
// }

// func main() {
//     questions := make(chan polar)
//     defer close(questions)
//     answers := createSolver(questions)
//     defer close(answers)
//     interact(questions, answers)
// }

// func createSolver(questions chan polar) chan cartesian {
//     answers := make(chan cartesian)
//     go func() {
//         for {
//             polarCoord := <-questions
//             theta := polarCoord.theta * math.Pi / 180.0
//             x := polarCoord.radius * math.Cos(theta)
//             y := polarCoord.radius * math.Sin(theta)
//             answers <- cartesian{x, y}
//         }
//     }()
//     return answers
// }

// const result = "Polar radius=%.02f theta=%.02f° -> Cartesian x=%.02f y=%.02f\n"

// func interact(questions chan polar, answers chan cartesian) {
//     reader := bufio.NewReader(os.Stdin)
//     fmt.Println(prompt)
//     for {
//         fmt.Println("Radius and angle: ")
//         line, err := reader.ReadString('\n')
//         if err != nil {
//             break
//         }
//         var radius, theta float64
//         if _, err := fmt.Sscanf(line, "%f %f", &radius, &theta); err != nil {  // 书上的代码是fmt.Sscan, 无法正常读取
//             fmt.Println(os.Stderr, "invalid input")
//             continue
//         }
//         questions <- polar{radius, theta}
//         corrd := <-answers
//         fmt.Printf(result, radius, theta, corrd.x, corrd.y)
//     }
//     fmt.Println()
// }

// package main

// import (
//     "fmt"
//     "strings"
// )

// type BitFlag int
// const (
//     Active BitFlag = 1 << iota
//     Send
//     Receive
// )

// func (flag BitFlag) String() string {
//     var flags []string
//     if flag & Active == Active {
//         flags = append(flags, "Active")
//     }
//     if flag & Send == Send {
//         flags = append(flags, "Send")
//     }
//     if flag & Receive == Receive {
//         flags = append(flags, "Receive")
//     }
//     if len(flags) > 0 {
//         return fmt.Sprintf("%d(%s)", int(flag), strings.Join(flags, "|"))
//     }
//     return "0()"
// }

// func main() {
//     flag := Active | Send
//     fmt.Println(flag)
// }

// package main

// import (
// 	"fmt"
// 	"log"
// 	"net/http"
// 	"sort"
// 	"strconv"
// 	"strings"
// )

// const (
// 	pageTop = `<!DOCTYPE HTML><html><head>
// <style>.error{color:#FF0000;}</style></head><title>Statistics</title>
// <body><h3>Statistics</h3>
// <p>Computes basic statistics for a given list of numbers</p>`
// 	form = `<form action="/" method="POST">
// <label for="numbers">Numbers (comma or space-separated):</label><br />
// <input type="text" name="numbers" size="30"><br />
// <input type="submit" value="Calculate">
// </form>`
// 	pageBottom = `</body></html>`
// 	anError    = `<p class="error">%s</p>`
// )

// type statistics struct {
// 	numbers []float64
// 	mean    float64
// 	median  float64
// }

// func main() {
// 	http.HandleFunc("/", homePage)
// 	if err := http.ListenAndServe(":9001", nil); err != nil {
// 		log.Fatal("failed to start server", err)
// 	}
// }

// func homePage(writer http.ResponseWriter, request *http.Request) {
// 	err := request.ParseForm() // Must be called before writing response
// 	fmt.Fprint(writer, pageTop, form)
// 	if err != nil {
// 		fmt.Fprintf(writer, anError, err)
// 	} else {
// 		if numbers, message, ok := processRequest(request); ok {
// 			stats := getStats(numbers)
// 			fmt.Fprint(writer, formatStats(stats))
// 		} else if message != "" {
// 			fmt.Fprintf(writer, anError, message)
// 		}
// 	}
// 	fmt.Fprint(writer, pageBottom)
// }

// func processRequest(request *http.Request) ([]float64, string, bool) {
// 	var numbers []float64
// 	if slice, found := request.Form["numbers"]; found && len(slice) > 0 {
// 		text := strings.Replace(slice[0], ",", " ", -1)
// 		for _, field := range strings.Fields(text) {
// 			if x, err := strconv.ParseFloat(field, 64); err != nil {
// 				return numbers, "'" + field + "' is invalid", false
// 			} else {
// 				numbers = append(numbers, x)
// 			}
// 		}
// 	}
// 	if len(numbers) == 0 {
// 		return numbers, "", false // no data first time form is shown
// 	}
// 	return numbers, "", true
// }

// func formatStats(stats statistics) string {
// 	return fmt.Sprintf(`<table border="1">
// <tr><th colspan="2">Results</th></tr>
// <tr><td>Numbers</td><td>%v</td></tr>
// <tr><td>Count</td><td>%d</td></tr>
// <tr><td>Mean</td><td>%f</td></tr>
// <tr><td>Median</td><td>%f</td></tr>
// </table>`, stats.numbers, len(stats.numbers), stats.mean, stats.median)
// }

// func getStats(numbers []float64) (stats statistics) {
// 	stats.numbers = numbers
// 	sort.Float64s(stats.numbers)
// 	stats.mean = sum(numbers) / float64(len(numbers))
// 	stats.median = median(numbers)
// 	return stats
// }

// func sum(numbers []float64) (total float64) {
// 	for _, x := range numbers {
// 		total += x
// 	}
// 	return total
// }

// func median(numbers []float64) float64 {
// 	middle := len(numbers) / 2
// 	result := numbers[middle]
// 	if len(numbers)%2 == 0 {
// 		result = (result + numbers[middle-1]) / 2
// 	}
// 	return result
// }

package main

import (
	"fmt"
)

func main() {
	fmt.Println("hello world")
}
