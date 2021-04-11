//
//  CorrouselViewController.swift
//  FireBaseProof
//
//  Created by Hernán Galileo Cabrera Garibaldi on 04/04/21.
//

import UIKit
import iCarousel
import Firebase
import FirebaseFirestore
import FirebaseUI

class CorrouselViewController: UIViewController, iCarouselDataSource {
    
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 4
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 200, width: self.view.frame.size.width/1.4, height: 300))
//        view.backgroundColor = .blue
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let ref = storageRef.child("images/4 abr 2021 4:50:47")
//
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.sd_setImage(with: ref)
        view.addSubview(imageView)
        return view
    }
    
    let myCarousel: iCarousel = {
        let view = iCarousel()
        view.type = .coverFlow
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let uno = imagesName()
        print(uno)
        view.addSubview(myCarousel)
        myCarousel.dataSource = self
        myCarousel.frame = CGRect(x: 0, y: 200, width: view.frame.size.width, height: 400)
        // Do any additional setup after loading the view.
    }
}
func imagesName() -> Array<String> {
    let storage = Storage.storage()
    var nombres = [String]()
    let storageReference = storage.reference().child("images/")

    storageReference.listAll { (result, error) in
        if let error = error {
          print(error)
        }
        for prefix in result.prefixes {
          // The prefixes under storageReference.
          // You may call listAll(completion:) recursively on them.
            print(prefix)
        }
      for item in result.items {
        nombres.append(item.name)
        print("Reesultado 1: ", nombres)
        
      }
        print("Tienes: \(nombres.count) elementos")
    }
    print("Resultado final : ", nombres)
    return nombres
}
