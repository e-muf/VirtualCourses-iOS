//
//  LoginViewController.swift
//  VirtualCourses
//
//  Created by Emanuel Flores Martínez on 31/03/21.
//

import UIKit

import FirebaseAuth

class LoginViewController: UIViewController {


    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signIn(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let e = error {
                    print("Aqui hay un error: ", e)
                    self.showAlert()
                } else {
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            }
        }
    }
    func showAlert(){
        let alert = UIAlertController(title: "Error en el Login", message: "Revisa si los datos introducidos son correctos", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

}
