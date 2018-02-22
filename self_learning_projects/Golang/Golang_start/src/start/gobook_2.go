// package main

// import (
// 	"fmt"
// 	"strings"
// 	"unicode/utf8"
// )

// func main() {
// 	fmt.Printf("|%b|%9b|% b|\n", 37, 37, 37)
// 	fmt.Printf("|%o|%#o|%# 8o|%#+ 8o|%+08o|\n", 41, 41, 41, 41, 41)
// 	i := 569
// 	fmt.Printf("|$%d|$%06d|$%+06d|$%s|\n", i, i, i, Pad(i, 6, '*'))
//     fmt.Printf("%d %#04x %U '%c'\n", 0x3A6, 934, '\u03A6', '\U000003A6')
// }

// func Pad(number, width int, pad rune) string {
// 	s := fmt.Sprint(number)
// 	gap := width - utf8.RuneCountInString(s)
// 	if gap > 0 {
// 		return strings.Repeat(string(pad), gap) + s
// 	}
// 	return s
// }

// package main // 格式化输出

// import (
// 	"fmt"
// 	"math"
// 	"strings"
// 	"unicode/utf8"
// )

// func main() {
// 	for _, x := range []float64{-.258, 7194.84, -60897162.0218, 1.500089e-8} {
// 		fmt.Printf("|%20.5e|%20.5f|%s|\n", x, x, Humanize(x, 20, 5, '*', ','))
// 	}
// }

// func Humanize(amount float64, width, decimals int, pad, separator rune) string {
// 	dollars, cents := math.Modf(amount)
// 	whole := fmt.Sprintf("%+.0f", dollars)[1:] //去除"+-"
// 	fraction := ""
// 	if decimals > 0 {
// 		fraction = fmt.Sprintf("%+.*f", decimals, cents)[2:] //去除"+-0"
// 	}
// 	sep := string(separator)
// 	for i := len(whole) - 3; i > 0; i -= 3 {
// 		whole = whole[:i] + sep + whole[i:]
// 	}
// 	if amount < 0.0 {
// 		whole = "-" + whole
// 	}
// 	number := whole + fraction
// 	gap := width - utf8.RuneCountInString(number)
// 	if gap > 0 {
// 		return strings.Repeat(string(pad), gap) + number
// 	}
// 	return number
// }

// package main

// import (
// 	"fmt"
// 	"io/ioutil"
// 	"log"
// 	"os"
// 	"path/filepath"
// 	"strconv"
// 	"strings"
// )

// type Song struct {
// 	Title    string
// 	Filename string
// 	Seconds  int
// }

// func main() {
// 	if len(os.Args) == 1 || !strings.HasSuffix(os.Args[1], ".m3u") {
// 		fmt.Printf("usage: %s <file.m3u>\n", filepath.Base(os.Args[0]))
// 		os.Exit(1)
// 	}
// 	if rawBytes, err := ioutil.ReadFile(os.Args[1]); err != nil {
// 		log.Fatal(err)
// 	} else {
// 		songs := readM3uPlaylist(string(rawBytes))
// 		writePlsPlaylist(songs)
// 	}
// }

// func readM3uPlaylist(data string) (songs []Song) {
// 	var song Song
// 	for _, line := range strings.Split(data, "\n") {
// 		line = strings.TrimSpace(line)
// 		if line == "" || strings.HasPrefix(line, "#EXTM3U") {
// 			continue
// 		}
// 		if strings.HasPrefix(line, "#EXTINF:") {
// 			song.Title, song.Seconds = parseExtinfLine(line)
// 		} else {
// 			song.Filename = strings.Map(mapPlatformDirSeparator, line)
// 		}
// 		if song.Filename != "" && song.Title != "" && song.Seconds != 0 {
// 			songs = append(songs, song)
// 			song = Song{}
// 		}
// 	}
// 	return songs
// }

// func parseExtinfLine(line string) (title string, seconds int) {
// 	if i := strings.IndexAny(line, "-0123456789"); i > -1 {
// 		const separator = ","
// 		line = line[i:]
// 		if j := strings.Index(line, separator); j > -1 {
// 			title = line[j+len(separator):]
// 			var err error
// 			if seconds, err = strconv.Atoi(line[:j]); err != nil {
// 				log.Printf("failed to read the duration for '%s': %v\n", title, err)
// 				seconds = -1
// 			}
// 		}
// 	}
// 	return title, seconds
// }

// func mapPlatformDirSeparator(char rune) rune {
// 	if char == '/' || char == '\\' {
// 		return filepath.Separator
// 	}
// 	return char
// }

// func writePlsPlaylist(songs []Song) {
// 	fmt.Println("[playlist]")
// 	for i, song := range songs {
// 		i++
// 		fmt.Printf("File%d=%s\n", i, song.Filename)
// 		fmt.Printf("Title%d=%s\n", i, song.Title)
// 		fmt.Printf("Length%d=%d\n", i, song.Seconds)
// 	}
// 	fmt.Printf("NumberOfEntries=%d\nVersion=2\n", len(songs))
// }

package main

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"
	"strings"
)

func main() {
	if len(os.Args) == 1 || os.Args[1] == "-h" || os.Args[1] == "--help" {
		fmt.Printf("usage: %s file\n", filepath.Base(os.Args[0]))
		os.Exit(1)
	}
	separators := []string{"\t", "*", "|", "•"}
	linesRead, lines := readUpToNLines(os.Args[1], 5)
	counts := createCounts(lines, separators, linesRead)
	separator := guessSep(counts, separators, linesRead)
	report(separator)
}

func readUpToNLines(filename string, maxLines int) (int, []string) {
	var file *os.File
	var err error
	if file, err = os.Open(filename); err != nil {
		log.Fatal("fialed to open the file:", err)
	}
	defer file.Close()
	lines := make([]string, maxLines)
	reader := bufio.NewReader(file)
	i := 0
	for ; i < maxLines; i++ {
		line, err := reader.ReadString('\n')
		if line != "" {
			lines[i] = line
		}
		if err != nil {
			if err == io.EOF {
				break
			}
			log.Fatal("failed to finish reading the file: ", err)
		}
	}
	return i, lines[:i]
}

func createCounts(lines, separators []string, linesRead int) [][]int {
	counts := make([][]int, len(separators))
	for sepIndex := range separators {
		counts[sepIndex] = make([]int, linesRead)
		for lineIndex, line := range lines {
			counts[sepIndex][lineIndex] = strings.Count(line, separators[sepIndex])
		}
	}
	return counts
}

func guessSep(counts [][]int, separators []string, linesRead int) string {
	for sepIndex := range separators {
		same := true
		count := counts[sepIndex][0]
		for lineIndex := 1; lineIndex < linesRead; lineIndex++ {
			if counts[sepIndex][lineIndex] != count {
				same = false
				break
			}
		}
		if count > 0 && same {
			return separators[sepIndex]
		}
	}
	return ""
}

func report(separator string) {
	switch separator {
	case "":
		fmt.Println("whitespace-separated or not separated at all")
	case "\t":
		fmt.Println("tab-separated")
	default:
		fmt.Printf("%s-separated\n", separator)
	}
}
