//
//  UserData.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/12.
//

import Foundation

class UserData: ObservableObject ,Codable{
    var uid : UUID?
    var nickname: String = ""
    var characterImageName: String = "01"
}

