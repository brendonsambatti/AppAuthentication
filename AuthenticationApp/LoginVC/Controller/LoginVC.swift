//
//  ViewController.swift
//  AuthenticationApp
//
//  Created by Brendon Sambatti on 07/07/22.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var registerButton:UIButton!
    @IBOutlet weak var validatePasswordLabel: UILabel!
    @IBOutlet weak var validateEmailLabel: UILabel!
    
    private var alert:AlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callFuncs()
    }
    
    func callFuncs(){
        hideKeyboardWhenTappedAround()
        self.configTextField()
        self.configButton()
        self.alert = AlertController(controller: self)
    }
    func configTextField(){
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        textfieldStyle(textField: emailTextField, color: .white)
        textfieldStyle(textField: passwordTextField, color: .white)
        self.passwordTextField.isSecureTextEntry = true
    }
    func configButton(){
        self.signButton.isEnabled = false
        buttonStyle(button: self.registerButton)
        self.signButton.layer.cornerRadius = 5.0
    }
    
    @IBAction func tappedLoginButton(_ sender: UIButton) {
        let userEmail:String = emailTextField.text ?? ""
        let userPassword:String = passwordTextField.text ?? ""
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { [self] authResult, error in
            if authResult != nil{
                print("Sucesso ao autenticar =====>")
                let vC = UIStoryboard(name: "HomeVC", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
                vC?.modalPresentationStyle =  .fullScreen
                self.present(vC ?? UIViewController(), animated: true, completion: nil)
            }
            if error != nil {
                alert?.fastAlert(title: "Atenção!", message: "Erro ao autenticar, verifique os dados.")
            }
        }
    }
    
    func validateTextFields(){
        if self.validatePasswordLabel.text == "" && self.validateEmailLabel.text == "" && self.emailTextField.text != "" && self.passwordTextField.text != ""{
            self.signButton.isEnabled = true
        }else{
            self.signButton.isEnabled = false
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
    
    @IBAction func tappedRegisterButton(_ sender: UIButton) {
        let vC = UIStoryboard(name: "RegisterVC", bundle: nil).instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC
        vC?.modalPresentationStyle =  .popover
        self.present(vC ?? UIViewController(), animated: true, completion: nil)
    }
    
    
    @IBAction func tappedResetPasswordButton(_ sender: UIButton) {
        let vC = UIStoryboard(name: "ResetPasswordVC", bundle: nil).instantiateViewController(withIdentifier: "ResetPasswordVC") as? ResetPasswordVC
        vC?.modalPresentationStyle =  .popover
        self.present(vC ?? UIViewController(), animated: true, completion: nil)
    }
    
}
extension LoginVC:UITextFieldDelegate{
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
