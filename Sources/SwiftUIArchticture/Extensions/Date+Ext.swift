//
//  Date+Ext.swift
//  
//
//  Created by Bakr mohamed on 03/04/2023.
//

import Foundation

public extension Date {

    func startOfHour() -> Date?{
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        return calendar.date(from: components)
    }

}
