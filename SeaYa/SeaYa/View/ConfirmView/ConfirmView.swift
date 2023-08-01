//
//  ConfirmView.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/07/21.
//

import SwiftUI

struct ConfirmView: View {
    @ObservedObject var calcOksService =  CalcOksService.shared
    @ObservedObject var connectionManager =  ConnectionService()
    
    @State var selectedEvent : DateEvent
    @State private var selectedMembers : [DateMember] = []
    
    @State private var showDateModal = false
    @State private var showStartModal = false
    @State private var showEndModal = false
    @State private var showMemberModal = false
    @State private var selectedDate = Date()
    var body: some View {
        let members = calcOksService.dateMembers
        let time = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .weekday], from: selectedEvent.startDate)
        let endTime = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: selectedEvent.endDate)
        NavigationStack{
            VStack{
                HStack{
                    Text("일정을 확정하시겠어요?").title(textColor: .primary)
                    Spacer()
                }.padding(.leading, 16)
                
                //일정 제목
                ZStack{
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                    HStack{
                        Text("제목").headline(textColor: .primaryColor)
                        Spacer()
                        Text("\(selectedEvent.title)").body(textColor: .primary)
                    }.padding([.trailing, .leading], 20)
                }.frame(height:64)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
                
                //일정 날짜 설정
                ZStack{
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                    HStack{
                        Text("날짜").headline(textColor: .primaryColor)
                        Spacer()
                        Button(action: {self.showDateModal = true}, label : {
                            Text("\(time.month!)월 " +
                                 "\(time.day!)일")
                            .body(textColor: .primary)
                            Image(systemName: "chevron.right")
                                .resizable()
                                .frame(width: 7, height: 12)
                                .foregroundColor(Color.unactiveColor)
                        })
                    }.padding([.trailing, .leading], 20)
                }.frame(height:64)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
                
                //일정 시작 시간 설정
                ZStack{
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                    HStack{
                        Text("시작 시간").headline(textColor: .primaryColor)
                        Spacer()
                        Button(action: {self.showStartModal = true}, label : {
                            Text(
                                (time.hour! > 12 ? "오후 \(time.hour!%12)시" : "오전 \(time.hour!)시") +
                                (time.minute! == 0 ? "" : " \(time.minute!)분")
                            )
                            .body(textColor: .primary)
                            Image(systemName: "chevron.right")
                                .resizable()
                                .frame(width: 7, height: 12)
                                .foregroundColor(Color.unactiveColor)
                        })
                    }.padding([.trailing, .leading], 20)
                }.frame(height:64)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
            
                //일정 종료 시간 설정
                ZStack{
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                    HStack{
                        Text("종료 시간").headline(textColor: .primaryColor)
                        Spacer()
                        Button(action: {self.showEndModal = true}, label : {
                            Text(
                                (endTime.hour! > 12 ? "오후 \(endTime.hour!%12)시" : "오전 \(endTime.hour!)시") +
                                (endTime.minute! == 0 ? "" : " \(endTime.minute!)분")
                            )
                            .body(textColor: .primary)
                            Image(systemName: "chevron.right")
                                .resizable()
                                .frame(width: 7, height: 12)
                                .foregroundColor(Color.unactiveColor)
                        })
                    }.padding([.trailing, .leading], 20)
                }.frame(height:64)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
            
                //일정 참여 인원 설정
                ZStack{
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                    HStack{
                        Text("참여 인원").headline(textColor: .primaryColor)
                        Spacer()
                    Button(action: {self.showMemberModal = true}, label : {
                        Text("\(selectedMembers.count)명").body(textColor: .primary)
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 7, height: 12)
                            .foregroundColor(Color.unactiveColor)
                    })
                    }.padding([.trailing, .leading], 20)
                }.frame(height:64)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
                
                Spacer()
                NavigationLink(
                    destination: ResultView(connectionManager: connectionManager),
                    label:  {
                    Text("일정 검토하기").bigButton(textColor: .white)
                        .frame(width: 358, alignment: .center)
                        .padding(.vertical, 18)
                        .background(Color.primaryColor)
                        .cornerRadius(16)
                }).simultaneousGesture(TapGesture().onEnded{
                    
                        // 여기서 Send To Guest
                    let selecteMemberId = selectedMembers.map{$0.name}
                    let membersId = (members ?? []).map{$0.name}
                    
                    let attendedMember = Dictionary(uniqueKeysWithValues: zip(
                        selecteMemberId,
                        selecteMemberId.map{membersId.contains($0)}
                    ))
                    
                    let scheduleDone = ScheduleDone(
                        scheduleName: selectedEvent.title,
                        selectedDate: selectedEvent.startDate,
                        startTime: selectedEvent.startDate,
                        endTime: selectedEvent.endDate,
                        isAttend: attendedMember)
                    connectionManager.setScheduleInfo(scheduleDone)
                    connectionManager.sendScheduleInfoToGuest(scheduleDone)
                    // print("send schedule info to guest")
                })
        
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.backgroundColor)
                .sheet(isPresented: $showDateModal, content: {
                    ConfirmDateModalView(selectedEvent: $selectedEvent)
                        .presentationDetents([.height(354)])
                        .presentationCornerRadius(32)
                })
                .sheet(isPresented: $showStartModal, content: {
                    ConfirmStartModalView(selectedDate: $selectedEvent.startDate, title: "시작 시간")
                        .presentationDetents([.height(354)])
                        .presentationCornerRadius(32)
                })
                .sheet(isPresented: $showEndModal, content: {
                    ConfirmStartModalView(selectedDate: $selectedEvent.endDate, title: "종료 시간")
                        .presentationDetents([.height(354)])
                        .presentationCornerRadius(32)
                })
                .sheet(isPresented: $showMemberModal, content: {
                    if let members{
                        ConfirmMemberModalView(selectedMembers: $selectedMembers, members: members)
                            .presentationDetents([.height(354)])
                            .presentationCornerRadius(32)
                    }
                })
        }
    }
}

struct ConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmView(selectedEvent: DateEvent(title: "아카데미 저녁 회식",
                                             startDate: DateUtil.formattedDateToDate(2023, 07, 21, 18, 0),
                                             endDate: DateUtil.formattedDateToDate(2023, 7, 21, 19, 0)
                                            )
        )
        .environment(\.locale, .init(identifier: "ko"))
            .environmentObject(CalcOksService.shared)
            .onAppear{
                CalcOksService.shared.dateMembers =  [
                    DateMember(id: UUID(), name: "지민"),
                    DateMember(id: UUID(), name: "RM"),
                    DateMember(id: UUID(), name: "뷔"),
                    DateMember(id: UUID(), name: "제이홉"),
                    DateMember(id: UUID(), name: "슈가"),
                    DateMember(id: UUID(), name: "정국")
                ]
            }
    }
}
