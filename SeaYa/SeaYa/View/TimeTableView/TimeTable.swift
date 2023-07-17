//
//  TimeTable.swift
//  calendarTest
//
//  Created by musung on 2023/07/16.
//

import SwiftUI

struct TimeTable: View {
    typealias MyCalendar = Dictionary<String,[Event]>
    static let events = [Event(title: "1", start: Date.now, end: Date.now),Event(title: "2", start: Date.now, end: Date.now),Event(title: "3", start: Date.now, end: Date.now),Event(title: "4", start: Date.now, end: Date.now)]
    let calendar:MyCalendar = ["1":events,"2":events,"3":events,"4":events]
    var body: some View {
        HStack{
            ForEach(calendar.keys.sorted(),id: \.self) { day in
                VStack{
                    Text(day)
                    TableRow()
                }
            }
        }
    }
}
struct TableRow: View{
    var items = [TableItem(Event(title: "1", start: Date.now, end: Date.now)),TableItem(Event(title: "2", start: Date.now, end: Date.now)),TableItem(Event(title: "3", start: Date.now, end: Date.now)),TableItem(Event(title: "4", start: Date.now, end: Date.now))]
    @State var selectedItem: Set<TableItem> = []
    @State var current:TableItem?
    // 선택 드래그 , 비선택 드래그 나눠서 로직 나누기
    var body: some View{
        GeometryReader { geo in
            VStack(spacing: 1){
                ForEach(items,id: \.self){item in
                    TableCell(item).frame(width: geo.size.width,height: geo.size.height*1/4)
                        .foregroundColor(selectedItem.contains(item) ? .red : .blue)
                }
            }.onAppear(){
                getLocations(rect: geo.frame(in: .global))
                
            }
        }.background(Color.blue)
            .gesture(DragGesture(minimumDistance: 10)
                .onChanged({ value in
                    if let item = getSelectedItem(value.location){
                        if !selectedItem.contains(item) && current != item{
                            selectedItem.insert(item)
                        }
                        else if selectedItem.contains(item) && current != item{
                            selectedItem.remove(item)
                        }
                        current = item
                    }
                    }
                )
                    .onEnded({ _ in
                        current = nil
                    })
            )
    }
    //드래그된 위치에 있는 요소 return
    private func getSelectedItem(_ location: CGPoint)->TableItem?{
        for rect in items{
            if let rec = rect.location{
                if rec.contains(location){
                    return rect
                }
            }
        }
        return nil
    }
    //아이템에 위치 값 지정
    private func getLocations(rect:CGRect){
        let interval:CGFloat = rect.height * 1/4
        var currentHeight:CGFloat = 0
        for i in 0...3{
            let start = currentHeight
            let curRect = CGRect(x: 0, y: start, width: rect.width, height: interval)
            items[i].location = curRect
            currentHeight = currentHeight + interval
        }
    }
}
struct TableCell: View{
    let tableItem: TableItem
    init(_ tableItem: TableItem) {
        self.tableItem = tableItem
    }
    var body: some View{
        Rectangle()
    }
}
class TableItem:Hashable{
    var event: Event
    var location: CGRect?
    static func == (lhs: TableItem, rhs: TableItem) -> Bool {
        return lhs.event.start == rhs.event.start && lhs.event.title == rhs.event.title
    }
    
    init(_ event:Event) {
        self.event = event
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(event.start)
        hasher.combine(event.title)
    }
}

//struct TimeTable_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeTable()
//    }
//}
