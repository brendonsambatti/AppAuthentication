//
//  HomeVC.swift
//  AuthenticationApp
//
//  Created by Brendon Sambatti on 08/07/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeVC: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    
    private var alert:AlertController?
    var handle: AuthStateDidChangeListenerHandle?
    
    var firestore: Firestore?
    var auth: Auth?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callFuncs()
    }
    
    func callFuncs(){
        self.firestore = Firestore.firestore()
        self.auth = Auth.auth()
        self.alert = AlertController(controller: self)
        userData()
    }
    func userData(){
        handle = Auth.auth().addStateDidChangeListener({ auth, user in
            if let user = user {
                let email = user.email
                self.emailLabel.text = String(email ?? "")
            }
        })
    }
    
    @IBAction func tappedExitButton(_ sender: UIButton) {
        alert?.showAlert(title: "Atenção!", message: "Você tem certeza que deseja sair?", titleButton: "Confirmar", completion: { value in
            if value == .aceitar{
                do {
                    try self.auth?.signOut()
                    let vC = UIStoryboard(name: "LoginVC", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                    vC?.modalPresentationStyle =  .fullScreen
                    self.present(vC ?? UIViewController(), animated: true, completion: nil)
                } catch _ {
                    self.alert?.fastAlert(title:"Atenção!", message: "Error ao desconectar")
                }
            }
            if value == .cancel{
                print("Cancelar pressionado")
            }
        })
        
    }
    
}
