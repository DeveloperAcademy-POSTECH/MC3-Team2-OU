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
