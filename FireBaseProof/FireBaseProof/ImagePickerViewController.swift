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
//        Nombre de la imagen por Fechas
        let date = Date()
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "es_Es")
        dateFormater.dateStyle = .medium
        dateFormater.timeStyle = .medium
        let names = dateFormater.string(from: date)
        
        let storage = Storage.storage()
        let data = Data()
        let storageRef = storage.reference()
        let localFule  = fileURL
//        Guardar las imagenes en una carpeta llamada images/
        let photoRef = storageRef.child("images/" + names)
        
        let uploadTask = photoRef.putFile(from: localFule, metadata: nil){(metadata, err) in
            guard let metadata = metadata else{
                print(err?.localizedDescription)
                return
            }
            print("Photo Upload!")
//            Obtener el nombre de los items para el corrouseel
            let storageReference = storage.reference().child("images/")
            storageReference.listAll { (result, error) in
              if let error = error {
                print("Error")
              }
              for prefix in result.prefixes {
                // The prefixes under storageReference.
                // You may call listAll(completion:) recursively on them.
              }
              for item in result.items {
                print("Reesultado 1: ", item.name)
              }
            }
        }
    }
    
    
}
