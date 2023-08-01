//
//  UserData.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/12.
//

import Foundation
import Combine
class UserData: ObservableObject{
    var uid : String
    @Published var nickname: String {
            didSet {
                UserInfoRepository.shared.setNickName(nickName: nickname) // Save nickname to UserDefaults
            }
        }

        @Published var characterImageName: String {
            didSet {
                UserInfoRepository.shared.setImageName(imageName: characterImageName) // Save character index to UserDefaults
            }
        }
    
    init() {
        if UserInfoRepository.shared.getUid() != nil{
            self.uid = UserInfoRepository.shared.getUid()!
            self.nickname =  UserInfoRepository.shared.getNickName() ?? ""
            self.characterImageName = UserInfoRepository.shared.getImageName() ?? "01"
        }
        else{
            self.uid = ""
            self.nickname = ""
            self.characterImageName = "01"
        }
    }
}
