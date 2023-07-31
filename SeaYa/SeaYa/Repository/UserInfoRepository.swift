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
    
//    public func getUserInfo() -> UserData{
//    }
    public func createUserInfo(userInfo: UserData){
        if let encoded = try? encoder.encode(userInfo) {
            userDefaults.set(encoded, forKey: "userInfo")
        }
    }
    public func updateUserInfo(userInfo: UserData){
        createUserInfo(userInfo: userInfo)
        
    }
    public func getUserInfo()->UserData?{
        if let savedData = UserDefaults.standard.object(forKey: "userInfo") as? Data {
            if let savedObject = try? decoder.decode(UserData.self, from: savedData) {
                return savedObject
            }
        }
        return nil
    }
}
