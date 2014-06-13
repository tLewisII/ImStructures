// Playground - noun: a place where people can play

import Cocoa

struct ImArray<A> : Sequence {
    let backing:Array<A> = Array()
    
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
    
    init() {}
    
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
        var arr = Array(backing)
        arr += item
        return ImArray(array: arr)
    }
    
    func join(array:Array<A>) -> ImArray<A> {
        switch array {
        case []: return self
        case _: var newArr = Array(backing)
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
            var newArr = Array(backing)
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
    
    func reduce<U>(start:U, f:((U,A) -> U)) -> U {
        return backing.reduce(start, combine: f)
    }
    
    
    func sort(f:(A,A) -> Bool) -> ImArray<A> {
        var newArr = Array(backing)
        newArr.sort(f)
        return ImArray(array: newArr)
    }
    
    func generate() -> ImArrayGenerator<A>  {
        let items = Array(backing)
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

extension ImArray : ArrayLiteralConvertible {
    static func convertFromArrayLiteral(elements: A...) -> ImArray<A> {
        return ImArray(array:elements)
    }
}

extension ImArray {
    func scanl<B>(start:B, r:(B, A) -> B) -> ImArray<B> {
        if self.isEmpty {
            return ImArray<B>(array: [])
        }
        var arr = Array<B>()
        arr += start
        var reduced = start
        for x in self {
            reduced = r(reduced, x)
            arr += reduced
        }
        return ImArray<B>(array: arr)
    }
    
    //tuples can not be compared with '==' so I will hold off on this for now. rdar://17219478
    //    func zip<B>(scd:ImArray<B>) -> ImArray<(A,B)> {
    //        var size = min(self.count, scd.count)
    //        var newArr = Array<(A,B)>()
    //        for x in 0..size {
    //            newArr += (self[x], scd[x])
    //        }
    //        return ImArray<(A,B)>(array:newArr)
    //    }
    //
    //    func zip3<B,C>(scd:ImArray<B>, thrd:ImArray<C>) -> ImArray<(A,B,C)> {
    //        var size = min(self.count, scd.count, thrd.count)
    //        var newArr = Array<(A,B,C)>()
    //        for x in 0..size {
    //            newArr += (self[x], scd[x], thrd[x])
    //        }
    //        return ImArray<(A,B,C)>(array:newArr)
    //    }
    //
    //    func zipWith<B,C>(scd:Array<B>, f:((A, B) -> C)) -> ImArray<C> {
    //        var size = min(self.count, scd.count)
    //        var newArr = Array<C>()
    //        for x in 0..size {
    //            newArr += f(self[x], scd[x])
    //        }
    //        return ImArray<C>(array:newArr)
    //    }
    //
    //    func zipWith3<B,C,D>(scd:Array<B>, thrd:Array<C>, f:((A, B, C) -> D)) -> ImArray<D> {
    //        var size = min(self.count, scd.count, thrd.count)
    //        var newArr = Array<D>()
    //        for x in 0..size {
    //            newArr += f(self[x], scd[x], thrd[x])
    //        }
    //        return ImArray<D>(array:newArr)
    //    }
    
    func find(f:(A -> Bool)) -> A? {
        for x in self {
            if f(x) {
                return .Some(x)
            }
        }
        return .None
    }
    
    func splitAt(index:Int) -> (ImArray<A>, ImArray<A>) {
        switch index {
        case 0..self.count: return (ImArray(array:self[0..index].array), ImArray(array:self[index..self.count].array))
        case _:return (ImArray<A>(), ImArray<A>())
        }
    }
    
    func intersperse(item:A) -> ImArray<A> {
        func prependAll(item:A, array:Array<A>) -> Array<A> {
            var arr = Array([item])
            for i in 0..(array.count - 1) {
                arr += array[i]
                arr += item
            }
            arr += array[array.count - 1]
            return arr
        }
        if self.isEmpty {
            return self
        } else if self.count == 1 {
            return self
        } else {
            var array = Array([self[0]])
            array += prependAll(item, Array(self[1..self.count]))
            return ImArray(array:array)
        }
        
    }
}

func ==<A:Equatable>(lhs:ImArray<A>, rhs:ImArray<A>) -> Bool {
    return lhs.array == rhs.array
}

func !=<A:Equatable>(lhs:ImArray<A>, rhs:ImArray<A>) -> Bool {
    return !(lhs.array == rhs.array)
}

func +=<A>(lhs:ImArray<A>, rhs:A) -> ImArray<A> {
    return lhs.append(rhs)
}

struct ImDictionary<K: Hashable, V> {
    let backing = Dictionary<K, V>()
    
    var dictionary:Dictionary<K, V> {
    return backing
    }
    
    var count:Int {
    return self.count
    }
    
    var keys:ImArray<K> {
    return ImArray(array: Array(backing.keys))
    }
    
    var values:ImArray<V> {
    return ImArray(array: Array(backing.values))
    }
    
    init(elements:(K, V)...) {
        for (k,v) in elements {
            backing[k] = v
        }
    }
    
    init(dict:Dictionary<K, V>) {
        backing = dict
    }
    
    func update(k:K, v:V) -> ImDictionary<K, V> {
        var temp = backing
        temp[k] = v
        return ImDictionary(dict:temp)
    }
    
    func remove(k: K) -> ImDictionary<K,V> {
        var temp = backing
        temp.removeValueForKey(k)
        return ImDictionary(dict: temp)
    }
    
    subscript (key: K) -> V? {
        return backing[key]
    }
}

extension ImDictionary : DictionaryLiteralConvertible {
    static func convertFromDictionaryLiteral(elements:(K, V)...) -> ImDictionary<K, V> {
        var temp = Dictionary<K,V>()
        for (k,v) in elements {
            temp[k] = v
        }
        return ImDictionary(dict: temp)
    }
}

let dict:ImDictionary<Int, Int> = [1:1, 2:2, 3:3]
dict.update(1, v: 2)
dict.remove(3)
dict

let imArray = ImArray(items:1,2,3,4,5,6)
imArray.sort(>)

imArray.join([1,2,3])

imArray.join(ImArray(item: 1))
imArray.scanl(0, r: +)
let found = imArray.find{$0 == 4}
found
imArray.reduce(0, f:+)
imArray.intersperse(9)
imArray.reduce(0, f:+)



let split = imArray.splitAt(3)
split.0
imArray


@prefix func +(a:Int) -> Int -> Int {
    return {a + $0}
}

let add1 = +1

let mapped = imArray.map(add1)
mapped


