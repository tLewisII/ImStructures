//
//  ImDictionary.swift
//  ImStructures
//
//  Created by Terry Lewis II on 6/12/14.
//  Copyright (c) 2014 Blue Plover Productions LLC. All rights reserved.
//

struct ImDictionary<K:Hashable, V:Comparable> : Sequence {
    let backing = Dictionary<K, V>()
    
    var dictionary:Dictionary<K, V> {
    return backing
    }
    
    var count:Int {
    return backing.count
    }
    
    var null:Bool {
    return backing.count == 0
    }
    
    var toObjc:NSDictionary {
    return NSDictionary(dictionary: backing)
    }
    
    var keys:ImArray<K> {
    return ImArray(array: Array(backing.keys))
    }
    
    var values:ImArray<V> {
    return ImArray(array: Array(backing.values))
    }
    
    init() {
       /// empty dict
    }
    
    init(elements:(K, V)...) {
        for (k,v) in elements {
            backing[k] = v
        }
    }
    
    init(dict:Dictionary<K, V>) {
        backing = dict
    }
    
    func findWithDefault(k:K, def:V) -> V {
        if let found = self[k] {
            return found
        } else {
            return def
        }
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
    
    func map<A,B>(f:(K,V) -> (A,B)) -> ImDictionary<A,B> {
        var temp = Dictionary<A,B>()
        for (k,v) in backing {
            let (newK, newV) = f(k,v)
            temp[newK] = newV
        }
        
        return ImDictionary<A,B>(dict: temp)
    }
    
    func filter(f:(K,V) -> Bool) -> ImDictionary<K,V> {
        var temp =  Dictionary<K,V>()
        for (k, v) in backing {
            if f(k,v) {
                temp[k] = v
            }
        }
        return ImDictionary(dict: temp)
    }
    
    func reduce<A>(start:A, f:(K, V, A) -> A) -> A {
        var reduced = start
        for (k,v) in backing {
            reduced = f(k,v, reduced)
        }
        return reduced
    }
    
    subscript (key: K) -> V? {
        return backing[key]
    }
    
    func generate() -> ImDictGenerator<K,V>  {
        var items = Array<(K, V)>()
        for (k,v) in backing {
            items += (k, v)
        }
        return ImDictGenerator(items: items[0..items.count])
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

struct ImDictGenerator<K, V> : Generator {
    mutating func next() -> (K,V)?  {
        if items.isEmpty { return nil }
        let ret = items[0]
        items = items[1..items.count]
        return ret
    }
    
    var items:Slice<(K,V)>
}


func ==<A:Hashable, B:Equatable>(lhs:ImDictionary<A,B>, rhs:ImDictionary<A,B>) -> Bool {
    return lhs.backing == rhs.backing
}

func !=<A:Hashable, B:Equatable>(lhs:ImDictionary<A,B>, rhs:ImDictionary<A,B>) -> Bool {
    return !(lhs.backing == rhs.backing)
}

