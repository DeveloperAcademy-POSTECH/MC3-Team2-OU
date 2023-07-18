//
//  TimeTable.swift
//  calendarTest
//
//  Created by musung on 2023/07/16.
//

import SwiftUI

struct TimeTable: View {
    typealias MyCalendar = Dictionary<String,[Event]>
    @ObservedObject var vm = TimeTableViewModel(selectedDay: ["2023-07-17","2023-07-18","2023-07-19"])
    var body: some View {
        if vm.calendar != nil{
            VStack{
                HStack{
                    ForEach(vm.calendar?.keys.sorted() ?? [],id: \.self) { day in
                        VStack{
                            Text(day)
                            TableRow(vm: vm,day: day)
                        }
                    }
                }
                Button("확인") {
                    
                }
            }
        }
        else{
            ProgressView()
        }
    }
}
struct TableRow: View{
    @ObservedObject var vm: TimeTableViewModel
    let day: String
    let items:[TableItem]
    @State var selectedItem: Set<TableItem> = []
    @State var current:TableItem?
    init(vm: TimeTableViewModel, day: String) {
        self.vm = vm
        self.day = day
        self.items = vm.eventToTableItem(vm.calendar![day]!)
    }
    // 선택 드래그 , 비선택 드래그 나눠서 로직 나누기
    var body: some View{
        GeometryReader { geo in
            VStack(spacing: 0){
                ForEach(items,id: \.self){item in
                    ZStack{
                        TableCell(item).frame(width: geo.size.width,height: geo.size.height/CGFloat(items.count))
                            .foregroundColor(item.canSelect() ? selectedItem.contains(item) ? .red : .blue : .gray)
                        Text(item.event.title)
                    }
                }
            }.onAppear(){
                getLocations(rect: geo.frame(in: .global))
                
            }
        }
        .gesture(DragGesture(minimumDistance: 10)
                .onChanged({ value in
                    if let item = getSelectedItem(value.location){
                        if !selectedItem.contains(item) && current != item && item.canSelect(){
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
        let interval:CGFloat = rect.height/CGFloat(items.count)
        var currentHeight:CGFloat = 0
        for i in 0...items.count-1{
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
    func canSelect() -> Bool{
        if event.title == "blank"{
            return true
        }
        else{
            return false;
        }
    }
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
