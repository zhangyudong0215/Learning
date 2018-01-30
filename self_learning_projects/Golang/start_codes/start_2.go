package main

import (
	"fmt"
)

//func slice_sum(arr []int) int {
//    sum := 0
//    for _, elem := range arr{
//        sum += elem
//    }
//    return sum
//}
//
//func main() {
//    var arr1 = []int{1, 3, 2, 3, 2}
//    var arr2 = []int{3, 2, 3, 1, 6, 4, 8, 9}
//    fmt.Println(slice_sum(arr1))
//    fmt.Println(slice_sum(arr2))
//}

//func slice_sum(arr []int) (sum int) {  // 预先定义返回的变量名，return后面就不用重复
//    sum = 0  // 这里只能初始化，不能再用 :=
//    for _, elem := range arr {
//        sum += elem
//    }
//    return
//}
//
//func main() {
//    var arr1 = []int{1, 3, 2, 3, 2}
//    var arr2 = []int{3, 2, 3, 1, 6, 4, 8}
//    
//    fmt.Println(slice_sum(arr1))
//    fmt.Println(slice_sum(arr2))
//}

//var arr = []int{1, 3, 2, 3, 2}
//
//func slice_sum(arr []int) (sum int) {
//    sum = 0
//    for _, elem := range arr {
//        sum += elem
//    }
//    return
//}
//
//func main() {
//    var arr2 = []int{3, 2, 3, 1, 6, 4, 8}
//    
//    fmt.Println(slice_sum(arr))  // 实参和虚参同名也没关系
//    fmt.Println(slice_sum(arr2))
//}

//func slice_sum(arr []int) (int, float64) {  // 函数返回多参数
//    sum := 0
//    avg := 0.0
//    for _, elem := range arr {
//        sum += elem
//    }
//    avg = float64(sum) / float64(len(arr))
//    return sum, avg
//}
//
//func main() {
//    var arr1 = []int{3, 2, 3, 1, 6, 4, 8}
//    sum, avg := slice_sum(arr1)
//    fmt.Println(sum, avg)
//}

//func slice_sum(arr []int) (sum int, avg float64) {
//    sum = 0
//    avg = 0.0
//    for _, elem := range arr {
//        sum += elem
//    }
//    avg = float64(sum) / float64(len(arr))
//    return  // 此处用return sum, avg也行
//}
//
//func main() {
//    var arr1 = []int{3, 2, 3, 1, 6, 4, 8}
//    fmt.Println(slice_sum(arr1))
//}

/* Go支持可变长参数 */
//func sum(arr ...int) int {  // 这里可变长参数列表里的参数类型相同 // fmt.Println函数需要另外介绍Go接口来解释
//    sum := 0
//    for _, val := range arr {
//        sum += val
//    }
//    return sum
//}
//
//func main() {
//    fmt.Println(sum(1))
//    fmt.Println(sum(1, 2))
//    fmt.Println(sum(1, 2, 3))
//}

//func sum(base int, arr ...int) (sum int) {  // 这里可以直接用sum，不会引发递归之类的歧义吗
//    sum = base  
//    for _, val := range arr {
//        sum += val
//    }
//    return sum  // 虽然可以不写sum，但是我觉得还是在定义、返回的时候都加上比较好
//}
//
//func main() {
//    fmt.Println(sum(100, 1))
//    fmt.Println(sum(100, 1, 2, 3, 4, 5))
//}

// func sum(base int, arr ...int) int {
//     sum := base
//     for _, val := range arr {
//         sum += val
//     }
//     return sum
// }

// func main() {
//     var arr1 = []int{1, 2, 3, 4, 5}
//     fmt.Println(sum(300, arr1...))
// }

// /* 闭包函数 */
// func createEvenGenerator() func() uint {  // 返回函数定义的函数
//     i := uint(0)
//     return func() (retVal uint) {
//         retVal = i
//         i += 2
//         return
//     }
// }

// func main() {
//     nextEven := createEvenGenerator()
//     fmt.Println(nextEven())
//     fmt.Println(nextEven())
//     fmt.Println(nextEven())
// }

// /* 递归 斐波那契数列*/
// func fibonacci(n int) int {
//     var retVal = 0
//     if n == 1 {
//         retVal = 1
//     } else if n == 2 {
//         retVal = 2
//     } else {
//         retVal = fibonacci(n-2) + fibonacci(n-1)
//     }
//     return retVal
// }

