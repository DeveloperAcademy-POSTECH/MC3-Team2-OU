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
        return formatter.string(from: self)
    }
    
    /// 현재 디바이스의 TimeZone에 맞춰 주어진 Date 날짜의 오전 0시 0분 값을 리턴합니다.
    func toDate() -> Date {
        let day = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: day)!
    }
    
    /// 현재 디바이스의 TimeZone에 맞춰 주어진 날짜를 targetDate의 년도, 월, 일 로 대체합니다.
    mutating func updateDay(_ targetDate : Date) -> Void {
        let fromDay = Calendar.current.dateComponents([.hour, .minute], from: self)
        var toDay = Calendar.current.dateComponents([.year, .month, .day], from : targetDate)
        
        toDay.hour = fromDay.hour
        toDay.minute = fromDay.minute
        
        self = Calendar.current.date(from: toDay)!
    }
    
    func toStringDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 dd일 EEEE"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
    
    func toStringDateHourMinute() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 dd일 EEEE hh시 mm분"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
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
