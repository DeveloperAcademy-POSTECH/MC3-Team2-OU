//
//  HostCallingView.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/24.
//

import SwiftUI

struct HostCallingView: View {
    @ObservedObject var connectionManager: ConnectionService
    @EnvironmentObject private var userData: UserData
    @State private var moveToDoneView = false
    @State private var showingAlert = false
    @State private var groupInfo = GroupInfo(scheduleName: "", selectedDate: [], estimatedTime: 0)
    @Binding var scheduleName: String
    @Binding var selectedDate: [Date]
    @Binding var estimatedTime: Int
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(
                        colors: [Color.primaryColor,
                                 Color.gradientColor]),
                    startPoint: .top, endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                if !moveToDoneView {
                    VStack {
                        ZStack {
                            GuestListView(connectionManager: connectionManager)
                                .frame(alignment: .center)
                                .offset(y: -30)
                            
                            ZStack {
                                LottieView(jsonName: "HomeView")
                                    .scaledToFit()
                                
                                Button (action: {
                                    showingAlert.toggle()
                                }, label: {
                                    Circle()
                                        .frame(width: 145, height: 145)
                                        .foregroundColor(.white)
                                })
                                .alert("그룹을 확정하시겠어요?", isPresented: $showingAlert) {
                                    VStack {
                                        Button(
                                            action: {
                                                groupInfo = GroupInfo(
                                                    hostName: userData.nickname,
                                                    scheduleName: scheduleName,
                                                    selectedDate: selectedDate,
                                                    estimatedTime: estimatedTime
                                                )
                                                
                                                moveToDoneView = true
                                            }, label: {
                                                Text("확정할게요")
                                            }
                                        )
                                        
                                        Button(
                                            role: .cancel,
                                            action: {},
                                            label: {
                                                Text("취소")
                                            }
                                        )
                                    }
                                } message: {
                                    Text("\(connectionManager.peers.count)명의 그룹원과\n그룹을 확정하시겠어요?")
                                }
                                
                                VStack {
                                    Text("그룹 확정")
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                    
                                    HStack {
                                        Image(systemName: "person.2.fill")
                                            .foregroundColor(.white)
                                            .padding(.vertical, 5)
                                            .padding(.leading, 8)
                                        
                                        Text("\(connectionManager.peers.count)명")
                                            .foregroundColor(.white)
                                            .padding(.vertical, 5)
                                            .padding(.trailing, 8)
                                    }
                                    .background(Color.blue)
                                    .cornerRadius(20)
                                }
                            }
                            .padding(.top, 258)
                            .padding(.horizontal, 21)
                        }
                        VStack {
                            Text("그룹원을 찾고 있어요")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                            
                            Text("추가할 그룹원을 선택하고 그룹을 확정하세요")
                                .foregroundColor(.white)
                        }
                        .padding(EdgeInsets(top: 35, leading: 20, bottom: 140, trailing: 20))
                    }
                    .onAppear() {
                        connectionManager.host(userData.nickname)
                    }
                    .ignoresSafeArea()
                    .toolbar {
                        Button(action: {
                        }, label: {
                            NavigationLink(
                                destination: {
                                    MainView()
                                        .navigationBarBackButtonHidden()
                                }, label: {
                                    Image(systemName: "x.circle.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .opacity(0.5)
                                        .padding(.trailing, 5)
                                })
                        })
                    }
                }else {
                    HostCallingDone(connectionManager: connectionManager)
                        .environmentObject(userData)
                        .onAppear{
                            connectionManager.sendGroupInfoToGuest(groupInfo)
                            connectionManager.setGroupInfo(groupInfo)
                            print("move")
                        }
                }
            }
        }
    }
}

struct HostCallingView_Previews: PreviewProvider {
    static var previews: some View {
        HostCallingView(
            connectionManager: ConnectionService(),
            scheduleName: .constant("저녁 회식"),
            selectedDate: .constant([Date]()),
            estimatedTime: .constant(1))
    }
}