// func main() {
//     fmt.Println(fibonacci(5))
// }

// func main() {  // defer，一定会在结束的时候执行，无论是正常结束还是异常
//     defer func() {
//         msg := recover()
//         fmt.Println(msg)
//     }()
//     fmt.Println("I am walking and singing...")
//     panic("it starts to rain cats and dogs")
// }

// /* 指针 */
// func main() {
//     var x int
//     var x_ptr *int

//     x = 10
//     x_ptr = &x 

//     fmt.Println(*&x_ptr)  // 指向x的指针的地址所对应的值，就是指向x的指针的值，就是x的地址
// }

/* 指针的作用，可以将变量的指针作为实参传递给函数，从而在函数内部能够直接修改实参所指向的变量值 */
// func change(x *int) {
//     *x = 200
// }

// func main() {
//     var x int = 100
//     fmt.Println(x)
//     change(&x)  // 传递的是x的地址，修改的x的地址所对应的变量的值
//     fmt.Println(x)
// }

// func set_value(x_ptr *int) {
//     *x_ptr = 100
// }

// func main() {
//     x_ptr := new(int)
//     set_value(x_ptr)
//     // x_ptr指向的地址
//     fmt.Println(x_ptr)
//     // x_ptr本身的地址
//     fmt.Println(&x_ptr)
//     // x_ptr指向的地址值
//     fmt.Println(*x_ptr)
// }

// func swap(x, y *int) {
//     *x, *y = *y, *x  // 类似python的交叉赋值
// }

// func main() {
//     x_val := 100
//     y_val := 200
//     swap(&x_val, &y_val)
//     fmt.Println(x_val)
//     fmt.Println(y_val)
// }

// /* 结构体和接口 */
// type Rect struct {
//     width, length float64  // 定义新的数据类型
// }

// func main() {
//     var rect Rect
//     rect.width = 100
//     rect.length = 200
//     fmt.Println(rect.width * rect.length)
// }

// type Rect struct {
//     width, length float64
// }

// func main() {
//     var rect = Rect{width: 100, length: 200}  // 另一种赋值方式
//      fmt.Println(rect.width * rect.length)
// }

// type Rect struct {
//     width, length float64
// }

// func main() {
//     var rect = Rect{100, 200}  // 知道结构体成员定义的顺序之后，按照定义的顺序进行赋值
//     fmt.Println("width:", rect.width, "* length", rect.length, "= area", rect.width * rect.length)
// }

// type Rect struct {
//     width, length float64
// }

// func double_area(rect Rect) float64 {
//     rect.width *= 2  // Go是值传递，这里的修改并不会影响rect的值
//     rect.length *= 2
//     return rect.width * rect.length
// }

// func main() {
//     var rect = Rect{100, 200}
//     fmt.Println(double_area(rect))
//     fmt.Println("width:", rect.width, "length:", rect.length)
// }
// // 输出为80000 width: 100 length: 200

// // 结构体组合函数
// type Rect struct {
//     width, length float64
// }

// func (rect Rect) area() float64 {  // 结构体函数的内部方法
//     return rect.width * rect.length
// }

// func main() {
//     var re66ct = Rect{100, 200}
//     fmt.Println("width:", re66ct.width, "length:", re66ct.length, "area:", re66ct.area())
// }

// // 结构体和指针
// type Rect struct {
//     width, length float64
// }

// func (rect *Rect) area() float64 {
//     return rect.width * rect.length
// }

// func main() {
//     var rect = new(Rect)  // new返回的是一个结构体指针
//     rect.width = 100  // 结构体指针直接用.引用就行
//     rect.length = 200
//     fmt.Println("width:", rect.width, "length:", rect.length, "area:", rect.area())
// }

// type Rect struct {
//     width, length float64
// }

// func (rect *Rect) double_area() float64 {
//     rect.width *= 2  // 使用指针的目的就是在函数体内修改变量的值
//     rect.length *= 2
//     return rect.width * rect.length
// }

// func main() {
//     var rect = new(Rect)
//     rect.width = 100
//     rect.length = 200
//     fmt.Println(*rect)
//     fmt.Println("double width:", rect.width, "double length:", rect.length)
//     fmt.Println("double area:", rect.double_area())
//     fmt.Println(*rect)
// }

