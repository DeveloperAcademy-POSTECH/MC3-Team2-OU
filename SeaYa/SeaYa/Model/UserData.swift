//
//  UserData.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/12.
//

import Foundation

class UserData: ObservableObject {
    @Published var nickname: String = ""
    @Published var characterImageName: String = "01"
}

