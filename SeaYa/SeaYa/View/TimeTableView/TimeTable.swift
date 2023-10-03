//
//  TimeTable.swift
//  calendarTest
//
//  Created by musung on 2023/07/16.
//

import SwiftUI

struct TimeTable: View {
    typealias MyCalendar = [String: [Event]]
    @EnvironmentObject private var connectionManager: ConnectionService
    @EnvironmentObject private var userData: UserData
    @State var clicked: Int? = 0
    @ObservedObject var vm: TimeTableViewModel
    var body: some View {
        NavigationStack {
            if vm.calendar != nil {
                VStack(spacing: 16) {
                    Text("일정 입력")
                        .body(textColor: .primary)

                    VStack(spacing: 0) {
                        DayLayout(vm: vm)

                        HStack(spacing: 0) {
                            TimeLayout()
                            Table(vm: vm,
                                  connectionManager: connectionManager)
                        }
                    }

                    // MARK: 페이지 넘기기

                    if vm.available ?? false {
                        NavigationLink(destination: CheckTimeDoneView()
                            .onAppear {
                                vm.buttonClicked(userData: userData, connectionManager: connectionManager)
                            }
                            .navigationBarBackButtonHidden(true), label: {
                                Text("입력 완료")
                                    .bigButton(textColor: Color.white)
                                    .frame(width: 358, alignment: .center)
                                    .padding(.vertical, 18)
                                    .background(Color.primaryColor)
                                    .cornerRadius(16)
                            })
                    } else {
                        Text(timeTalbeAlert(connectionManager.groupInfo?.estimatedTime))
                            .bigButton(textColor: .whiteColor)
                            .frame(width: 358, alignment: .center)
                            .padding(.vertical, 18)
                            .background(Color.primary_selectedColor)
                            .cornerRadius(16)
                    }
                }
                .padding(16)
            } else {
                ProgressView()
            }
        }
    }

    private func timeTalbeAlert(_ estimatedTime: Int?) -> String {
        let estimatedTime: Int = estimatedTime ?? 1
        return "각 시간이" +
            (estimatedTime != 1 ? " \(Int(estimatedTime / 2))시간" : "") +
            (estimatedTime % 2 == 1 ? " 30분" : "") +
            " 이상 묶여있어야 합니다"
    }
}

// 최상단 날짜 나열하는 UI
struct DayLayout: View {
    let vm: TimeTableViewModel
    var body: some View {
        HStack(spacing: 0) {
            DayCell(title: "")
                .frame(width: 44)

            ForEach(vm.selectedDay.sorted(), id: \.self) { day in
                DayCell(title: day)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 40)
    }
}

struct DayCell: View {
    let title: String

    var body: some View {
        ZStack {
            Rectangle()
                .stroke(Color.clear, lineWidth: 1)
                .foregroundColor(.clear)

            VStack {
                Text(title == "" ? "" : DateUtil.dateToWeekDay(title).rawValue.dayOfWeek()).caption(textColor: Color.primaryColor)
                Text(title.components(separatedBy: "-").last!).caption(textColor: Color.primaryColor)
            }
        }
    }
}

// 최좌측 시간을 나열하는 UI
struct TimeLayout: View {
    let time = ["9시", "10시", "11시", "12시", "13시", "14시", "15시", "16시", "17시", "18시", "19시", "20시", "21시", "22시", "23시"]
    var body: some View {
        VStack(spacing: 0) {
            ForEach(time, id: \.self) { t in
                ZStack {
                    TimeCell(title: t)
                }.frame(width: 44)
            }
        }
        .frame(maxHeight: .infinity)
    }
}

struct TimeCell: View {
    let title: String
    var body: some View {
        ZStack {
            Rectangle().stroke(Color.clear, lineWidth: 1)
            Text(title)
                .caption(textColor: Color.primaryColor)
        }
    }
}

struct Table: View {
    let vm: TimeTableViewModel
    let connectionManager: ConnectionService
    @State var startPoint: CGPoint?
    @State var endPoint: CGPoint?

    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                ForEach(Array(vm.calendar!.keys.sorted().enumerated()), id: \.offset) { xindex, day in
                    TableRow(
                        vm: vm,
                        day: day,
                        items: vm.tableCalendar[day]!,
                        index: vm.selectedDay.firstIndex(of: day)!,
                        xindex: xindex
                    )
                }
            }

