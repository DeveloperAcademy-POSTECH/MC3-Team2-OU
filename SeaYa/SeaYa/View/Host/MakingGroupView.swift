//
//  MakingGroupView.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/17.
//

import SwiftUI

//TODO: 다음 view로 넘어갈 때 입력받은 정보 저장
struct MakingGroupView: View {
    @EnvironmentObject private var userData: UserData
    @State private var scheduleName: String = ""
    @State private var selectedHour = 0
    @State private var selectedMinute = 0
    @State private var choseDate = [Date]()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("일정 제목")
                    .padding(EdgeInsets(top: 28, leading: 16, bottom: 0, trailing: 0))
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(maxWidth: 358, maxHeight: 50)
                        .cornerRadius(8)
                    
                    TextField("제목을 입력하세요.", text: $scheduleName)
                        .background(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                }
                .padding(EdgeInsets(top: 10, leading: 16, bottom: 0, trailing: 16))
                
                
                Text("기간 설정")
                    .padding(EdgeInsets(top: 43, leading: 16, bottom: 0, trailing: 0))
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(maxWidth: 358, maxHeight: 200)
                        .cornerRadius(8)
                    
                    CalendarView(choseDate: $choseDate)
                        .padding(16)
                    
                }
                .padding(EdgeInsets(top: 10, leading: 16, bottom: 0, trailing: 16))
                
                Text("소요 시간 지정")
                    .padding(EdgeInsets(top: 39, leading: 16, bottom: 0, trailing: 0))
                HStack {
                    Picker("Hour", selection: $selectedHour) {
                        ForEach(0..<16) { hour in
                            if hour == selectedHour {
                                Text("\(hour) 시간")
                            }else {
                                Text("\(hour)")
                            }
                        }
                    }
                    .pickerStyle(.wheel)
                    .clipped()
                    
                    Picker("Minute", selection: $selectedMinute) {
                        ForEach([0, 30], id: \.self) { minute in
                            if minute == selectedMinute {
                                Text("\(minute) 분")
                            }else {
                                Text("\(minute)")
                            }
                        }
                    }
                    .pickerStyle(.wheel)
                    .clipped()
                }
                .frame(minHeight: 150)
                
                
                Button(action: {
                }, label: {
                    NavigationLink(
                        destination: HostCallingView(
                            scheduleName: $scheduleName,
                            choseDate: $choseDate,
                            estimatedTime: .constant(selectedMinute == 30 ? selectedHour*2+1 : selectedHour*2)
                        )
                        .environmentObject(userData),
                        label: {
                            Text("다음")
                                .foregroundColor(.white)
                                .padding()
                        })
                })
                .frame(maxWidth: 358)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 45, trailing: 16))
            }
            .background(Color(red: 0.97, green: 0.97, blue: 0.98))
            .navigationBarTitleDisplayMode(.inline)
                .toolbar { // <2>
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text("방 만들기")
                                .font(.headline)
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                        }, label: {
                            Image(systemName: "chevron.left")
                        })
                    }
                }
        }
    }
}

struct MakingGroupView_Previews: PreviewProvider {
    static var previews: some View {
        MakingGroupView()
    }
}
