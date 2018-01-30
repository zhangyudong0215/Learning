// package main

// import (
//     "fmt"
//     "time"
// )
//
///* 并行计算 */ 9.5-10.0ms
//func get_sum_of_divisible(num int, divider int, resultChan chan int) {
//    sum := 0
//    for value := 0; value < num; value++ {
//        if value%divider == 0 {
//            sum += value
//        }
//    }
//    resultChan <- sum
//}
//
//func main() {
//    LIMIT := 1000000
//    resultChan := make(chan int, 3)
//    t_start := time.Now()
//    go get_sum_of_divisible(LIMIT, 3, resultChan)
//    go get_sum_of_divisible(LIMIT, 5, resultChan)
//    go get_sum_of_divisible(LIMIT, 15, resultChan)
//    // 这里有个问题，并行计算的结果出来的顺序不同，进入chan的次序是不固定的
//    sum3, sum5, sum15 := <-resultChan, <-resultChan, <-resultChan
//    t_end := time.Now()
//    
//    sum := sum3 + sum5 - sum15
//    fmt.Println(sum3, sum5, sum15)
//    fmt.Println(sum)
//    fmt.Println(t_end.Sub(t_start))
//}

//// 非并行计算的对比  28.0ms
//func get_sum_of_divisible(num int, divider int) (sum int) {
//    sum = 0
//    for value := 0; value < num; value++ {
//        if value%divider == 0 {
//            sum += value
//        }
//    }
//    return
//}
//
//func main() {
//    LIMIT := 1000000
//    var a, b, c, sum int
//    t_start := time.Now()
//    a = get_sum_of_divisible(LIMIT, 3)
//    b = get_sum_of_divisible(LIMIT, 5)
//    c = get_sum_of_divisible(LIMIT, 15)
//    t_end := time.Now()
//    
//    sum = a + b - c
//    fmt.Println(a, b, c)
//    fmt.Println(sum)
//    fmt.Println(t_end.Sub(t_start))
//}

// /* Goroutine 协程 */
// package main

// import (
//     "fmt"
// )

// func list_elem(n int) {
//     for i := 0; i < n; i++ {
//         fmt.Println(i)
//     }
// }

// func main() {
//     go list_elem(10)  // 创建完协程之后立即退出，协程不会运行
// }

//func list_elem(n int) {
//    for i := 0; i < n; i++ {
//        fmt.Println(i)
//    }
//}
//
//func main() {
//    go list_elem(10)
//    var input string
//    fmt.Scanln(&input)  // 要求用户输入一行数据
//    fmt.Println(input)
//}

//// 检测是否并行
//package main
//
//import (
//    "fmt"
//    "math/rand"  // 可能是载入math模块的rand子模块（猜测）
//    "time"
//)
//
//func list_elem(n int, tag string) {
//    for i := 0; i < n; i++ {
//        fmt.Println(tag, i)
//        tick := time.Duration(rand.Intn(100))  // 生成100以内随机整数的方法，服从什么分布？
//        time.Sleep(time.Millisecond * tick)
//    }
//}
//
//func main() {
//    go list_elem(10, "go_a")
//    go list_elem(20, "go_b")
//    var input string
//    fmt.Scanln(&input)
//    fmt.Println(input)
//}

// channel 通道
package main

import (
    "fmt"
    "time"
)

func fixed_shooting(msg_chan chan string) {
    for {
        msg_chan <- "fixed shooting"
        fmt.Println("continue fixed shooting...")
    }
}

func count(msg_chan chan string) {
    for {
        msg := <-msg_chan
        fmt.Println(msg)
        time.Sleep(time.Second * 1)
    }
}

func main() {
    var c chan string
    c = make(chan string)

    go fixed_shooting(c)
    go count(c)

    var input string
    fmt.Scanln(&input)
    fmt.Println(input)
}
