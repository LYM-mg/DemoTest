//
//  Array+Extension.swift
//  ProductionReport
//
//  Created by i-Techsys.com on 16/12/22.
//  Copyright © 2016年 i-Techsys. All rights reserved.
// let part = [82, 58, 76, 49, 88, 90].partitionBy{$0 < 60}
// part // ([58, 49], [82, 76, 88, 90])

import UIKit

// MARK: - 数组过滤
extension Sequence{
    /// 然后依次取出原来序列中的元素，根据过滤结果将它放到第一个或第二个部分中。
    func anotherPartitionBy(fu: (Self.Iterator.Element)->Bool)->([Self.Iterator.Element],[Self.Iterator.Element]){
        return (self.filter(fu),self.filter({!fu($0)}))
    }
    
    typealias Element = Self.Iterator.Element
//    func partitionBy(fu: (Element)->Bool)->([Element],[Element]){
//        var first=[Element]()
//        var second=[Element]()
//        for el in self {
//            if fu(el) {
//                first.append(el)
//            }else{
//                second.append(el)
//            }
//        }
//        return (first,second)
//    }
    
    /// 第三种方法才实现了  然后依次取出原来序列中的元素，根据过滤结果将它放到第一个或第二个部分中。
//    var part3 = [82, 58, 76, 49, 88, 90].reduce( ([],[]), {
//        (a:([Int],[Int]),n:Int) -> ([Int],[Int]) in
//        (n<60) ? (a.0+[n],a.1) : (a.0,a.1+[n])
//    })
}



extension Array {
    // 防止数组越界1
    subscript(safeIndex index: Int) -> Element? {
        set {
            if index < self.count {// ,let newValue = newValue
               self[index] = (newValue ?? nil)!
            }
        }
        get {
            if index < self.count {
                return self[index]
            }
            else {
                return nil
            }
        }
    }
    // 防止数组越界2
    subscript(index: Int, safe: Bool) -> Element? {
        set {
            if safe {
                if index < self.count,let newValue = newValue   {
                    self[index] = newValue
                }
            } else {
                self[index] = (newValue ?? nil)!
            }
        }
        get {
            if safe {
                if self.count > index {
                    return self[index]
                }
                else {
                    return nil
                }
            }
            else {
                return self[index]
            }
        }

    }

    // 防止数组越界3
    // 取值
    func safe_object(at index: Int) -> Element? {
        if index < count {
            return self[index]
        } else {
            return nil
        }
        // return self[safeIndex: index]
    }

    // 赋值
    mutating func safe_object(at index: Int,ele: Element?){
        if index < self.count   {
            self[index] = (ele ?? nil)!
        }
        // return self[safeIndex: index] = ele
    }

    // 添加
    mutating func safe_addObject(_ object: Element?) {
        if object != nil {
            if let object = object {
                self.append(object)
            }
        }
    }

    // 添加数组
    mutating func safe_addObjects(fromArray array: [Element]?) {
        if let array = array {
            self.append(contentsOf: array)
        }
    }

    // 插入
    mutating func safe_insertObject(_ object: Element?,index: Index) {
        if let object = object, index < self.count   {
           self.insert(object, at: index)
        }
    }

    // 插入数组
    mutating func safe_insertObjects(fromArray array: [Element]?,index: Index) {
        if let array = array, index < self.count{
            self.insert(contentsOf: array, at: index)
        }
    }

    // 移除某一个数据
    mutating func safe_remove(_ index: Int) {
        if index < self.count   {
            self.remove(at: index)
        }
    }
}

extension NSMutableArray {
    func safe_addObject(_ object: Element?) {
        if object != nil {
            if let object = object {
                self.add(object)
            }
        }
    }

    func safe_addObjects(fromArray array: [Element]?) {
        if array != nil {
            if let array = array {
                self.addObjects(from: array)
            }
        }
    }

    func safe_remove(_ object: Element?) {
        if object != nil {
            if let object = object {
                self.remove(object)
            }
        }
    }
}

extension Array {
    subscript(input: [Int]) -> ArraySlice<Element> {
        get {
            var result = ArraySlice<Element>()
            for i in input {
                assert(i < self.count, "Index out of range")
                result.append(self[i])
            }
            return result
        }
        
        set {
            for (index,i) in input.enumerated() {
                assert(i < self.count, "Index out of range")
                self[i] = newValue[index]
            }
        }
    }
    
    func test() {
        var arr = [1,2,3,4,5]
        print(arr[[0,2,3]])            //[1,3,4]
        arr[[0,2,3]] = [-1,-3,-4]
        print(arr)                     //[-1,2,-3,-4,5]
    }
}



// MARK: - 最小值和最大值 的获取
extension Array {
    //Find the minimum of an array of Ints
//    [10,-22,753,55,137,-1,-279,1034,77].sorted().first
//    [10,-22,753,55,137,-1,-279,1034,77].reduce(Int.max, min)
//    [10,-22,753,55,137,-1,-279,1034,77].min()
    
    //Find the maximum of an array of Ints
//    [10,-22,753,55,137,-1,-279,1034,77].sorted().last
//    [10,-22,753,55,137,-1,-279,1034,77].reduce(Int.min, max)
//    [10,-22,753,55,137,-1,-279,1034,77].max()
    
    // 我们使用 filter 方法判断一条推文中是否至少含有一个被选中的关键字：
//    let words = ["Swift","iOS","cocoa","OSX","tvOS"]
//    let tweet = "This is an example tweet larking about Swift"
//    
//    let valid = words.first(where: {tweet.contains($0)})?.isEmpty
    
    
    // 使用析构交换元组中的值
//    var a=1,b=2
//    
//    (a,b) = (b,a)
}

// MARK: - for循环遍历
extension Sequence {
    /*
    一、 stride(from: 0, to: colors.count, by: 2) 返回以0开始到5的数字（上限不包含5），步长为2。对于 for-loop，这是一个好的替代。
    
    二、 如果上限必须包含进来，这里有另外一种函数格式：
    stride(from: value, through: value, by: value) 。第二个参数的标签是 through ， 这个标签是用以指明是包含上限的。
     */
    
    
    /*
     let numbers = [1, 6, 2, 0, 7], nCount = numbers.count
     var index = 0
     while (index < nCount && numbers[index] != 0) {
        print(numbers[index])
        index += 1
     }
     */
}
