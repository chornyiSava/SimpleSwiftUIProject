//
//  Parser.swift
//  TestTask
//
//  Created by Sava Chornyi on 2023-02-26.
//

import Foundation

public protocol ParserProtocol {
    func parse(baseString: String, with keys: [String]) -> [String: String]
}

final class Parser: ParserProtocol {
    
    // MARK: - Public Logic
    func parse(baseString: String, with keys: [String]) -> [String: String] {
        var elementsDisctionary = [String: String]()
        guard baseString.count > 0 else { return elementsDisctionary }
        
        var keysThatExistInString = [String]()
        keys.forEach {
            if baseString.contains($0.appending(":")) { keysThatExistInString.append($0) }
        }
        guard keysThatExistInString.count > 0 else { return elementsDisctionary }
        
        var keysPositionsInString = [Int]()
        keysThatExistInString.forEach {
            if let startIndex = baseString.index(of: $0.appending(":"))?.utf16Offset(in: baseString) {
                keysPositionsInString.append(startIndex)
            }
        }
        guard keysPositionsInString.count > 0 else { return elementsDisctionary }
        
        keysPositionsInString.append(baseString.count - 1)
        keysPositionsInString.sort {
            return $0 < $1
        }
        
        let subStrings = separateStringToSubstrings(from: baseString, with: keysPositionsInString)
        mapSubStringsToDictionary(from: subStrings, with: keysThatExistInString, to: &elementsDisctionary)
        
        return elementsDisctionary
    }
    
    // MARK: - Private logic
    private func separateStringToSubstrings(from baseString: String, with keysPositionsInString: [Int]) -> [String] {
        var subStrings = [String]()
        keysPositionsInString.enumerated().forEach { index, position in
            guard let nextPosition = keysPositionsInString[safe: index + 1] else { return }
            let startIndex = String.Index(utf16Offset: position, in: baseString)
            let endIndex = String.Index(utf16Offset: nextPosition, in: baseString)
            var subString = String(baseString[startIndex ..< endIndex])
            if let lastCharacter = subString.last, lastCharacter == "," { subString.removeLast() }
            subStrings.append(subString)
        }
        return subStrings
    }
    
    private func mapSubStringsToDictionary(from subStrings: [String], with keysThatExistInString: [String], to elementsDisctionary: inout [String: String]) {
        subStrings.forEach { subString in
            keysThatExistInString.forEach { existingKey in
                var stringValue = subString
                guard subString.starts(with: existingKey.appending(":")) else { return }
                stringValue = String(stringValue.dropFirst(existingKey.appending(":").count))
                elementsDisctionary[existingKey] = stringValue
            }
        }
    }
    
}
