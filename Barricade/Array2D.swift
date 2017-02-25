//
//  Array2D.swift
//  game_beaver_damm
//
//  Created by Minh Nguyen on 12/01/2017.
//  Copyright © 2017 Minh Nguyen. All rights reserved.
//

import Foundation

struct Array2D<T> {
    let cols: Int
    let rows: Int
    fileprivate var array: Array<T?>
    
    init(cols: Int, rows: Int) {
        self.cols = cols
        self.rows = rows
        array = Array<T?>(repeating: nil, count: rows * cols)
    }
    
    subscript(col: Int, row: Int) -> T? {
        /* Get value at (col, row) */
        get {
            return array[row * self.cols + col]
        }
        /* Set value at (col, row) */
        set {
            array[row * self.cols + col] = newValue
        }
    }
}
