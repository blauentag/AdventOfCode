//
//  main.swift
//  AdventOfCode
//
//  Created by blauentag on 12/2/21.
//

import Foundation

let path = "\(NSHomeDirectory())/Projects/AdventOfCode2021/day_2/vectors.txt"

do {
    var horizontalPosition : Int = 0
    var depth : Int = 0
    // Get the contents
    let contents = try String(contentsOfFile: path, encoding: .utf8)
    let lines = contents.components(separatedBy: .newlines)
    let vectors = lines.map { $0.components(separatedBy: " ") }
    for vector in vectors {
        let direction = vector[0]
        let distance = Int(vector[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0

        switch direction {
        case "forward":
            horizontalPosition += distance
        case "down":
            depth += distance
        case "up":
            depth -= distance
        default:
            throw NSError(domain: "No Case", code: 1, userInfo: ["direction": direction, "distance": distance])
        }
    }
    print("part 1 answer: \(horizontalPosition * depth)")
    
}
catch let error as NSError {
    print("Ooops! Something went wrong: \(error)")
}


do {
    var horizontalPosition : Int = 0
    var depth : Int = 0
    var aim : Int = 0
    // Get the contents
    let contents = try String(contentsOfFile: path, encoding: .utf8)
    let lines = contents.components(separatedBy: .newlines)
    let vectors = lines.map { $0.components(separatedBy: " ") }
    for vector in vectors {
        let direction = vector[0]
        let distance = Int(vector[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0

        switch direction {
        case "forward":
            horizontalPosition += distance
            depth += (distance * aim)
        case "down":
            aim += distance
        case "up":
            aim -= distance
        default:
            throw NSError(domain: "No Case", code: 1, userInfo: ["direction": direction, "distance": distance])
        }
    }
    print("part 2 answer: \(horizontalPosition * depth)")
    
}
catch let error as NSError {
    print("Ooops! Something went wrong: \(error)")
}
