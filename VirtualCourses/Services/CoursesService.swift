//
//  CoursesService.swift
//  VirtualCourses
//
//  Created by Emanuel Flores Martínez on 10/04/21.
//

import Firebase
import FirebaseStorage

struct CoursesService {
    private static let db = Firestore.firestore()
    
    static func getAllCoures(completion: @escaping([Course]) -> Void) {
        var coursesOwner: [Course] = []
        let userEmail = Auth.auth().currentUser?.email
    
        db.collection("courses").whereField("owner", isEqualTo: userEmail!)
            .addSnapshotListener{ (querySnapshot, error) in
                if let error = error {
                    print(error)
                }else {
                
                    for document in querySnapshot!.documents {
                        let course = document.data()
                        let courseName = course["courseName"] as! String
                        let description = course["description"] as! String
                        let schedule = course["schedule"] as! String
                        let linkClass = URL(string: course["linkClass"] as! String)
                        
                        let urlImage = URL(string: course["urlImage"] as! String)
                        guard let data = try? Data(contentsOf: urlImage!) else { return }
                        
                        coursesOwner.append(Course(courseName: courseName,
                                                   description: description,
                                                   schedule: schedule,
                                                   linkClass: linkClass!,
                                                   imageCourse: UIImage(data: data)!))
                    }
                    
                    completion(coursesOwner)
                }
        }
    }
    
    static func uploadToCloud(fileURL: URL, completion:@escaping((String?) -> ())) {
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
}
