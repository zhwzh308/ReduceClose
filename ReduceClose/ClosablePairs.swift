//
//  ClosablePairs.swift
//  ReduceClose
//
//  Created by Wenzhong Zhang on 2019-09-02.
//  Copyright © 2019 Wenzhong Inc. All rights reserved.
//

import Foundation

enum ClosablePairs: Character, Closable {
    case parenthesis = "(", curly = "{", bracket = "[", less = "<"
    func canClose(_ char: Character) -> Bool {
        switch self {
        case .parenthesis:
            return char == ")"
        case .curly:
            return char == "}"
        case .bracket:
            return char == "]"
        case .less:
            return char == ">"
        }
    }
}
