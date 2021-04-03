//
//  RegisterViewController.swift
//  VirtualCourses
//
//  Created by Emanuel Flores Martínez on 31/03/21.
//

import UIKit

import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func signUp(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let e = error {
                    print(e)
                } else {
                    self.db.collection("users").document(email).setData(["name": self.nameTextField.text ?? ""])
                    
                    self.performSegue(withIdentifier: "registerSegue", sender: self)
                }
            }
        }
    }
    
}
