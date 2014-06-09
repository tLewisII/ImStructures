// Playground - noun: a place where people can play

import Cocoa

struct ImArray<A: Equatable> : Sequence {
    var backing:Array<A> = Array()
    
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



let imArray = ImArray(items:1,2,3,4,5,6,7)
imArray.join([1,2,3])
imArray.join(ImArray(item: 1))

imArray.reduce(0, f:+)