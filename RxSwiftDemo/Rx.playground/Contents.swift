//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

class CountDownGenerator: GeneratorType {
    typealias Element = Int
    var element : Element = 0
    
    init<T>(array: [T]) {
        self.element = array.count
    }
    
    func next() -> Element? {
        element = element < 0 ? 0 : element - 1
        return self.element
    }
}

let xs = ["A", "B", "C"]
let generator = CountDownGenerator(array: xs)
while let i = generator.next() where i >= 0 {
    print("\(i) of the array is \(xs[i])")
    
}

struct ReverseSequence<T>: SequenceType {
    var array: [T]
    init(array: [T]) {
        self.array = array
    }
    
    typealias Generator = CountDownGenerator
    
    func generate() -> Generator {
        return CountDownGenerator(array: array)
    }
}

let reverseSequence = ReverseSequence(array: xs)
let reverseGenerator = reverseSequence.generate()
while let i = reverseGenerator.next() where i >= 0 {
    print("\(i) of the array is \(xs[i])")
    
}


