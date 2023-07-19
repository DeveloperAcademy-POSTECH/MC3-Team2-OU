//
//  DateUtil.swift
//  calendarTest
//
//  Created by musung on 2023/07/13.
//

import Foundation
// dateformatt해주는 class
class DateUtil{
    private static let dateFormatter = DateFormatter()
    //년 월 일
    static func getFormattedDate(_ date:Date)->String{
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.string(from: date)
    }
    static func formattedDateToDate(_ date:String)->Date{
        return dateFormatter.date(from: date)!
    }
    //년 월 일 , 요일 매칭
    static func dateToWeekDay(_ date: String)->WeekDay{
        let rDate = formattedDateToDate(date)
        let dateNum = Int(rDate.formatted(Date.FormatStyle().weekday(.oneDigit)))!
        return WeekDay(rawValue: dateNum)!
    }
    
    static func formattedDateToDate(_ year:Int?, _ month:Int?, _ day:Int?, _ hour:Int?, _ minute: Int?) -> Date{
        return Calendar.current.date(from: DateComponents(year:year, month:month, day:day, hour: hour, minute: minute))!
    }
    
    //당일 0시 00분
    static func formattedDateToDate(_ year:Int?, _ month:Int?, _ day:Int?) -> Date{
        return Calendar.current.date(from: DateComponents(year:year, month:month, day:day, hour: 0, minute: 0))!
    }
}
