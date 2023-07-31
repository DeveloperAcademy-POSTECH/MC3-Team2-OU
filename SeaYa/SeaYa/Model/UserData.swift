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
    @Published private(set)var characterImageName: String
    public func setNickName(_ nickName:String){
        self.nickname = nickName
        UserInfoRepository.shared.setNickName(nickName: nickName)
    }
    public func setImageName(_ imageName: String){
        self.characterImageName = imageName
        UserInfoRepository.shared.setImageName(imageName: imageName)
    }
    init() {
        if let uid = UserInfoRepository.shared.getUid(){
            self.uid = UserInfoRepository.shared.getUid()!
            self.nickname = UserInfoRepository.shared.getUid()!
            self.characterImageName = UserInfoRepository.shared.getUid()!
        }
        else{
            self.uid = UUID().uuidString
            self.nickname = "hello"
            self.characterImageName = "01"
            UserInfoRepository.shared.setUid(uid: uid)
        }
    }
}

