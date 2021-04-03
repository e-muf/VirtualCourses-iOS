//
//  AuthViewController.swift
//  FireBaseProof
//
//  Created by Hernán Galileo Cabrera Garibaldi on 30/03/21.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwdTextField: UITextField!
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Autenticacion"
//        Comptobar la sesion del usuario identificado
        let defaults = UserDefaults.standard
        if let email = defaults.value(forKey: "email") as? String,
           let provideer = defaults.value(forKey: "provider") as? String{
            
            authStackView.isHidden = true
            
            navigationController?.pushViewController(HomeViewController(email: email, provider: ProviderType.init(rawValue: provideer)!), animated: false)
        }
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authStackView.isHidden = false
    }

    @IBAction func googleButton(_ sender: Any) {
    }
    
    @IBOutlet weak var authStackView: UIStackView!
    @IBAction func signUpButtonAction(_ sender: Any) {
        if  let email = emailTextField.text, let password = passwdTextField.text{
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                self.showHome(result: result, error: error, provider: .basic)
                
            }
        }
    }
    
    @IBAction func loginUpButtonAction(_ sender: Any) {
        if  let email = emailTextField.text, let password = passwdTextField.text{
            
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                self.showHome(result: result, error: error, provider: .google)
            }
        }
    }
    
    private func showHome(result: AuthDataResult?, error: Error?, provider: ProviderType){
        if let result = result, error == nil{
            self.navigationController?.pushViewController(HomeViewController(email: result.user.email!, provider: provider), animated: true)
            print("Correcto")
            
        }else{
            
            let aleertController = UIAlertController(title: "Error", message: "Error en el usuario \(provider.rawValue)", preferredStyle: .alert)
            
            aleertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
            
            self.present(aleertController, animated: true, completion: nil)
    }
    
}
    @IBAction func googleButtonAction(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func facebookButtonAction(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.email], viewController: self) { (result) in
            switch result{
            
            case .success(granted: let granted, declined: let declined, token: let token):
                
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                
                Auth.auth().signIn(with: credential) { (result, error) in
                    
                    self.showHome(result: result, error: error, provider: .facebook)
                    
                }
            case .cancelled:
                break
            case .failed(_):
                break
            }
        }
    }
}

extension ViewController: GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil && user.authentication != nil{
            
            let credeential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            
            Auth.auth().signIn(with: credeential) { (result, error) in
                self.showHome(result: result, error: error, provider: .google)
            }
            
        }
    }
    
}
