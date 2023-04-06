//
//  DateFormater+Ext.swift
//  
//
//  Created by Bakr mohamed on 03/04/2023.
//

import Foundation
public extension DateFormatter {
    static let preferedTimeZoneIdentifier = "Africa/Cairo"

    enum Formats: String {
        case yyyyMMddTHHmmssZ = "yyyy-MM-dd'T'HH:mm:ssZ"
        case yyyyMMddTHHmmssSSS = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        case yyyyMMddTHHmmssSSSZ = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case yyyyMMddTHHmmss = "yyyy-MM-dd'T'HH:mm:ss"
        case yyyyMMddhhmma = "yyyy-MM-dd hh:mm a"
        case yyyyMMddhhmmss = "yyyy-MM-dd HH:mm:ss"
        case yyyyMMddhhmmsszz = "yyyy-MM-dd HH:mm:ss Z"
        case yyyyMMdd = "yyyy-MM-dd"
        case ddMMyyyy = "dd-MM-yyyy"
        case dMMM = "d MMM"
        case MMMM = "MMMM"
        case MMM = "MMM"
        case HHmmss = "HH:mm:ss"
        case HHmm = "HH:mm"
        case hhmma = "hh:mm a"
        case ddMMMyyyy = "dd MMM. yyyy"
        case ddMMMyyyy1 = "dd MMM yyyy"
        case ddmmyyyy = "dd/MM/yyyy"
        case MMDDYY = "MM-dd-yyyy"
        case EEEEdMMMyyyy = "EEEE d MMM yyyy"
        case ddmmyyyyHHmmss = "dd/MM/yyyy HH:mm:ss"
        case dMMMyyyy = "d MMM yyyy"
        case dMMMyyy2 = "d MMM, yyyy"
        case MMMdyyy = "MMM d, yyyy"
        case MMddyyyy = "MM/dd/yyyy"
        case dMMMMyyy = "d MMMM yyyy"
        case yyyyd = "yyyy-d"
        case hmma = "h:mm a"
        case ddMMMyyyHHSS = "d MMM yyyy 'at' hh:mm a"
        case mmmmd = "MMMM d"
        case MMMMMYYYY = "MMMM YYYY"
        case ddMMMM = "dd MMMM"
    }
    
    static func gregorian(
        dateFormat: String,
        locale: Locale
    ) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = dateFormat
        formatter.calendar = .init(identifier: .gregorian)
        if TimeZone.knownTimeZoneIdentifiers.contains(preferedTimeZoneIdentifier) {
            formatter.timeZone = .init(identifier: preferedTimeZoneIdentifier)
        }
        return formatter
    }

    func displayString(fromDate date: Date, withFormate format: Formats, locale: Locale = .en) -> String {
        let formatter: DateFormatter = .gregorian(
            dateFormat: format.rawValue,
            locale: locale
        )
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    func sendString(fromDate date: Date, withFormate format: Formats) -> String {
        self.dateFormat = format.rawValue
        self.locale = .init(identifier: "en")
        let dateString = string(from: date)
        return dateString
    }


    func date(fromString string: String, withFormat format: Formats, locale: Locale = .en) -> Date? {
        let formatter: DateFormatter = .gregorian(
            dateFormat: format.rawValue,
            locale: locale
        )
        return formatter.date(from: string)
    }
}

