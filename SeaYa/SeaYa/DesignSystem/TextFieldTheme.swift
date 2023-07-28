//
//  TextField.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/20.
//

import SwiftUI

struct TextFieldTheme: View {
    @State var placeholder: String
    @Binding var input: String

    var body: some View {
        TextField(placeholder, text: $input)
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .frame(width: 358, height: 47)
            .background(Color.white)
            .cornerRadius(16)
            .font(Font.system(size: 17, weight: .regular))
            .lineSpacing(1.6 * 17 - 17)
            .tracking(-0.015 * 17)
            .foregroundColor(Color.textColor)
    }
}

struct TextFieldTheme_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TextFieldTheme(placeholder: "Username", input: .constant(""))
            TextFieldTheme(placeholder: "Password", input: .constant(""))
      
        }
        .padding()
    }
}