            RectangleView(startPoint: startPoint, endPoint: endPoint,
                          xArray: vm.xArray,
                          yArray: vm.yArray,
                          width: vm.cellSize?.width,
                          height: vm.cellSize?.height,
                          isSelected: vm.isFirstSelectd)

            HStack(spacing: 0) {
                ForEach(Array(vm.calendar!.keys.sorted().enumerated()), id: \.offset) { _, day in
                    TableRow2(
                        vm: vm,
                        day: day,
                        items: vm.tableCalendar[day]!
                    )
                }
            }
        }
        .gesture( // 드래그 동작
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if vm.isFirstSelectd == nil {
                        vm.xStartIndex = vm.xArray.lastIndex(where: { $0 < value.startLocation.x }) ?? 0
                        vm.yStartIndex = vm.yArray.lastIndex(where: { $0 < value.startLocation.y }) ?? 0
                        if let xStartIndex = vm.xStartIndex,
                           let yStartIndex = vm.yStartIndex
                        {
                            let t = vm.indexDay
                            if vm.tableCalendar[t[xStartIndex] ?? ""]![yStartIndex].isSelected == true {
                                vm.isFirstSelectd = true
                            } else {
                                vm.isFirstSelectd = false
                            }
                        }
                    }
                    startPoint = value.startLocation
                    endPoint = value.location
                }
                .onEnded { value in
                    vm.xEndIndex = vm.xArray.lastIndex(where: { $0 < value.location.x }) ?? 0
                    vm.yEndIndex = vm.yArray.lastIndex(where: { $0 < value.location.y }) ?? 0
                    if let xStartIndex = vm.xStartIndex,
                       let xEndIndex = vm.xEndIndex,
                       let yStartIndex = vm.yStartIndex,
                       let yEndIndex = vm.yEndIndex
                    {
                        let t = vm.indexDay
                        for i in Array(stride(from: min(xStartIndex, xEndIndex),
                                              to: max(xStartIndex, xEndIndex) + 1,
                                              by: 1))
                        {
                            for j in Array(stride(from: min(yStartIndex, yEndIndex),
                                                  to: max(yStartIndex, yEndIndex) + 1,
                                                  by: 1))
                            {
                                if vm.isFirstSelectd ?? false {
                                    vm.tableCalendar[t[i] ?? ""]![j].isSelected = false
                                    vm.selectedItem.remove(vm.tableCalendar[t[i] ?? ""]![j])
                                } else {
                                    if vm.tableCalendar[t[i] ?? ""]![j].canSelect() {
                                        vm.tableCalendar[t[i] ?? ""]![j].isSelected = true
                                        vm.selectedItem.insert(vm.tableCalendar[t[i] ?? ""]![j])
                                    }
                                }
                            }
                        }

                        // 해당 선택 원소 그룹이 주어진 시간보다 긴지 확인해야함
                        if let estimatedTime = connectionManager.groupInfo?.estimatedTime {
                            vm.available = true
                            let sortedSelecteItem = vm.selectedItem.sorted(by: {
                                $0.dayTime ?? 0 < $1.dayTime ?? 0
                            })
                            var groupLengths: [Int] = []
                            var currentGroupLength = 0

                            for i in 0 ..< sortedSelecteItem.count {
                                if i == 0 || sortedSelecteItem[i].dayTime! != sortedSelecteItem[i - 1].dayTime! + 1 {
                                    if currentGroupLength > 0 {
                                        groupLengths.append(currentGroupLength)
                                    }
                                    currentGroupLength = 1
                                } else {
                                    currentGroupLength += 1
                                }
                            }

                            if currentGroupLength > 0 {
                                groupLengths.append(currentGroupLength)
                            }
                            if estimatedTime > groupLengths.min() ?? 0 {
                                vm.available = false
                            }
                        } else {
                            vm.available = vm.selectedItem.isEmpty ? false : true
                        }
                    }
                    vm.xEndIndex = nil
                    vm.yEndIndex = nil
                    vm.xStartIndex = nil
                    vm.yStartIndex = nil
                    vm.isFirstSelectd = nil
                    startPoint = nil
                    endPoint = nil
                }
        )
    }
}

