//
//  Closable.swift
//  ReduceClose
//
//  Created by Wenzhong Zhang on 2019-09-02.
//  Copyright © 2019 Wenzhong Inc. All rights reserved.
//

import Foundation

protocol Closable {
    func canClose(_ char: Character) -> Bool
}
