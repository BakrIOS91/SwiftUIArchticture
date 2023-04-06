//
//  File.swift
//  
//
//  Created by Bakr mohamed on 04/04/2023.
//

import SwiftUI

public extension String {
    
    var localizedStringKey: LocalizedStringKey {
        .init(self)
    }
    
    func displayToStringFromDate(
        formateFrom: DateFormatter.Formats,
        formateTo:DateFormatter.Formats,
        locale: Locale = .en
    ) -> String {
        if let dateFromString = DateFormatter().date(fromString: self, withFormat: formateFrom, locale: locale)?.startOfHour() {
            return DateFormatter().displayString(fromDate: dateFromString, withFormate: formateTo, locale: locale).UTCToLocal(fromFormat: formateTo, toFormat: formateTo, locale: locale)
        }
        return "N/A"
    }
    
    func sendToStringFromDate(
        formateFrom: DateFormatter.Formats,
        formateTo:DateFormatter.Formats
    ) -> String {
        if let dateFromString = DateFormatter().date(fromString: self, withFormat: formateFrom)?.startOfHour() {
            return DateFormatter().sendString(fromDate: dateFromString, withFormate: formateTo).localToUTC(fromFormat: formateTo, toFormat: formateTo)
        }
        return "N/A"
    }
    
    //MARK:- Convert UTC To Local Date by passing date formats value
    func UTCToLocal(fromFormat: DateFormatter.Formats = .hmma, toFormat: DateFormatter.Formats = .hmma,locale: Locale = .en) -> String {
        
        let dateFormatter: DateFormatter = .gregorian(
            dateFormat: fromFormat.rawValue,
            locale: locale
        )
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = toFormat.rawValue
        
        return dateFormatter.string(from: dt ?? Date())
    }
    
    //MARK:- Convert Local To UTC Date by passing date formats value
      func localToUTC(fromFormat: DateFormatter.Formats = .hmma, toFormat: DateFormatter.Formats = .hmma) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat.rawValue
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current

        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = toFormat.rawValue

        return dateFormatter.string(from: dt ?? Date())
      }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    var toURL: URL? {
        return URL(string: self)
    }
    
    func replaceEmpty() -> String {
        if self.isEmpty {
            return "N/A"
        }
        
        return self
    }
}
