//
//  OnboardingDoneView.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/31.
//

import SwiftUI

struct OnboardingDoneView: View {
    @Binding var isOnboardingCompleted: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let itemWidth = screenWidth / 3 - 20
            
            VStack{
                HStack {
                    Rectangle()
                        .foregroundColor(Color.primaryColor)
                        .frame(width: itemWidth, height: 5)
                        .cornerRadius(10)
                    
                    Rectangle()
                        .foregroundColor(Color.primaryColor)
                        .frame(width: itemWidth, height: 5)
                        .cornerRadius(10)
                    
                    Rectangle()
                        .foregroundColor(Color.primaryColor)
                        .frame(width: itemWidth, height: 5)
                        .cornerRadius(10)
                }
                
                Text("사용자 설정이 모두 끝났어요\n이제 그룹원을 찾아보세요!")
                    .title(textColor: Color.textColor)
                    .padding(.vertical, 40)
                    .frame(width: 340, alignment: .leading)
                
                Image("")
                    .resizable()
                    .frame(width: 288, height: 300)
                
                Spacer(minLength: 0)
                
                BigButton_Blue(title: "약속 잡으러 가기", action: {isOnboardingCompleted = true})
            }
            .padding()
        }
    }
}

struct OnboardingDoneView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingDoneView(isOnboardingCompleted: .constant(false))
    }
}
