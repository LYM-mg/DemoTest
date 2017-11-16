//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

//let num: Int64 = 111114441111
//String(format: "%014ld", num)
//
//let heihie = 111
//String(format: "%014ld", heihie)
//
//let num2 = 222
//String(format: "%08ld", num2)
//
//let heihie2 = 99
//String(format: "%08ld", heihie2)
//let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//btn.setTitle("大笨蛋", for: .normal)
//btn.subviews.map {
//    print($0)
//}

struct RegexHelper {
    let regex: NSRegularExpression
    
    /* pattern: 正则表达式 */
    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern,
                                        options: .caseInsensitive)
    }
    
    /* input: 要匹配的字符串 */
    func match(_ input: String) -> Bool {
        let matches = regex.matches(in: input,
                                    options: [],
                                    range: NSMakeRange(0, input.utf16.count))
        return matches.count > 0
    }
    
    static func testMail() {
        let mailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let matcher: RegexHelper
        do {
            matcher = try! RegexHelper(mailPattern)
        }
        
        let maybeMailAddress = "1292043630@qq.com" //"onev@onevcat.com" 1292043630@qq.com
        if matcher.match(maybeMailAddress) {
            print("有效的邮箱地址")
        }else {
            print("无效的邮箱地址")
        }
    }
}

RegexHelper.testMail()

precedencegroup MatchPrecedence {
    associativity: none
    higherThan: DefaultPrecedence
}

infix operator =~: MatchPrecedence

func =~(lhs: String, rhs: String) -> Bool {
    do {
        return try RegexHelper(rhs).match(lhs)
    } catch _ {
        return false
    }
}


if "onev@onevcat.com" =~
"^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$" {
    print("有效的邮箱地址")
}

9<<2
8>>2
9>>2

//let test = "helLo"
//let interval = "a"..."z"
//for c in test {
//    if !interval.contains(String(c)) {
//        print("\(c) 不是小写字母")
//    }
//}

//class MusicViewController: UIViewController {}
//class AlbumViewController: UIViewController {}
//let usingVCTypes: [AnyClass] = [MusicViewController.self,
//                                AlbumViewController.self]
//func setupViewControllers(_ vcTypes: [AnyClass]) {
//    for vcType in vcTypes {
//        if vcType is UIViewController.Type {
//            let vc = (vcType as! UIViewController.Type).init()
//            print(vc)
//        }
//    }
//}
//setupViewControllers(usingVCTypes)

//let data = 1...3
//let result = data.map {
//    (i: Int) -> Int in
//    print("正在处理 \(i)")
//    return i * 2
//}
//
//print("准备访问结果")
//for i in result {
//    print("操作后结果为 \(i)")
//}
//
//print("操作完毕")

//struct Person {
//    let name: String
//    let age: Int
//}
//
//let xiaoMing = Person(name: "XiaoMing", age: 26)
//let r = Mirror(reflecting: xiaoMing) // r 是 MirrorType
//xiaoMing.self
//for child in r.children {
//    print("属性名:\(String(describing: child.label))，值:\(child.value)")
//}
//
//func valueFrom(_ object: Any, key: String) -> Any? {
//    let mirror = Mirror(reflecting: object)
//    for child in mirror.children {
//        let (targetKey, targetMirror) = (child.label, child.value)
//        if key == targetKey {
//            return targetMirror
//        }
//    }
//    return nil
//}
//
//dump(xiaoMing)
//dump(valueFrom(xiaoMing, key: "name"))


//func loadBigData() {
//    if let path = Bundle.main.path(forResource: "big", ofType: ".jpg") {
//        for _ in 1...10000 {
//            autoreleasepool {
////                let data = NSData.init(contentsOfFile: path)
//                Thread.sleep(forTimeInterval: 0.5)
//            }
//        }
//    }
//}


//var a = [1,2,3]
//var b = a
//let c = b
//
//dump(UnsafePointer(a));
//dump(UnsafePointer(b));
//dump(UnsafePointer(c));

//var d: CInt = 123
//memory(d)    // 输出 123”

