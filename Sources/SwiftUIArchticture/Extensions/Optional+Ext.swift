//
//  Optional+Ext.swift
//  
//
//  Created by Bakr mohamed on 03/04/2023.
//

import Foundation
public protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    public var isNil: Bool { self == nil }
}

public extension Optional where Wrapped: Collection {
    var isEmptyOrNil: Bool { self?.isEmpty ?? true }
}
