//
//  ButtonTheme.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/19.
//

import SwiftUI

struct BigButton_Blue: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .bigButton(textColor: .white)
        }
        .frame(width: 358, alignment: .center)
        .padding(.vertical, 18)
        .background(Color.primaryColor)
        .cornerRadius(16)
    }
}
struct BigButton_Selected: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .bigButton(textColor: .white)
        }
        .frame(width: 358, alignment: .center)
        .padding(.vertical, 18)
        .background(Color.primary_selectedColor)
        .cornerRadius(16)
    }
}
struct BigButton_White: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .bigButton(textColor: Color.primaryColor)
        }
        .frame(width: 358, alignment: .center)
        .padding(.vertical, 18)
        .background(.white)
        .cornerRadius(16)
    }
}
struct BigButton_Unactive: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .bigButton(textColor: .white)
        }
        .frame(width: 358, alignment: .center)
        .padding(.vertical, 18)
        .background(Color.primary_selectedColor)
        .cornerRadius(16)
    }
}

struct SmallButton_Blue: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .smallButton(textColor: .white)
                .padding(.vertical, 18)
                .frame(width: 268, height: 45, alignment: .center)
                .background(Color.primaryColor)
                .cornerRadius(16)
        }
    }
}

struct SmallButton_White: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .smallButton(textColor: Color.primaryColor)
                .padding(.vertical, 18)
                .frame(width: 268, height: 45, alignment: .center)
                .background(.white)
                .cornerRadius(16)
        }
    }
}

struct ButtonThemeTemplate : View{
    var body: some View{
        VStack(spacing: 20) {
            BigButton_Blue(title: "Primary Button") {}
            BigButton_Selected(title: "Selected Button") {}
            BigButton_White(title: "White Button") {}
            BigButton_Unactive(title: "Unactive Button") {}
            SmallButton_Blue(title: "Blue Small Button") {}
            SmallButton_White(title: "White Small Button") {}
        }
        .padding()
    }
}

struct ButtonTheme_Previews: PreviewProvider {
    static var previews: some View {
        ButtonThemeTemplate()
        ButtonThemeTemplate().preferredColorScheme(.dark)
    }
}