typealias Task = (_ cancel : Bool) -> Void
func delay(_ time: TimeInterval, task: @escaping ()->()) ->  Task? {
    func dispatch_later(block: @escaping ()->()) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    
    var closure: (()->Void)? = task
    var result: Task?
    
    let delayedClosure: Task = {
        cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    return result;
}

func cancel(_ task: Task?) {
    task?(true)
}



delay(2) { print("2 秒后输出") }
let task = delay(3) { print("拨打 110") }
let task1 = delay(4) { print("拨打 110") }
// 仔细想一想..
// 还是取消为妙..
//cancel(task)

class ClassA: NSObject { }
class ClassB: ClassA { }

let obj1: NSObject = ClassB()
let obj2: NSObject = ClassB()

obj1.isKind(of: ClassA.self)    // true
obj2.isMember(of: ClassA.self)  // false


class MyClass: NSObject {
    @objc dynamic var date = Date()
}

private var myContext = 0

class Class: NSObject {
    
    var myObject: MyClass!
    
    override init() {
        super.init()
        
        myObject = MyClass()
        print("初始化 MyClass，当前日期: \(myObject.date)")
        myObject.addObserver(self,
                             forKeyPath: "date",
                             options: .new,
                             context: &myContext)
        
        let t = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: t) {
            self.myObject.date = Date()
        }
        myObject.observe(\MyClass.date, options: [.new]) { (_, change) in
            if let newDate = change.newValue {
                print("AnotherClass 日期发生变化 \(newDate)")
            }
        }
        
        delay(1) { self.myObject.date = Date() }
    }
}

let obj = Class()

print("打印前")
DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
    print("打印后")
}

//func has(list: [Int], condition: (Int)->Bool) -> Bool {
//    for item in list {
//        if condition(item) {
//            print("true")
//            return true
//        }
//    }
//    print("false")
//    return false
//}
//
//func lessThan(n: Int) -> Bool {
//    return n < 10
//}
//var numbes = [23,21,32,21]
//has(list: numbes, condition: lessThan)
//
//
//
//
//func addOne(n: Int) -> Int{
//    return n + 1
//}
//
//func addTo(n: Int) -> (Int) -> Int{
//    return {
//        num in
//        return num + n
//    }
//}
//
//addTo(n: 1)(2)

//var n: Int = 0
//let num: Int = 100
//var sum = 0
//while (n<=num) {
//    sum += n
//    n+=1
//}
//print(sum)


// 链表
/**
     数组样例：
     a = [1,2,7,8,9]
 
     数组的优点：
     查询快速
     要查询数组的第三个元素
     a[2] 很快就找到了7
 
     缺点：
     增删耗时间
     如果我要在2和7之间增添一个5
     那么我需要将后面的7，8，9都向后移动一位
     因为数组的元素是连续存放的
 */

//链表刚好相反，它查询耗费时间，但是添加删除却是非常快的。

// 定义节点
class Node {
    var value: String!
    var previous: Node?
    var next: Node?
}

// 定义链表
class Link {
    private var top: Node?
    var current: Node?
    
    func getCount() -> Int{
        if (top == nil) {
            return 0
        }else {
            var count = 1
            var item = top
            while item!.next != nil {
                count += 1
                item = item?.next
            }
            return count
        }
    }
    //加一个节点
    func append(value: String) {
        if (top == nil) { // 第一个节点
            top = Node()
            current = top
        }else {
            let node = Node()
            node.value = value
            current!.next = node
            node.previous = current
            current = node
        }
    }
    
    /// 删除指定节点
    ///
    /// - Parameter index: 索引位置
    func delete(index: Int) {
        let count = getCount();
        if index >= count {
            print("索引越界")
            return;
        }
        
        if count == 1 {
            top = nil
            current = nil
        }
        var item = top
        for _ in 0..<index {
            item = item!.next // 找到要删除的表
        }
        item?.previous?.next?.next = item?.next
        item?.next?.previous = item?.previous
        
        if item === current {
            current = item?.previous
        }
        
        if top === item {
            top = item?.next
        }
    }
    
    func showLog() {
        guard top != nil else {
            print("该表还没有任何数据")
            return
        }
        var item = top
        while item != nil {
            print(item!.value, separator: "\n", terminator: "-->")
            item = item!.next
        }
    }
}

let link = Link()
link.append(value: "小傻瓜")
link.append(value: "小笨蛋")
link.append(value: "小可爱")
link.append(value: "小女子")
link.append(value: "小女孩")

link.showLog()
link.delete(index: 0)
link.showLog()
link.delete(index: 10)


