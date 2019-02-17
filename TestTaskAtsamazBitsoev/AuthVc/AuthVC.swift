//
//  AuthVC.swift
//  TestTaskAtsamazBitsoev
//
//  Created by Ацамаз on 16/02/2019.
//  Copyright © 2019 a.s.bitsoev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AKMaskField

class AuthVC: UIViewController {
    
    
    @IBOutlet weak var tfPhoneNumber: AKMaskField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var buttonSignIn: UIButton!
    @IBOutlet weak var mainImage: UIImageView!
    
    
    
    var signInBefore = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        signInBefore = UserDefaults.standard.bool(forKey: "signInBefore")
        
        addObservers()
        
        if !signInBefore {
            setMaskToTF()
        } else {
            UserDefaults.standard.set(true, forKey: "signInBefore")
        }
        
        setAppearance()
    }
    
    
    
    // МАСКА НА ПОЛЕ
    func setMaskToTF() {
        
            if let expression = UserDefaults.standard.string(forKey: "maskExpression"), let template = UserDefaults.standard.string(forKey: "maskTemplate") {
                
                tfPhoneNumber.maskExpression = expression
                tfPhoneNumber.maskTemplate = template
                self.tfPhoneNumber.placeholder = self.getCountryCode(from: self.tfPhoneNumber.maskExpression ?? "")

            } else {
                
                let url = URL(string: "http://dev-exam.l-tech.ru/api/v1/phone_masks")!
                Alamofire.request(url).responseJSON { (response) in
                    
                    let maskString = JSON(response.result.value!)["phoneMask"].stringValue
                    print(maskString)
                    let countryCode = self.getCountryCode(from: maskString)
                    let phoneMask = self.getPhoneMask(from: maskString)
                    
                    self.tfPhoneNumber.maskExpression = "\(countryCode) \(phoneMask)"
                    UserDefaults.standard.set(self.tfPhoneNumber.maskExpression, forKey: "maskExpression")
                    self.tfPhoneNumber.maskTemplate = "1234-12345678"
                    UserDefaults.standard.set(self.tfPhoneNumber.maskTemplate, forKey: "maskTemplate")
                    
                    self.tfPhoneNumber.placeholder = self.getCountryCode(from: self.tfPhoneNumber.maskExpression ?? "")
                    
                }
                
        }
        self.setSavedUserDataToTextFields()
    }
    
    
    func getPhoneMask(from string: String) -> String {
        
        var myStr = ""
        var writing: Bool = false{
            didSet {
                
                
                
            }
        }
        func addChar() {
            if writing {
                myStr.append("{")
            } else {
                myStr.append("}-")
            }
        }
        
        var writingChanged = false {
            didSet {
                addChar()
            }
        }
        
        
        
       
        for i in string {
            
            if i == "Х" {
                writing = true
            } else {
                writing = false
            }
            
            if writing != writingChanged {
                writingChanged = writing
            }
            if writing {
                myStr.append("d")
            }
            
        }
        
        myStr.append("}")
        print(myStr)
        return myStr
        
    }
    
    
    func getCountryCode(from string: String) -> String {
        var myStr = ""
        
        for i in string {
            
            if i == " " {
                break
            }
            myStr.append(i)
        }
        
        return myStr
    }
    
    
    // APPEARENCE
    func setAppearance() {
        
        buttonSignIn.layer.cornerRadius = 5
        buttonSignIn.layer.masksToBounds = true
        
        mainImage.layer.cornerRadius = 50
        
    }
    
    
    // НАЖАТИЕ КНОПКИ "ВОЙТИ"
    @IBAction func signInTapped(_ sender: UIButton) {
        
        saveToKeychain()
        authorizeUser()
        
    }
    
    func decodeString(str: String, deleteCode: Bool) -> String {
        
        var myStr = ""
        for i in str {
            
            switch i {
            case "0","1","2","3","4","5","6","7","8","9":
                myStr.append(i)
            default:
                print(myStr)
            }
            
        }
        if deleteCode {
            myStr.removeFirst(getCountryCode(from: tfPhoneNumber.maskExpression!).count - 1)
        }
        
        print(myStr + ")))")
        
        return myStr
        
    }
    
    
    // СОХРАНИТЬ ЛОГИН И ПАРОЛЬ В KEYCHAIN
    func saveToKeychain() {
        
        if let phone = tfPhoneNumber.text, let password = tfPassword.text {
            
            KeyChain.standard.saveUserData(phone: decodeString(str: phone, deleteCode: true), password: password)
            
        }
        
    }
    
    
    // АВТОРИЗАЦИЯ ПОЛЬЗОВАТЕЛЯ
    func authorizeUser() {
        
        if let phone = tfPhoneNumber.text, let password = tfPassword.text {
            
            Authorization.standard.authorizeUser(phone: decodeString(str: phone, deleteCode: false), password: password)
            
        }

    }
    
    
    // УСТАНОВИТЬ СОХРАНЕННЫЕ ЛОГИН И ПАРОЛЬ В ПОЛЯ
    func setSavedUserDataToTextFields() {
        
        if let userData = KeyChain.standard.getUserData() {
            
            tfPhoneNumber.text = userData["phone"] as? String
            tfPassword.text = userData["password"] as? String
            
            tfPhoneNumber.backgroundColor = #colorLiteral(red: 0.9382581115, green: 0.8733785748, blue: 0.684623003, alpha: 1)
            tfPassword.backgroundColor = #colorLiteral(red: 0.9382581115, green: 0.8733785748, blue: 0.684623003, alpha: 1)
            
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
