//
//  Date+.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/17.
//

import Foundation

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        formatter.timeZone = TimeZone.current
        let day = Calendar.current.date(byAdding: .day, value: -1, to: self)!
        return formatter.string(from: day)
    }
    func removeSeconds() -> Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        
        if let year = components.year, let month = components.month, let day = components.day,
           let hour = components.hour, let minute = components.minute {
            let newDateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
            return calendar.date(from: newDateComponents)
        }
        
        return nil
    }
}

extension Int? {
    func dayOfWeek() -> String{
        switch self {
        case 1:
            return "일"
        case 2 :
            return "월"
        case 3 :
            return "화"
        case 4 :
            return "수"
        case 5 :
            return "목"
        case 6 :
            return "금"
        default :
            return "토"
        }
    }
}

extension Int {
    func dayOfWeek() -> String{
        switch self {
        case 1:
            return "일"
        case 2 :
            return "월"
        case 3 :
            return "화"
        case 4 :
            return "수"
        case 5 :
            return "목"
        case 6 :
            return "금"
        default :
            return "토"
        }
    }
}
