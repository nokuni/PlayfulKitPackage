//
//  Matrix.swift
//  
//
//  Created by Yann Christophe MAERTENS on 20/02/2023.
//

import Foundation

public struct Matrix {
    public init(row: Int,
                column: Int) {
        self.row = row
        self.column = column
    }

    public var row: Int
    public var column: Int

    var product: Int { row * column }
}
