//
//  ImArray.swift
//  ImStructures
//
//  Created by Terry Lewis II on 6/8/14.
//  Copyright (c) 2014 Blue Plover Productions LLC. All rights reserved.
//

import Foundation

struct ImArray<A: Equatable> : Sequence {
    var backing:Array<A> = Array()
    
    var array:Array<A> {
        return backing
    }
    
    subscript(index:Int) -> A {
        return backing[index]
    }
    
    subscript(subRange:Range<Int>) -> ImArray<A> {
        return ImArray(array: Array(backing[subRange]))
    }
    
    var count:Int {
    return backing.count
    }
    
    var isEmpty:Bool {
    return backing.isEmpty
    }
    
    init(items:A...) {
        backing = Array(items)
    }
    
    init(array:A[]) {
        backing = Array(array)
    }
    
    init(item:A) {
        backing = Array([item])
    }
    
    func append(item:A) -> ImArray<A> {
        var arr = backing
        arr += item
        return ImArray(array: arr)
    }
    
    func join(array:Array<A>) -> ImArray<A> {
        switch array {
        case []: return self
        case _: var newArr = backing
        for x in array {
            newArr += x
        }
        return ImArray(array: newArr)
        }
    }
    
    func join(imArray:ImArray<A>) -> ImArray<A> {
        if imArray.isEmpty {
            return self
        } else {
            var newArr = backing
            for x in imArray {
                newArr += x
            }
            return ImArray(array: newArr)
        }
    }
    
    func filter(f:(A -> Bool)) -> ImArray<A> {
        return ImArray(array: backing.filter(f))
    }
    
    func map<B>(f:(A -> B)) -> ImArray<B> {
        return ImArray<B>(array: backing.map(f))
    }
    
    func reduce<B>(start:B, f:((A,B) -> B)) -> B {
        var reduced = start
        for x in self {
            reduced = f(x, reduced)
        }
        return reduced
    }
    
    func sort(f:(A,A) -> Bool) -> ImArray<A> {
        var newArr = backing
        newArr.sort(f)
        return ImArray(array: newArr)
    }
    
    func generate() -> ImArrayGenerator<A>  {
        let items = backing
        return ImArrayGenerator(items: items[0..items.count])
    }
}

struct ImArrayGenerator<A> : Generator {
    mutating func next() -> A?  {
        if items.isEmpty { return nil }
        let ret = items[0]
        items = items[1..items.count]
        return ret
    }
    
    var items:Slice<A>
}

func ==<A>(lhs:ImArray<A>, rhs:ImArray<A>) -> Bool {
    return lhs.array == rhs.array
}

func !=<A>(lhs:ImArray<A>, rhs:ImArray<A>) -> Bool {
    return !(lhs.array == rhs.array)
}

func +=<A>(lhs:ImArray<A>, rhs:A) -> ImArray<A> {
    return lhs.append(rhs)
}
