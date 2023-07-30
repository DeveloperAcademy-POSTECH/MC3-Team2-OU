//
//  TimeTable.swift
//  calendarTest
//
//  Created by musung on 2023/07/16.
//

import SwiftUI

struct TimeTable: View {
    typealias MyCalendar = Dictionary<String,[Event]>
    @ObservedObject var vm = TimeTableViewModel(selectedDay: ["2023-07-17","2023-07-18","2023-07-19","2023-07-20","2023-07-21","2023-07-22","2023-07-23"])
    var body: some View {
        if vm.calendar != nil{
            VStack{
                VStack(spacing:0){
                    DayLayout(vm: vm)
                    HStack(spacing:0){
                        TimeLayout()
                        Table(vm: vm)
                    }
                }.padding(16)
                BigButton_Blue(title: "확인") {
                    vm.buttonClicked()
                }
            }
        }
        else{
            ProgressView()
        }
    }
}
struct DayLayout: View{
    let vm: TimeTableViewModel
    var body: some View{
        HStack(spacing:0){
            DayCell(title: "").frame(width:44)
            ForEach(vm.selectedDay.sorted(),id:\.self) { day in
                DayCell(title: day)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 40)
    }
}
struct TimeLayout: View{
    let time = ["9시","10시","11시","12시","13시","14시","15시","16시","17시","18시","19시","20시","21시","22시","23시"]
    var body: some View{
        VStack(spacing:0){
            ForEach(time,id:\.self) { t in
                ZStack{
                    TimeCell(title: t)
                }.frame(width:44)
            }
        }
        .frame(maxHeight:.infinity)
    }
}
struct Table: View{
    let vm: TimeTableViewModel
    var body: some View{
        HStack(spacing:0){
            ForEach(vm.calendar!.keys.sorted(),id: \.self) { day in
                TableRow(vm: vm,day: day)
            }
        }
        .gesture(DragGesture(minimumDistance: 0)
            .onChanged({ value in
                if let item = getSelectedItem(value.location){
                    if !vm.selectedItem.contains(item) && vm.current != item && item.canSelect(){
                        vm.selectedItem.insert(item)
                    }
                    else if vm.selectedItem.contains(item) && vm.current != item{
                        vm.selectedItem.remove(item)
                    }
                    vm.current = item
                }
            })
            .onEnded({ _ in
                vm.current = nil
            })
        )
    }
    private func getSelectedItem(_ location: CGPoint)->TableItem?{
        for day in vm.tableCalendar.keys{
            for rect in vm.tableCalendar[day]!{
                if let rec = rect.location{
                    if rec.contains(location){
                        return rect
                    }
                }
            }
        }
        return nil
    }
}
struct TableRow: View{
    @ObservedObject var vm: TimeTableViewModel
    let day: String
    var items: [TableItem]
    var index: Int
    init(vm: TimeTableViewModel, day: String) {
        self.vm = vm
        self.day = day
        self.items = vm.tableCalendar[day]!
        self.index = vm.selectedDay.firstIndex(of: day)!
    }
    // 선택 드래그 , 비선택 드래그 나눠서 로직 나누기
    var body: some View{
        GeometryReader { geo in
            ZStack(){
                VStack(spacing: 0){
                    ForEach(items,id: \.self){item in
                        TableCell(item)
                            .background(
                                item.canSelect() ?
                                    vm.selectedItem.contains(item) ?
                                        Color.primary_selectedColor:
                                        Color(.clear):
                                        Color.unactiveColor
                            )
                    }
                }
                VStack(spacing:0){
                    ForEach(0..<15){_ in
                        Rectangle()
                            .stroke(Color.primaryColor, lineWidth: 1)
                            .background(Color.clear)
                    }
                }
                
            }.onAppear(){
                getLocations(rect: geo.frame(in: .global),index: index)
                
            }
        }
    }
    //아이템에 위치 값 지정
    private func getLocations(rect:CGRect, index:Int){
        let height:CGFloat = rect.height/30
        let width:CGFloat = (rect.width) * CGFloat(index)
        var currentHeight:CGFloat = 0
        for i in 0...items.count-1{
            let start = currentHeight
            let curRect = CGRect(x: width, y: start, width: rect.width, height: height)
            items[i].location = curRect
            currentHeight = currentHeight + height
        }
    }
}
struct TimeCell: View{
    let title: String
    var body: some View{
        ZStack{
            Rectangle().stroke(Color.primaryColor, lineWidth: 1)
            Text(title).caption(textColor: Color.primaryColor)
        }
    }
}
struct DayCell: View{
    let title: String
    var body: some View{
        ZStack{
            Rectangle().stroke(Color.primaryColor, lineWidth: 1).foregroundColor(.clear)
            VStack{
                Text(title == "" ? "" : DateUtil.dateToWeekDay(title).rawValue.dayOfWeek()).caption(textColor: Color.primaryColor)
                Text(title.components(separatedBy: "-").last!).caption(textColor: Color.primaryColor)
            }
        }
    }
}
struct TableCell: View{
    let tableItem: TableItem
    init(_ tableItem: TableItem) {
        self.tableItem = tableItem
    }
    var body: some View{
        ZStack{
            Rectangle()
                .stroke(Color.primaryColor, lineWidth: 0.5).foregroundColor(.clear)
        }
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
