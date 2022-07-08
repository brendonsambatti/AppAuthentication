//
//  RegisterVC.swift
//  AuthenticationApp
//
//  Created by Brendon Sambatti on 07/07/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var validatePasswordLabel:UILabel!
    @IBOutlet weak var validateEmailLabel:UILabel!
    var auth: Auth?
    var firestore: Firestore?
    
    private var alert:AlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callFuncs()
    }
    
    func callFuncs(){
        hideKeyboardWhenTappedAround()
        self.alert = AlertController(controller: self)
        configTextField()
        configButton()
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
    }
    
    func configTextField(){
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        textfieldStyle(textField: emailTextField, color: .white)
        textfieldStyle(textField: passwordTextField, color: .white)
        self.passwordTextField.isSecureTextEntry = true
    }
    
    func configButton(){
        buttonStyle(button: self.backButton)
        self.registerButton.isEnabled = false
        self.registerButton.layer.cornerRadius = 5.0
    }
    
    func createUser(){
        let userEmail:String = emailTextField.text ?? ""
        let userPassword:String = passwordTextField.text ?? ""
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { [self] authResult, error in
            if authResult != nil {
                self.alert?.showAlert(title: "Concluído", message: "Usuário cadastrado com sucesso.", titleButton: "Login", completion: { value in
                    if value == .aceitar{
                        self.dismiss(animated: true, completion: nil)
                    }
                    if value == .cancel{
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        print("Cancelar pressionado")
                    }
                })
            }
            if error != nil{
                self.alert?.fastAlert(title: "Atenção!", message: "Erro ao cadastrar usuário, verifique os dados.")
            }
        }
    }
    func validateTextFields(){
        if self.validatePasswordLabel.text == "" && self.validateEmailLabel.text == "" && self.emailTextField.text != "" && self.passwordTextField.text != ""{
            self.registerButton.isEnabled = true
        }else{
            self.registerButton.isEnabled = false
        }
    }
    
    func validateEmail(){
        if self.emailTextField.text?.isValidEmail() == false{
            textfieldStyle(textField: emailTextField, color: UIColor.red)
            self.validateEmailLabel.text = "Email inválido"
            self.validateEmailLabel.textColor = .red
        }else{
            textfieldStyle(textField: emailTextField, color: UIColor.white)
            self.validateEmailLabel.text = ""
            self.validateEmailLabel.textColor = .clear
        }
    }
    
    @IBAction func tappedRegisterButton(_ sender: UIButton) {
        createUser()
    }
    
    @IBAction func tappedReturnButton(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func validatePassword(_ sender: Any) {
        if self.passwordTextField.text?.isValidPassword() == true{
            self.validatePasswordLabel.text = ""
            self.validatePasswordLabel.textColor = .clear
            validateTextFields()
        }else{
            self.validatePasswordLabel.text = "A senha deve conter no minímo 6 caracteres"
            self.validatePasswordLabel.textColor = .red
            validateTextFields()
        }
    }
    
}
extension RegisterVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            textField.resignFirstResponder()
            self.passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField{
            validateEmail()
            validateTextFields()
            validatePassword(self.passwordTextField as Any)
            textField.resignFirstResponder()
        }
        validateEmail()
        validateTextFields()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textfieldStyle(textField: textField, color: UIColor.blue)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == ""{
            textfieldStyle(textField: textField, color: UIColor.red)
            validateEmail()
            validatePassword(self.passwordTextField as Any)
            validateTextFields()
        }else{
            textfieldStyle(textField: textField, color: UIColor.white)
            validateEmail()
            validatePassword(self.passwordTextField as Any)
            validateTextFields()
        }
    }
}
