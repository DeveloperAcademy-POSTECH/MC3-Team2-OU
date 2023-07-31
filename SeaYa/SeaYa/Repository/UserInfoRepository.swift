//
//  UserInfoRepository.swift
//  SeaYa
//
//  Created by musung on 2023/07/29.
//

import Foundation

class UserInfoRepository{
    static let shared = UserInfoRepository()
    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private init(userDefaults: UserDefaults = .standard) {
         self.userDefaults = userDefaults
     }
    
    public func setUid(uid: String){
        let uid = UUID().uuidString
        userDefaults.set(uid, forKey: "uid")
    }
    public func getUid() -> String?{
        if let uid = UserDefaults.standard.object(forKey: "uid") as? String {
            return uid
        }
        return nil
    }
    public func setNickName(nickName: String){
        userDefaults.set(nickName, forKey: "nickName")
    }
    public func getNickName() -> String?{
        if let nickName = UserDefaults.standard.object(forKey: "nickName") as? String {
            return nickName
        }
        return nil
    }
    public func setImageName(imageName: String){
        userDefaults.set(imageName, forKey: "imageName")
    }
    public func getImageName() -> String?{
        if let imageName = UserDefaults.standard.object(forKey: "imageName") as? String {
            return imageName
        }
        return nil
    }
    
//    public func createUserInfo(userInfo: UserData){
//        if let encoded = try? encoder.encode(userInfo) {
//            userDefaults.set(encoded, forKey: "userInfo")
//        }
//    }
//    public func updateUserInfo(userInfo: UserData){
//        createUserInfo(userInfo: userInfo)
//
//    }
//    public func getUserInfo()->UserData?{
//        if let savedData = UserDefaults.standard.object(forKey: "userInfo") as? Data {
//            if let savedObject = try? decoder.decode(UserData.self, from: savedData) {
//                return savedObject
//            }
//        }
//        return nil
//    }
}
