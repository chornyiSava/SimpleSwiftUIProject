//
//  Collection+Extension.swift
//  TestTask
//
//  Created by Sava Chornyi on 2023-02-26.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
