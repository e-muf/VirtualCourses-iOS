//
//  ViewController.swift
//  VirtualCourses
//
//  Created by Emanuel Flores Martínez on 31/03/21.
//

import UIKit

import Firebase

class CoursesViewController: UIViewController {

    @IBOutlet weak var greetLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    private let db = Firestore.firestore()
    var courses: [Course] = []
    let cellScale: CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        greeting()
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScale)
        let cellHeight = floor(screenSize.height * cellScale)
        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insetY = (view.bounds.height - cellHeight) / 10.0
        
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        collectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        self.getAllCoures()
        
    }
    
    
    func getAllCoures() {
            let userEmail = Auth.auth().currentUser?.email

            
            db.collection("courses").whereField("owner", isEqualTo: userEmail!)
                .addSnapshotListener{ (querySnapshot, error) in
                    self.courses.removeAll()
                    if let error = error {
                        print(error)
                    }else {
                        
                        for document in querySnapshot!.documents {
                            let course = document.data()
                            let courseName = course["courseName"] as! String
                            let description = course["description"] as! String
                            let schedule = course["schedule"] as! String
                            let linkClass = course["linkClass"] as! String
                            
                            let urlImage = URL(string: course["urlImage"] as! String)
                            guard let data = try? Data(contentsOf: urlImage!) else { return }
                            
                            print("AQUI:", courseName, linkClass ?? "")
                            
                            self.courses.append(Course(courseName: courseName,
                                                       description: description,
                                                       schedule: schedule,
                                                       linkClass: linkClass,
                                                       imageCourse: UIImage(data: data)!))
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        
                        }
                        
                    }
            }
        }
    func greeting() {
        CoursesService.getName { (name) in
            if let name = name{
                print("Este es el nombre: \(name)")
                self.greetLabel.text = "Hola, \(name)"
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print(signOutError)
        }
    }
    
}

// MARK: - UICollectionViewDataSource

extension CoursesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseCollectionViewCell", for: indexPath) as! CourseCollectionViewCell
        let course = courses[indexPath.item]
        
        cell.course = course
        return cell
    }
    
}
