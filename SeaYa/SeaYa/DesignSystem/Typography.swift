//
//  Typography.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/14.
//

import SwiftUI


extension Text {
    func title(textColor: Color) -> some View {
        let lineHeight: CGFloat = 1.6
        let letterSpacing: CGFloat = -0.015
        let fontSize: CGFloat = 23
        return self.font(Font.system(size: fontSize, weight: .bold))
            .lineSpacing(lineHeight * fontSize - fontSize)
            .tracking(letterSpacing * fontSize)
            .foregroundColor(textColor)
    }
    func subtitle(textColor: Color) -> some View {
        let lineHeight: CGFloat = 1.2
        let letterSpacing: CGFloat = -0.025
        let fontSize: CGFloat = 20
        return self.font(Font.system(size: fontSize, weight: .bold))
            .lineSpacing(lineHeight * fontSize - fontSize)
            .tracking(letterSpacing * fontSize)
            .foregroundColor(textColor)
    }
    func headline(textColor: Color) -> some View {
        let lineHeight: CGFloat = 1.6
        let letterSpacing: CGFloat = -0.025
        let fontSize: CGFloat = 18
        return self.font(Font.system(size: fontSize, weight: .bold))
            .lineSpacing(lineHeight * fontSize - fontSize)
            .tracking(letterSpacing * fontSize)
            .foregroundColor(textColor)
    }
    func body(textColor: Color) -> some View {
        let lineHeight: CGFloat = 1.6
        let letterSpacing: CGFloat = -0.015
        let fontSize: CGFloat = 17
        return self.font(Font.system(size: fontSize, weight: .regular))
            .lineSpacing(lineHeight * fontSize - fontSize)
            .tracking(letterSpacing * fontSize)
            .foregroundColor(textColor)
    }
    func caption(textColor: Color) -> some View {
        let lineHeight: CGFloat = 1.6
        let letterSpacing: CGFloat = -0.015
        let fontSize: CGFloat = 15
        return self.font(Font.system(size: fontSize, weight: .regular))
            .lineSpacing(lineHeight * fontSize - fontSize)
            .tracking(letterSpacing * fontSize)
            .foregroundColor(textColor)
    }
    func bigButton(textColor: Color) -> some View {
        let lineHeight: CGFloat = 1.6
        let letterSpacing: CGFloat = -0.015
        let fontSize: CGFloat = 16
        return self.font(Font.system(size: fontSize, weight: .bold))
            .lineSpacing(lineHeight * fontSize - fontSize)
            .tracking(letterSpacing * fontSize)
            .foregroundColor(textColor)
    }
    func smallButton(textColor: Color) -> some View {
        let lineHeight: CGFloat = 1.6
        let letterSpacing: CGFloat = -0.015
        let fontSize: CGFloat = 14
        return self.font(Font.system(size: fontSize, weight: .bold))
            .lineSpacing(lineHeight * fontSize - fontSize)
            .tracking(letterSpacing * fontSize)
            .foregroundColor(textColor)
    }
    func context(textColor: Color) -> some View {
        let lineHeight: CGFloat = 1.6
        let letterSpacing: CGFloat = -0.015
        let fontSize: CGFloat = 14
        return self.font(Font.system(size: fontSize, weight: .regular))
            .lineSpacing(lineHeight * fontSize - fontSize)
            .tracking(letterSpacing * fontSize)
            .foregroundColor(textColor)
    }
}
                  
    

struct Typography_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing:0) {
            Text("hello")
                .title(textColor: Color.primaryColor)
            Text("hello2")
                .caption(textColor: Color.textColor)
           
        }
    }
}
