//
//  Corrousel2ViewController.swift
//  FireBaseProof
//
//  Created by Hernán Galileo Cabrera Garibaldi on 07/04/21.
//

import UIKit
import CardSlider
import FirebaseFirestore

struct Item: CardSliderItem {
    var image: UIImage
    var rating: Int?
    var title: String
    var subtitle: String?
    var description: String?
}

class Corrousel2ViewController: UIViewController, CardSliderDataSource {
    
//    Variables para Firebase y el del item de data
    private let db = Firestore.firestore()
    var data = [Item]()

    @IBOutlet weak var myButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
//        Consultas a todos los cursos guardados en la base
        db.collection("courses").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        let url = URL(string:document.data()["urlImage"] as! String )!
                        if let datas = try? Data(contentsOf: url) {
                            
                            var descripcion1 = "Link: "
                            descripcion1.append(document.data()["LinkClass"] as! String)
                            descripcion1.append("\nDescription: ")
                            descripcion1.append(document.data()["description"] as! String)
                            
                            self.data.append(Item(image: UIImage(data: datas)!,
                                                  rating: nil,
                                                  title: document.data()["CourseName"] as! String,
                                                  subtitle: document.data()["Schedule"] as! String,
                                                  description: descripcion1))
                            }
                    }
                }
        }

        myButton.backgroundColor = .link
        myButton.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        
        let vc = CardSliderViewController.with(dataSource: self)
        vc.title = "Welcome"
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func item(for index: Int) -> CardSliderItem {
        return data[index]
    }
    
    func numberOfItems() -> Int {
        return data.count
    }
    
    
}