struct TableRow: View {
    @ObservedObject var vm: TimeTableViewModel
    let day: String
    var items: [TableItem]
    var index: Int
    var xindex: Int?

    // 선택 드래그 , 비선택 드래그 나눠서 로직 나누기
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { yindex, item in
                Rectangle()
                    .stroke(Color.primaryColor, lineWidth: 0.5)
                    .foregroundColor(.clear)
                    .background(
                        GeometryReader { geo in //이쪽이 등록인데, 등록이 제대로 이루어지지 않고 있음
                            (item.isSelected ? Color.primary_selectedColor : Color.clear)
                                .onAppear {
                                    if day == vm.tableCalendar.keys.first! {
                                        vm.yArray.append(geo.frame(in: .global).origin.y)
                                        if yindex == 0 {
                                            vm.cellSize = geo.frame(in: .local)
                                        }
                                    }
                                    if yindex == 0 {
                                        vm.xArray.append(geo.frame(in: .global).origin.x)
                                        vm.indexDay[xindex ?? 0] = day
                                    }

                                    if vm.yArray.count == vm.tableCalendar[day]!.count,
                                       vm.xArray.count == vm.tableCalendar.count
                                    {
                                        vm.xArray.sort()
                                        vm.yArray.sort()

                                        vm.xArray = vm.xArray.map { $0 - (vm.xArray.min() ?? 0) }
                                        vm.yArray = vm.yArray.map { $0 - (vm.yArray.min() ?? 0) }
                                    }
                                    vm.tableCalendar[day]![yindex].dayTime = (Int(day.replacingOccurrences(of: "-", with: "")) ?? 0) * 100 + yindex
                                }
                        }
                    )
            }
        }
    }
}

struct TableRow2: View {
    @ObservedObject var vm: TimeTableViewModel
    let day: String
    var items: [TableItem]

    // 선택 드래그 , 비선택 드래그 나눠서 로직 나누기
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                    ZStack {
                        Rectangle()
                            .stroke(Color.primaryColor, lineWidth: 0.5)
                            .foregroundColor(.clear)
                            .background(item.canSelect() ? Color.clear : Color.unactiveColor)
                    }
                }
            }
            VStack(spacing: 0) {
                ForEach(0 ..< 15) { _ in
                    Rectangle()
                        .stroke(Color.primaryColor, lineWidth: 1)
                }
            }
        }
    }
}

struct TableCell: View {
    let tableItem: TableItem
    var body: some View {
        Rectangle()
            .stroke(Color.primaryColor, lineWidth: 0.5)
            .foregroundColor(.clear)
    }
}

class TableItem: Hashable, Equatable {
    var event: Event
    var location: CGRect? // UI 위치를 의미하는듯 하다.
    var dayTime: Int? // 2023081302 ->
    var isSelected: Bool = false

    func canSelect() -> Bool {
        if event.title == "blank" {
            return true
        } else {
            return false
        }
    }

    static func == (lhs: TableItem, rhs: TableItem) -> Bool {
        return lhs.event.start == rhs.event.start && lhs.event.title == rhs.event.title
    }

    init(_ event: Event) {
        self.event = event
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(event.start)
        hasher.combine(event.title)
    }
}

struct TimeTableTest: View {
    var connectionManager = ConnectionService()
    var body: some View {
        TimeTable(
            vm: TimeTableViewModel.preview
        )
        .environmentObject(ConnectionService())
        .environmentObject(UserData())
    }
}

#Preview("Light Mode"){
    TimeTableTest()
}

#Preview("Dark Mode"){
    TimeTableTest()
        .preferredColorScheme(.dark)
}
