//
//  SettingView.swift
//  SeaYa
//
//  Created by xnoag on 2023/07/17.
//

import SwiftUI
import UIKit

struct SettingView: View {
    @State private var selectedWeekdays: Array<WeekDay> = [.monday]
    private let weekdays: [WeekDay] = [.monday, .tuesday,.wednesday,.thursday,.friday,.saturday,.sunday]
    private let categories: [String] = ["취침", "직장", "학교", "공부", "기타"]
    @ObservedObject var fixedTimeViewModel : FixedTimeViewModel
    @Binding var showSettingViewModal : Bool
    @Binding var selectedIndex : Int
    
    @State var tempFixedTimeModel : FixedTimeModel
    @State var scrollDisabled = false
    @State var Haptics = Date()
    let id: String?
    
    var isUpdate : Bool
    var onDelete : (UUID) -> Void
    
    var body: some View {
            ScrollView{
                HStack{
                    Button("취소"){
                        showSettingViewModal = false
                            
                    }
                    Spacer()
                    Button("완료"){
                        if fixedTimeViewModel.isExist(id ?? ""){
                            print("isExist")
                            fixedTimeViewModel.updateItem(item: tempFixedTimeModel)
                        }
                        else{
                            print("notExist")
                            fixedTimeViewModel.addItem(item: tempFixedTimeModel)
                        }
//                        if selectedIndex < 0 {
//                            fixedTimeViewModel.fixedTimeModels.append(tempFixedTimeModel)
//                        } else {
//                            fixedTimeViewModel.fixedTimeModels[selectedIndex] = tempFixedTimeModel
//                        }
                        showSettingViewModal = false
                    }
                }
                .padding(EdgeInsets(top: 17, leading: 17, bottom: 10, trailing: 16))
                
                Text("시간 지정 편집")
                    .font(.system(size:32, weight: .semibold))
                    .padding(.bottom, 20)
                Section(
                    content: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.whiteColor)
                            HStack {
                                ForEach(categories, id: \.self) { category in
                                    Button(
                                        action:{
                                            tempFixedTimeModel.category = category
                                        },
                                        label:{
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 16)
                                                    .foregroundColor(tempFixedTimeModel.category == category ? Color.primaryColor : Color(hex: "F3F3F3"))
                                                
                                                Text(category)
                                                    .frame(maxWidth: .infinity)
                                                    .font(.headline)
                                                    .foregroundColor(
                                                        tempFixedTimeModel.category == category ? .white : Color(hex: "A2A2A5"))
                                            }.frame(width: 46, height: 32)
                                        }
                                    )
                                }
                                Spacer()
                            }.padding(.leading, 21)
                        }
                        .frame(width : 357, height: 67)
                    },
                    header: {
                        HStack{
                            Text("카테고리").title(textColor: .black)
                            Spacer()
                        }.padding(.leading, 21)
                    }
                )
                
                // Section2 - 반복 요일 선택, 복수 선택 가능.
                Section(
                    content : {
                        ZStack{
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                            HStack {
                                ForEach(weekdays, id: \.self) { weekday in
                                    Button(
                                        action:{
                                            if tempFixedTimeModel.weekdays.contains(weekday){
                                                if tempFixedTimeModel.weekdays.count != 1{
                                                    tempFixedTimeModel.weekdays.removeAll{$0 == weekday}
                                                }
                                            } else {
                                                tempFixedTimeModel.weekdays.append(weekday)
                                                tempFixedTimeModel.weekdays.sort{$0.rawValue < $1.rawValue}
                                            }
                                        },
                                        label: {
                                            ZStack {
                                                Circle()
                                                    .foregroundColor(tempFixedTimeModel.weekdays.contains(weekday) ? Color.primaryColor : Color.clear)
                                                Text(weekday.rawValue.dayOfWeek())
                                                    .frame(maxWidth: .infinity)
                                                    .font(.headline)
                                                    .foregroundColor(tempFixedTimeModel.weekdays.contains(weekday) ? .white : .black)
                                            }.frame(width: 32, height: 32)
                                        }
                                    )
                                }
                                Spacer()
                            }.padding(.leading, 21)
                        }
                        .frame(width : 357, height: 78)
                    },
                    header: {
                        HStack{
                            Text("활성화된 요일").title(textColor: .primary)
                            Spacer()
                        }.padding(.leading, 21)
                    }
                )
                // Section3 - 시작/종료시간 설정.
                Section(
                    header: HStack{
                        Text("시간 설정").title(textColor: .primary)
                        Spacer()
                    }.padding(.leading, 21))   {
                        VStack {
                            HStack(spacing: 25) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Label {
                                        Text("Start")
                                            .foregroundColor(.black)
                                    } icon: {
                                        Image(systemName: "circle")
                                            .foregroundColor(Color.primaryColor)
                                    }
                                    .font(.callout)
                                    Text(
                                        DateUtil.getFormattedTime(tempFixedTimeModel.start))
                                    .font(.title2.bold())
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                VStack(alignment: .leading, spacing: 8) {
                                    Label {
                                        Text("Finish")
                                            .foregroundColor(.black)
                                    } icon: {
                                        Image(systemName: "circle.fill")
                                            .foregroundColor(Color.primaryColor)
                                    }
                                    .font(.callout)
                                    Text( DateUtil.getFormattedTime(tempFixedTimeModel.end))
                                        .font(.title2.bold())
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .padding()
                            .padding(.bottom, 25)
                            SleepTimeSlider()
                                .padding(.bottom, 30)
                        }
                    }
                
                if isUpdate{
                    Button(
                        action: {
                            onDelete(tempFixedTimeModel.id)
                            showSettingViewModal.toggle()
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white)
                                Text("삭제").body(textColor: .red)
                            }
                            .frame(width: 357, height : 48)
                        }
                    )
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                }
            }
        
            .frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.backgroundColor)
            .scrollDisabled(scrollDisabled)
    }

    @ViewBuilder
    func SleepTimeSlider() -> some View {
        GeometryReader { proxy in
            
            let width = proxy.size.width
            
            ZStack {
                ZStack {
                    ForEach(1...120, id: \.self) { index in
                        Rectangle()
                            .fill(index % 10 == 0 ? .black : .gray)
                            .frame(width: 2, height: index % 5 == 0 ? 10 : 5)
                            .offset(y: (width - 60) / 2)
                            .rotationEffect(.init(degrees: Double(index) * 3))
                    }
                    
                    let texts = [12,18,0,6]
                    
                    ForEach(texts.indices, id: \.self) { index in
                        Text("\(texts[index])")
                            .font(.caption.bold())
                            .foregroundColor(.black)
                            .rotationEffect(.init(degrees: Double(index) * -90))
                            .offset(y: (width - 90) / 2)
                            .rotationEffect(.init(degrees: Double(index) * 90))
                    }
                }
                
                let startProgress = getProgress(date: tempFixedTimeModel.start)
                let toProgress = getProgress(date: tempFixedTimeModel.end)
                let reverseRotation = (startProgress > toProgress) ? -Double((1 - startProgress) * 360) : 0
                
                Circle()
                    .stroke(.black.opacity(0.06), lineWidth: 50)
                Circle()
                    .trim(from: startProgress > toProgress ? 0 : startProgress, to: toProgress + (-reverseRotation / 360))
                    .stroke(Color.primaryColor, style: StrokeStyle(lineWidth: 45, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.init(degrees: -90))
                    .rotationEffect(.init(degrees: reverseRotation))
                Image(systemName: "circle")
                    .font(.callout)
                    .foregroundColor(Color.primaryColor)
                    .frame(width: 40, height: 40)
                    .background(.white, in: Circle())
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: getAngle(progress: startProgress)))
                    .gesture(
                        DragGesture(minimumDistance: 0.0)
                            .onChanged({ value in
                                scrollDisabled = true
                                onDrag(value: value, fromSlider: true)
                            })
                            .onEnded({_ in scrollDisabled = false})
                    )
                    .onChange(
                        of: tempFixedTimeModel,
                        perform :
                            { _ in
                                if Haptics.timeIntervalSinceNow < -0.1 {
                                    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                                    Haptics = Date()
                                }
                            }
                    )
                    .rotationEffect(.init(degrees: -90))
                Image(systemName: "circle.fill")
                    .font(.callout)
                    .foregroundColor(Color.primaryColor)
                    .frame(width: 40, height: 40)
                    .background(.white, in: Circle())
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: getAngle(progress: toProgress)))
                    .gesture(
                        DragGesture(minimumDistance: 0.0)
                            .onChanged({ value in
                                scrollDisabled = true
                                onDrag(value: value, fromSlider: false)
                            })
                            .onEnded({_ in scrollDisabled = false})
                    )
                    .onChange(
                        of: tempFixedTimeModel,
                        perform :
                            { _ in
                                if Haptics.timeIntervalSinceNow < -0.1 {
                                    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                                    Haptics = Date()
                                }
                            }
                    )
                    .rotationEffect(.init(degrees: -90))
                VStack(spacing: 6) {
                    Text("\(getTimeDifference().0)hr")
                        .font(.largeTitle.bold())
                    Text("\(getTimeDifference().1)min")
                        .foregroundColor(.gray)
                }
                .scaleEffect(1.1)
            }
        }
        .frame(width: screenBounds().width / 1.6, height: screenBounds().width / 1.6)
    }
    func onDrag(value: DragGesture.Value, fromSlider: Bool = false) {
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        let radians = atan2(vector.dy - 15, vector.dx - 15)
        var angle = radians * 180 / .pi
        if angle < 0 {
            angle = 360 + angle
        }
        let progress = angle / 360
        if fromSlider {
            self.tempFixedTimeModel.start = getDate(progress: progress)
        } else {
            self.tempFixedTimeModel.end = getDate(progress: progress)
        }
    }
    func getTime(angle: Double) -> Date {
        let progress = angle / 15
        let hour = Int(progress)
        var minute = (progress.truncatingRemainder(dividingBy: 1) * 60).rounded()
        if minute < 61 && minute > 0 {
            minute = 30
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if let date = formatter.date(from: "\(hour):\(Int(minute))") {
            return date
        }
        return .init()
    }
    
    func getDate(progress : CGFloat) -> Date {
        let hourAndMinute = progress * 60 * 24
        let hour = Int(hourAndMinute / 60)
        let minute = Int(hourAndMinute.truncatingRemainder(dividingBy: 60))/30*30
        return DateUtil.createDate(year: 1970, month: 1, day: 1, hour: hour, minute: minute)
    }
    
    func getProgress(date : Date) -> CGFloat {
        let timeString = DateUtil.getFormattedTime(date)
        let timeComponents  = timeString.split(separator: ":")
        guard timeComponents.count == 2,
              let hour = Double(timeComponents[0]),
              let minute = Double(timeComponents[1]) else {
            return 0
        }
        let totalMinutesInDay: Double = 24 * 60
        let currentTimeInMinutes: Double = (hour * 60) + minute
        let intervalInMinutes: Double = 30
        let roundedMinutes = (currentTimeInMinutes / intervalInMinutes).rounded() * intervalInMinutes
        let progressOfDay = (roundedMinutes / totalMinutesInDay)
        return progressOfDay
    }
    
    func getAngle(progress : CGFloat) -> Double {
        return Double(progress * 360)
    }
    
    func getTimeDifference() -> (Int, Int) {
        let start = tempFixedTimeModel.start
        let end = tempFixedTimeModel.end
        var timeDifference = end.timeIntervalSince(start)
        if timeDifference < 0 {
            timeDifference += 3600*24
        }
        let hour = Int(timeDifference/60/60)
        let minute = Int(timeDifference)/60%60
        return (hour, minute)
    }
}

