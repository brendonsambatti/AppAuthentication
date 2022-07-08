//
//  ResetPasswordVC.swift
//  AuthenticationApp
//
//  Created by Brendon Sambatti on 08/07/22.
//

import UIKit
import FirebaseAuth

class ResetPasswordVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var emailValidationLabel: UILabel!
    
    var auth:Auth?
    var alert:AlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callFuncs()
    }
    
    func callFuncs(){
        self.auth = Auth.auth()
        alert = AlertController(controller: self)
        self.configTextField()
        self.configButton()
        hideKeyboardWhenTappedAround()
    }
    
    func configButton(){
        buttonStyle(button: self.returnButton)
        self.resetButton.isEnabled = false
        self.resetButton.layer.cornerRadius = 5.0
    }
    
    func configTextField(){
        self.emailTextField.delegate = self
        textfieldStyle(textField: emailTextField, color: UIColor.white)
    }
    
    @IBAction func validateEmail(_ sender: Any) {
        if self.emailTextField.text?.isValidEmail() == false{
            textfieldStyle(textField: emailTextField, color: UIColor.red)
            self.emailValidationLabel.text = "Email inválido"
            self.emailValidationLabel.textColor = .red
            self.resetButton.isEnabled = false
        }else{
            textfieldStyle(textField: emailTextField, color: UIColor.white)
            self.emailValidationLabel.textColor = .clear
            self.resetButton.isEnabled = true
        }
    }
    
    @IBAction func tappedResetButton(_ sender: UIButton) {
        let userEmail:String = emailTextField.text ?? ""
        self.auth?.sendPasswordReset(withEmail: userEmail, completion: { error in
            if error != nil{
                self.alert?.fastAlert(title: "Atenção!", message: "Verifique os dados preenchidos.")
            }
            if error == nil{
                self.alert?.showAlert(title: "Concluído!", message: "Email de recuperação encaminhado com sucesso! (Verifique a caixa de Spam).", titleButton: "Voltar", completion: { value in
                    if value == .aceitar{
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                self.emailTextField.text = ""
            }
        })
    }
    
    @IBAction func tappedReturnButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ResetPasswordVC:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textfieldStyle(textField: textField, color: UIColor.blue)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textfieldStyle(textField: textField, color: UIColor.white)
        self.validateEmail(self.emailTextField as Any)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            self.validateEmail(self.emailTextField as Any)
            textField.resignFirstResponder()
        }
        return true
    }
}
