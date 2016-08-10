//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
print("hello,world")
//let声明常量 var声明变量
let year:CGFloat = 98
var sum: NSInteger = 888
let letCount : CGFloat = 999.0
//字符串+数字
let sumi = "hello"
let width : NSInteger = 90

let sumWidth = sumi + String(width)
//定义2个常量 用\转换数字为字符串

let num1 = 4
let num2 = 5
let appleSum = "I have \(num1) apple"
let fruitSum = "I have \(num1 + num2) fruit"

let floatS = 2.555
let floatSum = "I have solon \(floatS)"
//数组和字典的使用

var shoppingList = ["catfish","water","tulips","bluePaint"]
shoppingList[1] = "bottle of water"

var occupations = [
    "Malcolm" : "Captain",
    "Kaylee" : "Mechanic",
]

occupations["jayne"] = "Public Relation"

//创建一个空数组或者是字典
let emptyArray = [String]()
let emptyDictionary = [String : Float]()

let individualScores = [75,43,103,87,12]
var teamScore = 0

for score in individualScores {
    if score > 50 {
        teamScore += 3
    } else {
        teamScore += 1
    }
}

print(teamScore)

//可选值,因为swift特殊语法如 if score 这样的条件表达式
//score不会隐式与0作对比，所以会报错,如下所示

//if emptyArray {
//    
//}
var optionalString: String? = "hello"
print(optionalString == nil)

var optionalName: String? = "solon"
var greeting = "Hello!"

if let name = optionalName {
    greeting = "hello,\(name)"
}

//switch case

let vagetable = "red pepper"

switch vagetable {
case "celery" :print("Add some raisins")
case "cucumber","watercress" :print("That would make a")
case let x where x.hasSuffix("pepper") : print("Is it a spicy \(x)?")
default:print("everything tastes")
    
}

//使用forin便利字典求最大数
var interestingNumbers = [
    "prime" : [2,3,5,7,11],
    "Fibonacci":[1,1,2,3],
    "Square":[1,4,9,16,25],
]

var largest = 0

for (kind,numbers) in interestingNumbers {
    for number in numbers {
        if number > largest {
            largest = number
        }
    }
}

print(largest)


//使用while 也可以把条件放在结尾

var n = 2
while n < 100 {
    n = n * 2
}

print(n)

var m = 2

repeat {
    m = m * 2
} while m < 100

print(m)

//使用..<表示范围

var firstForLoop = 0

for i in 0 ..< 4 {
    firstForLoop += i
}

print(firstForLoop)

var secondForLoop = 0
for var i = 0;i < 4;++i {
    secondForLoop += i
}
print(secondForLoop)


//函数和闭包 使用->表示返回值类型

func greet(name:String, day: String) ->String {
    return "Hello \(name),today is \(day)"
}

greet("Bob", day: "Tuesday")

//使用元组让数组返回多个参数
func calculateStatistics(scores :[Int])->(min: Int,max: Int,sum: Int) {
    var min = scores[0]
    var max = scores[0]
    var sum = 0
    
    for score in scores {
        if score > max {
            max = score
        }else if score < min {
            min = score
        }
        sum += score
    }
    
    return (min,max,sum)
}



let statistics = calculateStatistics([2,3,5,34,23,33,99])

print(statistics.sum)
print(statistics.2)


//函数可以带有可变个数的参数
func sumOf(numbers: Int...) ->Int {
    var sum = 0
    for number in numbers {
        sum += number
    }
    
    return sum
}

sumOf()
sumOf(42,777,34)

//函数可以嵌套，被嵌套的函数可以访问外侧函数的变量
func returnFifteen() -> Int {
    var y = 10
    func add() {
        y += 5
    }
    add()
    return y
}

returnFifteen();

//函数可以作为另一个函数的返回值
func makeIncrementer() -> (Int -> Int) {
    func addOne(number:Int) ->Int {
        return 1 + number
    }
    return addOne
}

var increment = makeIncrementer()
increment(7)

//函数也可以当做参数传入另一个函数
func hasAnyMatches(list:[Int],contition:Int -> Bool) ->Bool {
    
}


