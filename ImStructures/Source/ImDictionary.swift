//
//  ImDictionary.swift
//  ImStructures
//
//  Created by Terry Lewis II on 6/12/14.
//  Copyright (c) 2014 Blue Plover Productions LLC. All rights reserved.
//

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