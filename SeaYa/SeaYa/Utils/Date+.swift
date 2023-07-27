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
        let day = Calendar.current.date(byAdding: .day, value: -1, to: self)!
        return formatter.string(from: day)
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
