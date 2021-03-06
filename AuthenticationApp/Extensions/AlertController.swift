//
//  AlertController.swift
//  AuthenticationApp
//
//  Created by Brendon Sambatti on 07/07/22.
//

import Foundation
import UIKit

enum ActionType{
    case aceitar
    case cancel
}

class AlertController {
    
    var controller:UIViewController
    
    init(controller:UIViewController){
        self.controller = controller
    }
    func showAlert(title:String,message:String,titleButton:String,completion:@escaping(_ value:ActionType)-> Void){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let aceitar = UIAlertAction(title: titleButton, style: .default) { alert in
            print("aceitar pressionado")
            completion(.aceitar)
        }
        let cancel = UIAlertAction(title: "Cancelar", style: .default) { _ in
            completion(.cancel)
        }
        
        alert.addAction(aceitar)
        alert.addAction(cancel)
        self.controller.present(alert, animated: true)
    }
    
    func fastAlert(title:String, message:String){
        let alertController:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok:UIAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(ok)
        self.controller.present(alertController, animated: true, completion: nil)
    }
    
}
