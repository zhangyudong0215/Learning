package main

import (
    "fmt"
)

func main() {
    /* 支持批量定义变量 */
//    var (
//        a int = 10
//        b float64 = 32.45
//        c bool = true
//    )
//    const (
//        Pi float64 = 3.14
//        True bool = true
//    )
//
//    fmt.Println(a, b, c)
//    fmt.Println(Pi, True)

    /* 控制流语句 */
//    var dog_age = 10
//    
//    if dog_age > 10 {
//        fmt.Println("A big dog")
//    } else if dog_age > 1 && dog_age <= 10 {
//        fmt.Println("A small dog")
//    } else {
//        fmt.Println("A baby dot")
//    }

//    const Male = 'M'
//    const Female = 'F'
//    
//    var dog_age = 10
//    var dog_sex = 'M'
//    
//    if dog_age == 10 && dog_sex == 'M' {  // if判断条件后面并不一定要加括号，加了也没错
//        fmt.Println("doggggg")
//    }

    /* switch */
    // score 为 [0, 100] 之间的整数
//    var score int = 69
//    
//    if score >= 90 && score <= 100 {
//        fmt.Println("优秀")
//    } else if score >= 80 && score < 90 {
//        fmt.Println("良好")
//    } else if score >= 70 && score < 80 {
//        fmt.Println("一般")
//    } else if score >= 60 && score < 70 {
//        fmt.Println("及格")
//    } else {
//        fmt.Println("不及格")
//    }

//    var score int = 99
//    
//    switch score / 10 {
//        case 10: 
//            fmt.Println("满分")
//        case 9: 
//            fmt.Println("优秀")
//        case 8: 
//            fmt.Println("良好")
//        case 7: 
//            fmt.Println("一般")
//        case 6: 
//            fmt.Println("及格")
//        default: 
//            fmt.Println("不及格")
//    }

//    var dog_sex = "F"
//    
//    switch dog_sex {
//    case "M": 
//        fmt.Println("A male dog")
//    case "F": 
//        fmt.Println("A female dog")
//    }

//    var i int = 1
//    
//    for ; i <= 100; i++ {
//        fmt.Println(i)
//    }

//    for i := 1; i <= 100; i++ {  // 可以把i的初始化和定义也放到for里面
//        fmt.Println(i)
//    }

//    /* 数组，切片和字典 */
//    var x [5]int
//    x[0] = 2
//    var sum int
//    for _, elem := range x {
//        sum += elem
//    }
//    fmt.Println(sum, x[0], x[1], x[2], x[3], x[4])

//    var x = [5]int{1, 2, 3, 4}
//    x[4] = 5
//    
//    var sum int
//    for _, i := range x {
//        sum += i
//    }
//    fmt.Println(sum)

//    var x = [...]string{
//        "monday", 
//        "tuesday", 
//        "wednesday", 
//        "thursday", 
//        "friday", 
//        "saturday", 
//        "sunday最后一项后面要加逗号，或者将大括号移到行尾", 
//    }
//    
//    for _, day := range x {
//        fmt.Println(day)
//    }

//    var x = make([]float64, 5)  // 切片的赋值方式
//    fmt.Println("Capcity:", cap(x), "Lenth:", len(x))
//    var y = make([]float64, 5, 10)
//    fmt.Println("Capcity:", cap(y), "Lenth:", len(y))
//    
//    for i := 0; i < len(x); i++ {
//        y[i] = float64(i)
//    }
//    fmt.Println(y)

//    var arr1 = [5]int{1, 2, 3, 4, 5}
//    var s1 = arr1[2:3]
//    var s2 = arr1[:3]
//    var s3 = arr1[2:]
//    var s4 = arr1[:]
//    fmt.Println(s1)
//    fmt.Println(s2)
//    fmt.Println(s3)
//    fmt.Println(s4)

//    var arr1 = make([]int, 5, 10)
//    for i := 0; i < len(arr1); i++ {
//        arr1[i] = i
//    }
//    
//    fmt.Println(arr1)
//    
//    arr1 = append(arr1, 5, 6, 7, 8)  // append函数为切片增加元素
//    fmt.Println("Capacity:", cap(arr1), "Length:", len(arr1))
//    fmt.Println(arr1)
//    
//    arr1 = append(arr1, 9, 10)  // 超过了切片定义的容量，Go会自动重新分配容量，为原来的两倍
//    fmt.Println("Capacity:", cap(arr1), "Length:", len(arr1))
//    fmt.Println(arr1)

//    slice1 := []int{1, 2, 3, 4, 5, 6}
//    slice2 := make([]int, 5, 10)
//    copy(slice2, slice1)  // 复制
//    slice2[0] = 666  // 看看是不是会修改slice1的值，结果是不会的
//    fmt.Println(slice1)
//    fmt.Println(slice2)

//    var x = map[string]string{  // string:string类型的字典，其中[]里面的是key类型，右边的是value类型
//        "a": "apple", 
//        "b": "banana", 
//        "o": "orange", 
//        "p": "pear", 
//    }
//    
//    for key, val := range x {  // range函数也可以对字典使用
//        fmt.Println("key:", key, "value:", val)
//    }

//    var x map[string]string
//    
//    x = make(map[string]string)  // 相当于初始化，如果没有这行会报错
//    
//    x["a"] = "apple"
//    x["b"] = "banana"
//    
//    for key, val := range x {
//        fmt.Println("key:", key, "value:", val)
//    }

//    x := make(map[string]string)  // 定义和初始化结合在一起的写法
//    
//    x["a"] = "apple"
//    x["b"] = "banana"
//    
//    for key, val := range x {
//        fmt.Println("key:", key, "value:", val)
//    }

//    x := make(map[string]int)
//    
//    x["a"] = 0
//    x["b"] = 20
//    
//    fmt.Println(x["c"])  // 不存在key为"c"的值，返回默认值0，但是和"a"的值重复了

//    x := make(map[string]int)
//    
//    x["a"] = 0
//    x["b"] = 20
//    _, b1 := x["b"]
//    
//    if val, ok := x["c"]; ok {
//        fmt.Println(val)
//    }
//    
//    fmt.Println(b1)

//    x := make(map[string]int)
//    
//    x["a"] = 10
//    x["b"] = 20
//    x["c"] = 30
//    x["d"] = 40
//    
//    fmt.Println("before delete")
//    fmt.Println("length:", len(x))
//    fmt.Println(x)
//    
//    delete(x, "a")
//    
//    fmt.Println("after delete")
//    fmt.Println("length:", len(x))
//    fmt.Println(x)

//    var facebook = make(map[string]map[string]int)
//    facebook["0616020432"] = map[string]int{"jemy": 25}
//    facebook["0616020433"] = map[string]int{"andy": 23}
//    facebook["0616020434"] = map[string]int{"bill": 22}
//    
//    for stu_no, stu_info := range facebook {
//        fmt.Println("student:", stu_no)
//        for name, age := range stu_info {
//            fmt.Println("name:", name, "age:", age)
//        }
//        fmt.Println()
//    }

    var facebook = map[string]map[string]int{
        "06020432": {"jemy": 25}, 
        "06020433": {"andy": 23}, 
        "05020434": {"bill": 22},
    }
    
    for stu_no, stu_info := range facebook {
        fmt.Println("student:", stu_no)
        for name, age := range stu_info {
            fmt.Println("name:", name, "age:", age)
        }
        fmt.Println()
    }

    
}
