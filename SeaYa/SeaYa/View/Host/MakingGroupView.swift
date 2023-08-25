//
//  MakingGroupView.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/17.
//

import SwiftUI

struct MakingGroupView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var userData: UserData
    @ObservedObject var connectionManager: ConnectionService
    @State private var scheduleName: String = ""
    @State private var selectedHour = 0
    @State private var selectedMinute = 0
    @State private var selectedDate = [Date]()
    @State private var moveToNextView = false
    var isNextButtonDisabled: Bool {
        return scheduleName.isEmpty || selectedDate.isEmpty ||  (selectedHour == 0 && selectedMinute == 0)
    }

    var body: some View {
        NavigationStack {
            ScrollView() {
                VStack(alignment: .leading) {
                    Text("일정 제목")
                        .headline(textColor: Color.textColor)
                        .padding(EdgeInsets(top: 30, leading: 16, bottom: 0, trailing: 0))
                    TextFieldTheme(placeholder: "제목을 입력하세요", input: $scheduleName)
                        .padding(EdgeInsets(top: 6, leading: 16, bottom: 0, trailing: 16))
                    Text("기간 설정")
                        .headline(textColor: Color.textColor)
                        .padding(EdgeInsets(top: 35, leading: 16, bottom: 0, trailing: 0))
                    ZStack {
                        Rectangle()
                            .foregroundColor(.textFieldColor)
                            .frame(maxWidth: 358, maxHeight: 200)
                            .cornerRadius(16)
                        CalendarView(selectedDate: $selectedDate)
                            .padding(16)
                        
                    }
                    .padding(EdgeInsets(top: 6, leading: 16, bottom: 0, trailing: 16))
                    
                    Text("소요 시간 지정")
                        .headline(textColor: Color.textColor)
                        .padding(EdgeInsets(top: 35, leading: 16, bottom: 0, trailing: 0))
                    
                    HStack {
                        Picker("Hour", selection: $selectedHour) {
                            ForEach(0..<16) { hour in
                                Text("\(hour)시간")
                            }
                        }
                        .pickerStyle(.wheel)
                        .clipped()
                        
                        Picker("Minute", selection: $selectedMinute) {
                            ForEach([0, 30], id: \.self) { minute in
                                Text("\(minute)분")
                            }
                        }
                        .pickerStyle(.wheel)
                        .clipped()
                    }
                    .frame(minHeight: 150)

                    if isNextButtonDisabled {
                        BigButton_Unactive(title: "다음", action: {})
                            .padding(EdgeInsets(top: 30, leading: 16, bottom: 25, trailing: 16))
                    } else {
                        NavigationLink(
                            destination: HostCallingView(
                                connectionManager: connectionManager,
                                scheduleName: $scheduleName,
                                selectedDate: $selectedDate,
                                estimatedTime: .constant(selectedMinute == 30 ? selectedHour*2+1 : selectedHour*2)
                            )
                            .navigationBarBackButtonHidden()
                            .environmentObject(userData),
                            label: {
                                Text("다음")
                                    .bigButton(textColor: .white)
                                        .frame(width: 358, height: 55, alignment: .center)
                                        .background(Color.primaryColor)
                                        .cornerRadius(16)
                                .padding(EdgeInsets(top: 30, leading: 16, bottom: 25, trailing: 16))
                            })
                    }
                }
                .scaledToFit()
            }
            .scrollDisabled(false)
            .background(Color.backgroundColor)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("방 만들기")
                            .body(textColor: Color.textColor)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .tint(Color.black)
                    })
                }
            }
        }
    }
}

struct MakingGroupView_Previews: PreviewProvider {
    static var previews: some View {
        MakingGroupView(connectionManager: ConnectionService())
        MakingGroupView(connectionManager: ConnectionService())
            .preferredColorScheme(.dark)
    }
}