// 结构体内嵌类型
// type Phone struct {
//     price int
//     color string
// }

// type IPhone struct {
//     phone Phone
//     model string
// }

// func main() {
//     var p IPhone
//     p.phone.price = 5000
//     p.phone.color = "black"
//     p.model = "iphone 5"
//     fmt.Println("I have a iphone")
//     fmt.Println("price:", p.phone.price)
//     fmt.Println("color:", p.phone.color)
//     fmt.Println("model:", p.model)
// }

// type Phone struct {
//     price int
//     color string
// }

// type IPhone struct {
//     Phone
//     model string
// }

// func main() {
//     var p IPhone
//     p.price = 5000
//     p.color = "black"
//     p.model = "iphone 5"
//     fmt.Println(p)
// }

// type Phone struct {
//     price int
//     color string
// }

// func (phone Phone) ringing() {
//     fmt.Println("Phone is ringing")
// }

// type IPhone struct {
//     Phone
//     model string
// }

// func main() {
//     var p IPhone
//     p.price = 5000
//     p.color = "black"
//     p.model = "iphone 5"
    
//     fmt.Println("I have a iphone")
//     fmt.Println("Price:", p.price)
//     fmt.Println("color:", p.color)
//     fmt.Println("model:", p.model)

//     p.ringing()  // 结构体可以调用内嵌结构体的方法
// }

// /* 接口 */
// type NokiaPhone struct {
// }

// func (nokiaPhone NokiaPhone) call() {
//     fmt.Println("I am Nokia, I can call you!")
// }

// type IPhone struct {
// }

// func (iPhone IPhone) call() {
//     fmt.Println("I am iPhone, I can call you!")
// }

// func main() {
//     var nokia NokiaPhone
//     nokia.call()

//     var iPhone IPhone
//     iPhone.call()
// }

// type Phone interface {
//     call()
// }

// type NokiaPhone struct {
// }

// func (nokiaPhone NokiaPhone) call() {
//     fmt.Println("I am Nokia, I can call you!")
// }

// type IPhone struct {
// }

// func (iPhone IPhone) call() {
//     fmt.Println("I am iPhone, I can call you!")
// }

// func main() {
//     var phone Phone

//     phone = new(NokiaPhone)
//     phone.call()

//     phone = new(IPhone)
//     phone.call()
// }

// type Phone interface {
//     call()
//     sales() int
// }

// type NokiaPhone struct {
//     price int
// }

// func (nokiaPhone NokiaPhone) call() {
//     fmt.Println("I am Nokia, I can call you")
// }

// func (nokiaPhone NokiaPhone) sales() int {
//     return nokiaPhone.price
// }

// type IPhone struct {
//     price int
// }

// func (iPhone IPhone) call() {
//     fmt.Println("I am iPhone, I can call you")
// }

// func (iPhone IPhone) sales() int {
//     return iPhone.price
// }

// func main() {
//     var phones = [5]Phone{
//         NokiaPhone{price: 350}, 
//         IPhone{price: 5000}, 
//         IPhone{price: 3400}, 
//         NokiaPhone{price: 450}, 
//         IPhone{price: 50000}, 
//     }

//     var totalSales = 0
//     for _, phone := range phones {
//         totalSales += phone.sales()
//     }
//     fmt.Println(totalSales)
// }

type Phone interface {
    sales() int
}

type NokiaPhone struct {
    price int
}

func (nokiaPhone NokiaPhone) sales() int {
    return nokiaPhone.price
}

type IPhone struct {
    price int
}

func (iPhone IPhone) sales() int {
    return iPhone.price
}

type Person struct {
    phones []Phone
    name string
    age int
}

func (person Person) total_cost() int {
    var sum = 0
    for _, phone := range person.phones {
        sum += phone.sales()
    }
    return sum
}

func main() {
    var bought_phones = [5]Phone{
        NokiaPhone{price: 350}, 
        IPhone{price: 5000}, 
        IPhone{price: 3400}, 
        NokiaPhone{price: 450}, 
        IPhone{price: 5000}, 
    }

    var person = Person{name: "jemy", age: 35, phones: bought_phones[:]}

    fmt.Println(person.name)
    fmt.Println(person.age)
    fmt.Println(person.total_cost())
}
