//
//  LoginViewController.swift
//  VirtualCourses
//
//  Created by Emanuel Flores Martínez on 31/03/21.
//

import UIKit

import FirebaseAuth
import GoogleSignIn

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
                    print(e)
                } else {
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            }
        }
    }

}
