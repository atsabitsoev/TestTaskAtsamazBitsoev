//
//  AlertPresenter.swift
//  TestTaskAtsamazBitsoev
//
//  Created by Ацамаз on 16/02/2019.
//  Copyright © 2019 a.s.bitsoev. All rights reserved.
//

import UIKit

class AlertPresenter {
    
    // SINGLETON
    static let standard = AlertPresenter()
    private init() {}
    
    
    // НЕУДАЧНАЯ АВТОРИЗАЦИЯ
    func presentFailedAlert(myVC: UIViewController) {
        
        let alert = UIAlertController(title: "Ошибка авторизации",
                                      message: "Проверьте введенные данные",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Хорошо",
                                     style: .cancel,
                                     handler: nil)
        
        alert.addAction(okAction)
        
        myVC.present(alert, animated: true, completion: nil)
        
    }
    
    
}
