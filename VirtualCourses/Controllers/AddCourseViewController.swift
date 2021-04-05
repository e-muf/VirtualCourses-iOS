//
//  AddCourseViewController.swift
//  VirtualCourses
//
//  Created by Emanuel Flores Martínez on 05/04/21.
//

import UIKit

import FirebaseFirestore
import FirebaseStorage
import Firebase

class AddCourseViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var courseNameTextField: UITextField!
    @IBOutlet weak var scheduleTextField: UITextField!
    @IBOutlet weak var linkClassTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var courseImageView: UIImageView!
    
    private let db = Firestore.firestore()
    var pathImage: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func uploadToCloud(fileURL: URL, completion:@escaping((String?) -> ())) {
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "es_Es")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        let name = dateFormatter.string(from: date)
        let storage = Storage.storage().reference()
        
        storage.child("images/\(name)").putFile(from: fileURL, metadata: nil){ (metadata, err) in
            if let error = err {
                print(error)
            }
            
            print("Photo Upload!")
            
            storage.child("images/\(name)").downloadURL(completion: { url, error in
                guard let url = url, error == nil else{
                    return
                }
                
                completion(url.absoluteString)
            })
        }
    }
    
    @IBAction func addImagePressed(_ sender: Any) {
        // let storage = Storage.storage()
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @IBAction func saveCoursePressed(_ sender: Any) {
        if let courseName = courseNameTextField.text,
           let schedule = scheduleTextField.text,
           let linkClass = linkClassTextField.text,
           let description = descriptionTextField.text,
           let owner = Auth.auth().currentUser?.email {
            
            uploadToCloud(fileURL: self.pathImage!) { (url) in
                if let urlImage = url {
                    self.saveToDB(courseName, schedule, linkClass, description, urlImage, owner)
                }
            }
        }
        
    }
    
    func saveToDB(_ courseName: String, _ schedule: String, _ linkClass: String, _ description: String, _ urlImage: String, _ owner: String) {
        self.db.collection("courses").addDocument(data: [
            "courseName": courseName,
            "schedule": schedule,
            "linkClass": linkClass,
            "description": description,
            "urlImage": urlImage,
            "owner": owner
        ]) { (error) in
            if let e = error {
                print(e)
            } else {
                print("Data successfully upload.")
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension AddCourseViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL{
                self.pathImage = url
            }
            
            DispatchQueue.main.async {
                self.courseImageView.image = image
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
