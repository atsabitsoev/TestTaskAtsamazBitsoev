//
//  AuthVC.swift
//  TestTaskAtsamazBitsoev
//
//  Created by Ацамаз on 16/02/2019.
//  Copyright © 2019 a.s.bitsoev. All rights reserved.
//

import UIKit

class AuthVC: UIViewController {
    
    
    @IBOutlet weak var labPhoneNumber: UITextField!
    @IBOutlet weak var labPassword: UITextField!
    @IBOutlet weak var buttonSignIn: UIButton!
    @IBOutlet weak var mainImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setAppearance()
        addObservers()
        setSavedUserDataToTextFields()
        
    }
    
    
    // APPEARENCE
    func setAppearance() {
        
        buttonSignIn.layer.cornerRadius = 5
        buttonSignIn.layer.masksToBounds = true
        
    }
    
    
    // НАЖАТИЕ КНОПКИ "ВОЙТИ"
    @IBAction func signInTapped(_ sender: UIButton) {
        
        saveToKeychain()
        authorizeUser()
        
    }
    
    
    // СОХРАНИТЬ ЛОГИН И ПАРОЛЬ В KEYCHAIN
    func saveToKeychain() {
        
        if let phone = labPhoneNumber.text, let password = labPassword.text {
            
            KeyChain.standard.saveUserData(phone: phone, password: password)
            
        }
        
    }
    
    
    // АВТОРИЗАЦИЯ ПОЛЬЗОВАТЕЛЯ
    func authorizeUser() {
        
        if let phone = labPhoneNumber.text, let password = labPassword.text {
            
            Authorization.standard.authorizeUser(phone: phone, password: password)
            
        }

    }
    
    
    // УСТАНОВИТЬ СОХРАНЕННЫЕ ЛОГИН И ПАРОЛЬ В ПОЛЯ
    func setSavedUserDataToTextFields() {
        
        if let userData = KeyChain.standard.getUserData() {
            
            labPhoneNumber.text = userData["phone"] as? String
            labPassword.text = userData["password"] as? String
            
            labPhoneNumber.backgroundColor = #colorLiteral(red: 0.9382581115, green: 0.8733785748, blue: 0.684623003, alpha: 1)
            labPassword.backgroundColor = #colorLiteral(red: 0.9382581115, green: 0.8733785748, blue: 0.684623003, alpha: 1)
            
        }
        
    }
    
    
    // УСПЕШНАЯ АВТОРИЗАЦИЯ
    @objc func authSucceedAction() {
        
        let nav = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Navigation")
        self.present(nav, animated: true, completion: nil)
        
    }
    
    
    // НЕУДАЧНАЯ АВТОРИЗАЦИЯ
    @objc func authFailedAction() {
        
        AlertPresenter.standard.presentFailedAlert(myVC: self)
        
    }
    
    
    // УСТАНОВИТЬ НАБЛЮДАТЕЛИ
    func addObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(authSucceedAction),
                                               name: NSNotification.Name("authSucceed"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(authFailedAction),
                                               name: NSNotification.Name("authFailed"),
                                               object: nil)
        
    }
    
    
}
