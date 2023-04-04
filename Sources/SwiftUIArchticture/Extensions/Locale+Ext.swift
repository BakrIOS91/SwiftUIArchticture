//
//  Locale+Ext.swift
//  
//
//  Created by Bakr mohamed on 03/04/2023.
//

import Foundation
import SwiftUI

public extension Locale {
    static let en_US: Locale = .init(identifier: "en_US")
    static let ar_EG: Locale = .init(identifier: "ar_EG")
    static let appSupported: [Locale] = [.en_US, .ar_EG]
}

extension Locale {
    var nextSupportedLocale: Locale? {
        if var idx = Self.appSupported.firstIndex(of: self) ?? Self.appSupported.firstIndex(where: { self.languageCode == $0.languageCode }) {
            idx += 1
            if idx >= Self.appSupported.count { idx = 0 }
            return Self.appSupported[safe: idx]
        } else {
            return Self.appSupported.first
        }
    }
    
    /// Selects supported locale based on current locale
    static var bestMatching: Locale {
        switch Locale.current.identifier {
        case let id where id.starts(with: "en"): return .en_US
        default: return .ar_EG
        }
    }
}


public extension Locale {
    
    // Arabic "ar"
    // Hebrew "he", "he_IL"
    // Persian/Farsi "fa", "fa_IR"
    // Urdu "ur", "ur_IN", "ur_PK"
    private static let rtlLanguageCodes = ["ar_EG", "he", "he_IL", "fa", "fa_IR", "ur", "ur_IN", "ur_PK"]
    
    var layoutDirection: LayoutDirection {
        Self.rtlLanguageCodes.contains(self.languageCode ?? "") ? .rightToLeft : .leftToRight
    }
}
