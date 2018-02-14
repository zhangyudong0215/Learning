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
