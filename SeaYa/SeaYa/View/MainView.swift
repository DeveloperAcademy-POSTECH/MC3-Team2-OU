//
//  MainView.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/12.
//

import SwiftUI

struct MainView: View {
    @StateObject private var connectionManager = ConnectionService()
    @EnvironmentObject private var userData: UserData
    @State private var startGroupping = false
   
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
                
                if connectionManager.groupInfo == nil {
                    VStack(alignment: .center) {
                        Spacer(minLength: 0)
                        if !startGroupping {
                            VStack {
                                Text("꾹 누르고")
                                    .subtitle(textColor: Color.white)
                                Text("그룹 참여하기")
                                    .subtitle(textColor: Color.white)
                            }
                            .padding(EdgeInsets(top: 272, leading: 137, bottom: 0, trailing: 137))
                        }
                        
                        //TODO: ADD Haptic
                        ZStack {
                            Circle()
                                .frame(width: 145, height: 145)
                                .foregroundColor(.white)
                            
                            Image("\(userData.characterImageName)")
                                .padding(10)
                                .frame(width: 124, height: 124)
                        }
                        .padding(.top, 24)
                        .padding(.horizontal, 122)
                        .onTapGesture {
                            startGroupping = false
                            connectionManager.leaveSession()
                        }
                        .onLongPressGesture(minimumDuration: 1) {
                            connectionManager.guest(userData.nickname, userData.characterImageName)
                            startGroupping = true
                        }
                        
                        if !startGroupping {
                            HStack {
                                Button(
                                    action: {
                                    }, label: {
                                        NavigationLink(
                                            destination: {
                                                UserInfoView().environmentObject(userData)
                                            }, label: {
                                                NavigationLink(
                                                    destination: MakingGroupView(connectionManager: connectionManager)
                                                        .environmentObject(userData)
                                                        .navigationBarBackButtonHidden(),
                                                    label: {
                                                        VStack {
                                                            ZStack {
                                                                Circle()
                                                                    .frame(maxWidth: 82)
                                                                    .foregroundColor(.gray)
                                                                
                                                                Image(systemName: "badge.plus.radiowaves.right")
                                                                    .font(.system(size: 30))
                                                                    .foregroundColor(Color.white)
                                                                    .frame(width: 41, height: 48)
                                                                    .padding(.horizontal, 21)
                                                                    .padding(.vertical, 17)
                                                            }
                                                            
                                                            Text("방 만들기")
                                                                .context(textColor: Color.white)
                                                        }
                                                    }
                                                )
                                            }
                                        )
                                    }
                                    )
                                .padding(.trailing, 70)
                                
                                Button(
                                    action: {
                                        
                                    }, label: {
                                        NavigationLink(
                                            destination: {
                                               UserInfoView()
                                            }, label: {
                                                VStack {
                                                    ZStack {
                                                        Circle()
                                                            .frame(maxWidth: 82)
                                                            .foregroundColor(.gray)
                                                        
                                                        Image(systemName: "gear")
                                                            .font(.system(size: 30))
                                                            .foregroundColor(Color.white)
                                                            .frame(width: 41, height: 48)
                                                            .padding(.horizontal, 21)
                                                            .padding(.vertical, 17)
                                                    }
                                                    
                                                    Text("설정")
                                                        .context(textColor: Color.white)
                                                }
                                            }
                                        )
                                    }
                                )
                            }
                            .padding(EdgeInsets(top: 102, leading: 78, bottom: 134, trailing: 78))
                        }
                        
                        if startGroupping {
                            //TODO: animation start
                            
                            Text("잠시만 기다려주세요")
                                .font(.system(size: 23, weight: .bold))
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 35, leading: 100, bottom: 0, trailing: 100))
                            
                            Text("호스트의 호출을 기다리고 있어요")
                                .caption(textColor: Color.white)
                                .padding(EdgeInsets(top: 5, leading: 95, bottom: 0, trailing: 95))
                            
                            Spacer(minLength: 0)
                            
                        }
                    }
                    .ignoresSafeArea()
                }
                else {
                    GuestCallingDone()
                        .onAppear(){
                            startGroupping = false
                            print(connectionManager.groupInfo)
                        }
                }
            }
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData() // UserData 객체를 생성하여 nickname 설정
        
        return MainView().environmentObject(userData)
    }
}

