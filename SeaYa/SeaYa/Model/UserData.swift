//
//  UserData.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/12.
//

import Foundation

class UserData: ObservableObject{
    var uid : String
    @Published var nickname: String
    @Published var characterImageName: String
    
    init() {
        if let uid = UserInfoRepository.shared.getUid(){
            self.uid = UserInfoRepository.shared.getUid()!
            self.nickname = UserInfoRepository.shared.getUid()!
            self.characterImageName = UserInfoRepository.shared.getUid()!
        }
        else{
            self.uid = ""
            self.nickname = "hello"
            self.characterImageName = "01"
        }
    }
}

