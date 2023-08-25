//
//  Color.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/14.
//

import SwiftUI

extension Color {
    static let primaryColor = Color("primary")
    static let primary_selectedColor = Color("primary_selected")
    static let backgroundColor = Color("background")
    static let textColor = Color("text")
    static let unactiveColor = Color("unactive")
    static let gradientColor = Color("gradient")
    static let textFieldColor = Color("textField")
    static let whiteColor = Color("whiteColor")
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
      }
}