struct SettingTestView : View {
    @State var fixedTimeViewModel = FixedTimeViewModel([
        FixedTimeModel("취침"),
        FixedTimeModel("직장"),
        FixedTimeModel("학교")
    ])
    @State var showSettingViewModal = true
    @State private var selectedIndex : Int = 0
    var isUpdate = true
    
    var body: some View{
        VStack{
            ForEach(Array(fixedTimeViewModel.fixedTimeModels.enumerated()), id: \.offset){ index, fixedTimeModel in
                Button(action: {
                    selectedIndex = index
                    showSettingViewModal.toggle()
                }, label: {Text("\(fixedTimeModel.category)")})
            }
        }
        .sheet(isPresented: $showSettingViewModal, content: {
            SettingView(
                fixedTimeViewModel: fixedTimeViewModel,
                showSettingViewModal: $showSettingViewModal,
                selectedIndex : $selectedIndex,
                tempFixedTimeModel: selectedIndex >= 0 ? fixedTimeViewModel.fixedTimeModels[selectedIndex] : FixedTimeModel(),
                id: "", isUpdate: isUpdate,
                onDelete: {id in
                    fixedTimeViewModel.deleteItem(withID: id)
            })
            .interactiveDismissDisabled()
            .presentationCornerRadius(32)
        })
    }
}


struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingTestView()
        SettingTestView()
            .preferredColorScheme(.dark)
    }
}

extension View {
    func screenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}

