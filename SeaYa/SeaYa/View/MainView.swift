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
                  .font(.title)
                  .fontWeight(.bold)
                  .padding()
              // 나머지 메인 페이지 내용 추가
        }
    }
}


