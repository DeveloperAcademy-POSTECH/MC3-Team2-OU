//
//  NicknameEditView.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/28.
//

import SwiftUI

struct NicknameEditView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var userData: UserData
    let userInfoRepository = UserInfoRepository.shared
    @State private var isSheetPresented = false
    @State private var nickname = ""
  
    let columns: [GridItem] = Array(repeating: .init(), count: 3) // TODO: Dummy data
   
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    ZStack{
                        Image(userData.characterImageName)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .overlay(alignment: .bottomTrailing){
                                Image("edit")
                                    .resizable()
                                    .frame(width: 36,height: 36, alignment: .bottomTrailing)
                                    .onTapGesture {
                                        isSheetPresented = true
                                    }
                            }
                            .padding(.top, 55)
                            .padding(.bottom, 22)
                    }
                    TextField("닉네임",text: $nickname)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 18)
                        .frame(width: 185, alignment: .center)
                        .overlay(
                            GeometryReader { geo in
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.primaryColor, lineWidth: 1)
                                    .frame(width: geo.size.width, height: 1, alignment: .bottom)
                                    .position(x: geo.size.width / 2, y: geo.size.height)
                            }
                        )
                        .font(Font.system(size: 18, weight: .bold))
                        .foregroundColor(Color.textColor)
                    Spacer()
                }
                .sheet(isPresented: $isSheetPresented, content: {
                    VStack{
                        RoundedRectangle(cornerRadius: 2.5)
                            .fill(Color.gray)
                            .frame(width:34, height:5)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                        Text("프로필 이미지")
                            .body(textColor: Color.textColor)
                            .padding(.bottom, 30)
                        LazyVGrid(columns: columns){
                            ForEach(0..<9, id: \.self) { index in
                                Button(
                                    action: {
                                        print(userData.characterImageName)
                                        userData.setImageName("0\(index+1)")
                                        userInfoRepository.setImageName(imageName: "0\(index+1)")
                                    },
                                    label: {
                                        ZStack{
                                            VStack{
                                                Image("0" + "\(index + 1)")
                                                    .resizable()
                                                    .frame(width: 66,height: 66)
                                            }
                                        }
                                        .padding(15)
                                    }
                                )
                            }
                        }
                    }
                    .presentationDetents([.height(426)])
                    .presentationCornerRadius(32)
                    .padding(EdgeInsets(top: 0, leading: 65, bottom: 0, trailing: 65))
                })
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text("프로필 편집")
                                .body(textColor: Color.black)
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
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                              userData.setNickName(nickname)
                        presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("완료")
                                .foregroundColor(Color.blue)
                        })
                    }
                }
            }
        }
        .onAppear{
            nickname = userData.nickname
        }
    }
}

struct NicknameEditView_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
              return NicknameEditView().environmentObject(userData)
    }
}
