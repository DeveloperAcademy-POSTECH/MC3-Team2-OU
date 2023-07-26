//
//  CalendarView.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/17.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedButtons: [(week: Int, day: Int)] = []
    @Binding var choseDate: [Date]
    
    private let weekdays: [String] = ["월", "화", "수", "목", "금", "토", "일"]
    private let currentDate = Date()
    private var nextDate: Date {
        return Calendar.current.date(byAdding: .day, value: 14, to: currentDate)!
    }
    
    var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return calendar
    }
    
    private var firstDayOfMonth: Date {
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        return calendar.date(from: components)!
    }
    
    private var currentWeekIndex: Int {
        let weekOfMonth = calendar.component(.weekOfMonth, from: currentDate)
        return weekOfMonth-1
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(weekdays, id: \.self) { (weekday) in
                    Text(weekday)
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                }
            }
            
            VStack {
                ForEach(currentWeekIndex..<currentWeekIndex+3, id: \.self) { week in
                    HStack {
                        ForEach(1...7, id: \.self) { day in
                            let date = dayText(week: week, day: day)
                            let isSelected = isSelected(week: week, day: day)
                            
                            if date > currentDate && date < nextDate{
                                Button(action: {
                                    toggleButtonSelection(week: week, day: day)
                                }, label: {
                                    ZStack {
                                        Circle()
                                            .foregroundColor(isSelected || currentDate == date ? Color.blue : Color.clear
                                            )
                                        
                                        Text(date.toString())
                                            .frame(maxWidth: .infinity)
                                            .padding(8)
                                            .foregroundColor(isSelected ? .white : ( day == 7 ?  .red : .black ))
                                    }
                                })
                            }else {
                                Text(date.toString())
                                    .frame(maxWidth: .infinity)
                                    .padding(8)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func toggleButtonSelection(week: Int, day: Int) {
           let button = (week, day)
           if isSelected(week: week, day: day){
               selectedButtons.removeAll { $0 == button }
               choseDate.removeAll {$0 == dayText(week: week, day: day)}
           } else if selectedButtons.count < 7{
               selectedButtons.append(button)
               choseDate.append(dayText(week: week, day: day))
           }
       }

       func isSelected(week: Int, day: Int) -> Bool {
           return selectedButtons.contains { $0 == (week, day) }
       }
    
    func dayText(week: Int, day: Int) -> Date {
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: firstDayOfMonth)
        dateComponents.day! += ((week * 7) + day - calendar.component(.weekday, from: firstDayOfMonth) + 2)
        return calendar.date(from: dateComponents)!
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(choseDate: .constant([Date]()))
    }
}
