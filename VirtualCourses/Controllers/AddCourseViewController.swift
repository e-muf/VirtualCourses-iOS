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
            if courseName == "" || schedule == "" || linkClass == "" || description == "" || self.pathImage?.absoluteString == nil{
                showAlert()
            }else{
                CoursesService.uploadToCloud(fileURL: self.pathImage!) { (url) in
                    if let urlImage = url {
                        self.saveToDB(courseName, schedule, linkClass, description, urlImage, owner)
                    }
                }
            }
        }
        navigationController?.popViewController(animated: true)
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
    func showAlert(){
        let alert = UIAlertController(title: "¡¡¡Atencion!!!", message: "Te falta Llenar algún campo\n¡Por favor Chécalo!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
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
