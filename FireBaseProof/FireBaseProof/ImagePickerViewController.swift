//
//  ImagePickerViewController.swift
//  FireBaseProof
//
//  Created by Hernán Galileo Cabrera Garibaldi on 04/04/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseUI

class ImagePickerViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewSubida: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func didTapButton(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    @IBAction func ButtonSubida(_ sender: Any) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let ref = storageRef.child("imagen 1")
        imageViewSubida.sd_setImage(with: ref)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            imageView.image = image
            if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL{
                print(url.deletingPathExtension())
                uploadToCloud(fileURL: url, name: "imagen 1")
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
//    Subir imagenes
    func uploadToCloud(fileURL: URL, name: String){
        let storage = Storage.storage()
        let data = Data()
        let storageRef = storage.reference()
        let localFule  = fileURL
        let photoRef = storageRef.child(name)
        let uploadTask = photoRef.putFile(from: localFule, metadata: nil){(metadata, err) in
            guard let metadata = metadata else{
                print(err?.localizedDescription)
                return
            }
            print("Photo Upload!")
        }
    }
}
