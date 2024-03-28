//
//  DateExtension.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/27.
//

import Foundation

extension Date {
    
    func convertStringToDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: dateString) else { return "Date Failed" }

        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self)

        let hours = "\(difference.hour ?? 0)h ago"
        let days = "\(difference.day ?? 0)d ago"
        
        if let daysTimeSince = difference.day, let hoursTimeSince = difference.hour {
            if hoursTimeSince < 24 && daysTimeSince == 0 {
                if let hour = difference.hour, hour       > 0 { return hours }
            } else {
                if let day = difference.day, day          > 0 { return days }
            }
        }
        return ""
    }
}
