//
//  Matrix.swift
//  
//
//  Created by Yann Christophe MAERTENS on 20/02/2023.
//

import Foundation

/// The matrix row and column
public struct Matrix {
    public init(row: Int,
                column: Int) {
        self.row = row
        self.column = column
    }

    public var row: Int
    public var column: Int

    public var total: Int { row * column }
}
