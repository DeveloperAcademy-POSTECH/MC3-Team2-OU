//
//  MainView.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/12.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var userData: UserData
    var body: some View {
        VStack {
              Text("안녕하세요, \(userData.nickname) 님")
                    .title(textColor: Color.primary)
                 
                  .padding()
                Text("hello")
                    .title(textColor: Color.primary)
        }
    }
}
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData() // UserData 객체를 생성하여 nickname 설정
        
        return MainView().environmentObject(userData)
    }
}

