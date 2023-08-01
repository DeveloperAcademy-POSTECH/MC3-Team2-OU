//
//  UserData.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/12.
//

import Foundation

class UserData: ObservableObject{
    var uid : String

    @Published private(set) var nickname: String
    @Published private(set) var characterImageName: String
    public func setNickName(_ nickName:String){
        self.nickname = nickName
        UserInfoRepository.shared.setNickName(nickName: nickName)
    }
    public func setImageName(_ imageName: String){
        self.characterImageName = imageName
        UserInfoRepository.shared.setImageName(imageName: imageName)
    }
    
    
    init() {
        if UserInfoRepository.shared.getUid() != nil{
            self.uid = UserInfoRepository.shared.getUid()!
            self.nickname =  UserInfoRepository.shared.getNickName() ?? ""
            self.characterImageName = UserInfoRepository.shared.getImageName() ?? "01"
        }
        else{
            self.uid = UUID().uuidString
            self.nickname = ""
            self.characterImageName = "01"
            UserInfoRepository.shared.setUid(uid: uid)
        }
    }
}
