//
//  HomeViewController.swift
//  FireBaseProof
//
//  Created by Hernán Galileo Cabrera Garibaldi on 30/03/21.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FacebookLogin
import FirebaseFirestore


enum ProviderType:String {
    case basic
    case google
    case facebook
}

class HomeViewController: UIViewController {

//    Area de labels
    @IBOutlet weak var EmailLaber: UILabel!
    
    @IBOutlet weak var ProviderLabel: UILabel!
    
    @IBOutlet weak var closeSessionButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var homeworkTextField: UITextField!
    
    private let email: String
    private let provider: ProviderType
    private let db = Firestore.firestore()
    
    init(email: String, provider: ProviderType) {
        self.email = email
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Inicio"
//
        navigationItem.setHidesBackButton(true, animated: false)
        
        EmailLaber.text = email
        ProviderLabel.text = provider.rawValue
        
//        Guardamos datos del usuario
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "email")
        defaults.set(provider.rawValue, forKey: "Provider")
        defaults.synchronize()
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        view.endEditing(true)
        db.collection("users").document(email).setData([
            "provider": provider.rawValue,
            "age": ageTextField.text ?? "",
            "homework": homeworkTextField.text ?? ""
        ])
    }
    
    @IBAction func getButtonAction(_ sender: Any) {
        view.endEditing(true)
        db.collection("users").document(email).getDocument { (documentSnapshot, error) in
            if let document = documentSnapshot, error == nil{
//                if let address = document.get("address") as? S
                print("")
            }
        }
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func closeSessionButtonAction(_ sender: Any) {
//        Borrando datos del usuaroo ya logeado
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "email")
        defaults.set(provider.rawValue, forKey: "Provider")
        defaults.synchronize()
        
        switch provider {
        case .basic:
            firebaseLogOut()
            
        case .google:
            GIDSignIn.sharedInstance()?.signOut()
            firebaseLogOut()
            
        case .facebook:
            LoginManager().logOut()
            firebaseLogOut()
        }
        navigationController?.popViewController(animated: true)
}
    private func firebaseLogOut(){
        do {
            try Auth.auth().signOut()
        } catch  {
            
        }
    }
}
