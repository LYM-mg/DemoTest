//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


let num: Int64 = 111114441111
String(format: "%014ld", num)

let heihie = 111
String(format: "%014ld", heihie)

let num2 = 222
String(format: "%08ld", num2)

let heihie2 = 99
String(format: "%08ld", heihie2)
let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
btn.setTitle("大笨蛋", for: .normal)
btn.subviews.map {
    print($0)
}
