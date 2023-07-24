//
//  ResultView.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/19.
//

import SwiftUI

struct ResultView: View {
    var body: some View {
        VStack {
            Text("일정이 성사됐어요!")
                .subtitle(textColor: Color.textColor)
                .padding(.top, 40)

            Image("your_image_name")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 150)
            Text("아카데미 저녁 회식")
                .headline(textColor: Color.textColor)
                .padding(.top, 40)
                .padding(.bottom, 18)
            Divider()
                .frame(width: 214)
            Text("7월 22일 수요일")
                .context(textColor: Color.textColor)
                .multilineTextAlignment(.center)
                .padding(.top,30)
            Text("19:30 - 20:30")
                .subtitle(textColor: Color.textColor)
                .padding(.top, 3)
                .padding(.bottom, 29)
            SmallButton_Blue(title: "일정입력하기", action: {})
                .padding(.bottom, 10)
            SmallButton_White(title: "홈화면으로 돌아가기", action: {})
                .padding(.bottom, 19)
        }
        .frame(width: 300)
        .background(Color.white)
        .cornerRadius(32)
        
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
    }
}
