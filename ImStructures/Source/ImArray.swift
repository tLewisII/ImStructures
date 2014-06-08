//
//  ImArray.swift
//  ImStructures
//
//  Created by Terry Lewis II on 6/8/14.
//  Copyright (c) 2014 Blue Plover Productions LLC. All rights reserved.
//

import Foundation

struct ImArray<A: Equatable> : Sequence {
    var backing:A[] = Array<A>()
    
    var array:Array<A> {
        return backing
    }
    
    subscript(subRange:Int) -> A {
        return backing[subRange]
    }
    
    var count:Int {
        return backing.count
    }
    
    var isEmpty:Bool {
        return backing.isEmpty
    }
    
    init(items:A[]...) {
        backing.join(items)
    }
    
    init(array:A[]) {
        backing.join(array)
    }
    
    init(item:A) {
        backing += item
    }
    
    func append(item:A) -> ImArray<A> {
        var arr = backing
        arr += item
        return ImArray(array: arr)
    }
    
    func join(array:A[]) -> ImArray<A> {
        switch array {
        case []: return self
        case _: return ImArray(array: backing.join(array))
        }
    }
    
    func join(imArray:ImArray<A>) -> ImArray<A> {
        if imArray.isEmpty {
            return self
        } else {
            return join(backing.join(imArray.array))
        }
    }
    
    func filter(f:(A -> Bool)) -> ImArray<A> {
        return ImArray(array: backing.filter(f))
    }
    
    func map<B>(f:(A -> B)) -> ImArray<B> {
        return ImArray<B>(array: backing.map(f))
    }
    
    func reduce<B: Equatable>(start:B, f:((A,B) -> B)) -> B {
        var reduced = start
        for x in self {
            reduced = f(x, reduced)
        }
        return reduced
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

