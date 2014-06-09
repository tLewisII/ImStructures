ImStructures
======
Immutable data structures for Swift


Implemented
------
ImArray: An immutable version of the normal Swift Array.
Use it just like you use Array.

```
let imArray:ImArray<Int> = ImArray(items:1,2,4,5,6)

let newArray = imArray += 7 //returns a new ImArray
let again = imArray.join([6,7,8]) // again returns a new ImArray
let sorted = imArray.sort(>) // a new ImArray yet again
let reduced = imArray.reduce(0, f:+) // 21
```

ImArray also comes with fun extensions.

```
let imArray:ImArray<Int> = ImArray(items:1,2,4,5,6)
imArray.scanl(0, f:+) /// like reduce, be give intermediate results [0, 1, 3, 6, 10, 15, 21]
imArray.splitAt(3) /// ([1,2,3], [4,5,6])
imArray.intersperse(9) // [1,9,2,9,3,9,4,9,5,9,6]
```
