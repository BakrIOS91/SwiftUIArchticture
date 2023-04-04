//
//  Collection+Ext.swift
//  
//
//  Created by Bakr mohamed on 04/04/2023.
//

import Foundation

public extension Collection {
    subscript (
        safe index: Index
    ) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
