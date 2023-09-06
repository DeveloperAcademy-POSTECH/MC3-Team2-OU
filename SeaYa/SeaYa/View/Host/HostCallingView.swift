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
                                .zIndex(1)
                                .multilineTextAlignment(.center)
                                .offset(y: -30)
                            
                            ZStack {
                                LottieView(jsonName: "HomeView")
                                    .zIndex(-1)
                                    .scaledToFit()
                                
                                Button (action: {
                                    showingAlert.toggle()
                                }, label: {
                                    Circle()
                                        .frame(width: 145, height: 145)
                                        .foregroundColor(.white)
                                })
                   
                                VStack {
                                    Text("그룹 확정")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.primaryColor)
                                    
                                    HStack {
                                        Image(systemName: "person.2.fill")
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(.white)
                                            .padding(.vertical, 6)
                                            .padding(.leading, 10)
                                        
                                        Text("\(connectionManager.peers.count)명")
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(.white)
                                            .padding(.vertical, 6)
                                            .padding(.trailing, 10)
                                    }
                                    .background(Color.primaryColor)
                                    .cornerRadius(20)
                                }
                            }
                            .padding(.top, 258)
                            .padding(.horizontal, 21)
                        }
                        VStack {
                            Text("그룹원을 찾고 있어요")
                                .font(.system(size: 23, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                            
                            Text("추가할 그룹원을 선택하고 그룹을 확정하세요")
                                .caption(textColor: Color.white)
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
                }
                else {
                    ZStack {
                        Color.gray
                            .ignoresSafeArea()
                            .opacity(0.5)
                        HostCallingDone(
                            connectionManager: connectionManager,
                            groupInfo: GroupInfo(
                                hostName: userData.nickname,
                                scheduleName: scheduleName,
                                selectedDate: selectedDate,
                                estimatedTime: estimatedTime
                            )
                        )
                        .environmentObject(userData)
                        .onAppear() {
                            connectionManager.sendGroupInfoToGuest(GroupInfo(
                                hostName: userData.nickname,
                                scheduleName: scheduleName,
                                selectedDate: selectedDate,
                                estimatedTime: estimatedTime
                            ))
                        }
                    }
                }
                
                if showingAlert {
                    CustomAlert(showingAlert: $showingAlert, moveToDoneView: $moveToDoneView, guestCnt: connectionManager.peers.count)
                }
            }
                .ignoresSafeArea()
                .multilineTextAlignment(.center)
        }
    }
}

struct HostCallingViewTest : View{
    @State var scheduleName = "Hello World"
    @State var selectedDate = [Date()]
    @State var estimatedTime = 2
    var body: some View{
        HostCallingView(
            connectionManager: ConnectionService(),
            scheduleName: $scheduleName,
            selectedDate: $selectedDate,
            estimatedTime: $estimatedTime)
        .environmentObject(UserData())
    }
}


struct HostCallingView_Previews: PreviewProvider {
    static var previews: some View {
        HostCallingViewTest()
    }
}
