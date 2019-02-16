//
//  KeyChain.swift
//  TestTaskAtsamazBitsoev
//
//  Created by Ацамаз on 16/02/2019.
//  Copyright © 2019 a.s.bitsoev. All rights reserved.
//

import Foundation
import Locksmith

class KeyChain {
    
    // SINGLETON
    static let standard = KeyChain()
    private init() {}
    
    
    // СОХРАНИТЬ ДАННЫЕ ПОЛЬЗОВАТЕЛЯ
    func saveUserData(phone: String, password: String) {
        
        do {
            
            try Locksmith.saveData(data: ["phone" : phone, "password" : password], forUserAccount: "myUser")
            
        } catch {
            
            updateUserData(phone: phone, password: password)
            
        }
        
    }
    
    
    // ОБНОВИТЬ ДАННЫЕ ПОЛЬЗОВАТЕЛЯ
    private func updateUserData(phone: String, password: String) {
        
        do {
            
            try Locksmith.updateData(data: ["phone" : phone, "password" : password], forUserAccount: "myUser")
            
        } catch {
            
            print("Невозможно сохранить данные входа")
            
        }
        
    }
    
    
    // ПОЛУЧИТЬ ДАННЫЕ ПОЛЬЗОВАТЕЛЯ
    func getUserData() -> [String: Any]? {
        
        let userData = Locksmith.loadDataForUserAccount(userAccount: "myUser")
        return userData
        
    }
    
    
}
