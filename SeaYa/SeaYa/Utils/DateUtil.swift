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
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    static func formattedDateToDate(_ date:String)->Date{
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.date(from: date)!
    }
    static func getFormattedTime(_ date: Date) -> String{
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    //년 월 일 , 요일 매칭
    static func dateToWeekDay(_ date: String)->WeekDay{
        let rDate = formattedDateToDate(date)
        let dateNum = Int(rDate.formatted(Date.FormatStyle().weekday(.oneDigit)))!
        return WeekDay(rawValue: dateNum)!
    }
    static func dayPlusTime(_ day : Date, _ time : Date) -> Date{
        let stringDay = getFormattedDate(day)
        let stringTime = getFormattedTime(time)
        let mergedDate = stringDay + " " + stringTime
        return formattedDateToDate(mergedDate)
    }
    static func dayPlusTime(_ day : String, _ time : Date) -> Date{
        let stringDay = day
        let stringTime = getFormattedTime(time)
        let mergedDate = stringDay + " " + stringTime
        return formattedDateToDate(mergedDate)
    }
}

