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

// // channel 通道
// package main

// import (
//     "fmt"
//     "time"
// )

// func fixed_shooting(msg_chan chan string) {
//     for {
//         msg_chan <- "fixed shooting"
//         fmt.Println("continue fixed shooting...")
//     }
// }

// func count(msg_chan chan string) {
//     for {
//         msg := <-msg_chan
//         fmt.Println(msg)
//         time.Sleep(time.Second * 1)
//     }
// }

// func main() {
//     var c chan string
//     c = make(chan string)

//     go fixed_shooting(c)
//     go count(c)

//     var input string
//     fmt.Scanln(&input)
//     fmt.Println(input)
// }

// package main

// import (
//     "fmt"
//     "time"
// )

// func fixed_shooting(msg_chan chan string) {
//     for {
//         msg_chan <- "fixed shooting"
//     }
// }

// func three_point_shooting(msg_chan chan string) {
//     for {
//         msg_chan <- "three point shooting"
//     }
// }

// func count(msg_chan chan string) {
//     for {
//         msg := <-msg_chan
//         fmt.Println(msg)
//         time.Sleep(time.Second * 1)
//     }
// }

// func main() {
//     var c chan string
//     c = make(chan string)

//     go fixed_shooting(c)
//     go three_point_shooting(c)
//     go count(c)

//     var input string
//     fmt.Scanln(&input)
//     fmt.Println(input)
//     fmt.Println("----program is over----")
// }  // 本例的结果是"fixed shooting" 和 "three points shooting"交叉输出，为什么？

/* 
channel 通道方向
所谓通道方向就是写和读，如果有如下定义
c chan<- string  // 只能想channel写入数据
c <-chan string  // 只能从channel读取数据
否则会导致编译错误
c chan string  // 默认的定义方式，则既可以想channel写入数据，也可以从channel读取数据
*/

// package main

// import (
//     "fmt"
//     "time"
// )

// func fixed_shooting(msg_chan chan string) {
//     for {
//         msg_chan <- "fixed shooting"
//         time.Sleep(time.Second * 1)
//     }
// }

// func three_point_shooting(msg_chan chan string) {
//     for {
//         msg_chan <- "three point shooting"
//         time.Sleep(time.Second * 1)
//     }
// }

// func main() {
//     c_fixed := make(chan string)
//     c_3_point := make(chan string)

//     go fixed_shooting(c_fixed)
//     go three_point_shooting(c_3_point)

//     go func() {
//         for {
//             select {
//             case msg1 := <-c_fixed:
//                 fmt.Println(msg1)
//             case msg2 := <-c_3_point:
//                 fmt.Println(msg2)
//             }
//         }
//     }()

//     var input string
//     fmt.Scanln(&input)
//     fmt.Println("----over----")
// }

// package main

// import (
//     "fmt"
//     "time"
// )

// func fixed_shooting(msg_chan chan string) {
//     var times = 3
//     var t = 1
//     for {
//         if t <= times {
//             msg_chan <- "fixed shooting"
//         }
//         t++
//         time.Sleep(time.Second * 1)
//     }
// }

// func three_point_shooting(msg_chan chan string) {
//     var times = 5
//     var t = 1
//     for {
//         if t <= times {
//             msg_chan <- "three point shooting"
//         }
//         t++
//         time.Sleep(time.Second * 1)
//     }
// }

// func main() {
//     c_fixed := make(chan string)
//     c_3_point := make(chan string)

//     go fixed_shooting(c_fixed)
//     go three_point_shooting(c_3_point)

//     go func() {
//         for {
//             select {
//             case msg1 := <-c_fixed:
//                 fmt.Println(msg1)
//             case msg2 := <-c_3_point:
//                 fmt.Println(msg2)
//             case <- time.After(time.Second * 5):
//                 fmt.Println("timeout, check again...")
//             }
//         }
//     }()

//     var input string
//     fmt.Scanln(&input)
//     fmt.Println("----over----")
// }

package main

import (
    "fmt"
    "strconv"
    "time"
)

func shooting(msg_chan chan string) {
    var group = 1
    for {
        for i := 1; i <= 10; i++ {
            msg_chan <- strconv.Itoa(group) + ":" + strconv.Itoa(i)
        }
        group++
        time.Sleep(time.Second * 10)
    }
}

func count(msg_chan chan string) {
    for {
        fmt.Println(<-msg_chan)
    }
}

func main() {
    var c = make(chan string, 20)
    go shooting(c)
    go count(c)

    var input string
    fmt.Scanln(&input)
    fmt.Println("----over----")
}