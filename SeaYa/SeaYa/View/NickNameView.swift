//
//  NickNameView.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/12.
//

import SwiftUI

struct NicknameView: View {
    @Binding var isNicknameSettingCompleted : Bool
    @State private var nickname = ""
    
    @EnvironmentObject private var userData: UserData
    
    @State private var isSheetPresented = false
    
    
    let columns: [GridItem] = Array(repeating: .init(), count: 3) // TODO: Dummy data

    var body: some View {
        VStack {
            Text("앱에서 사용할\n프로필을 설정해주세요")
                .title(textColor: Color.textColor)
                .padding(.vertical, 40)
                .frame(width: 340, alignment: .leading)
            ZStack{
                Image(userData.characterImageName)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .overlay(alignment: .bottomTrailing){
                        Image("edit")
                            .resizable()
                            .frame(width: 36,height: 36, alignment: .bottomTrailing)
                            .onTapGesture {
                                print("isClicked!")
                                isSheetPresented = true
                            }
                    }.padding(.bottom, 22)
            }
                TextField("닉네임", text: $nickname)
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
            
            Button(action: {
                if !nickname.isEmpty {
                    userData.setNickName(nickname)
                  isNicknameSettingCompleted = true
              }
            }) {
                Text("다음")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(nickname.isEmpty ? Color.unactiveColor : Color.primaryColor)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
           
        }
        .padding()
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
                                userData.setImageName("0\(index+1)")
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
    }
}

struct NicknameView_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData() // UserData 객체를 생성하여 nickname 설정
        
        return NicknameView(isNicknameSettingCompleted: .constant(false)).environmentObject(userData)
    }
}




