//
//  CourseCollectionViewCell.swift
//  VirtualCourses
//
//  Created by Emanuel Flores Martínez on 11/04/21.
//

import UIKit

class CourseCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var backgroundColorView: UIView!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    
    var course: Course! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        if let course = course {
            courseImageView.image = course.imageCourse
            courseNameLabel.text = course.courseName
            scheduleLabel.text = course.schedule
            backgroundColorView.backgroundColor = UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)
        } else {
            courseImageView = nil
            courseNameLabel.text = nil
            scheduleLabel.text = nil
            backgroundColorView.backgroundColor = nil
        }
        
        backgroundColorView.layer.cornerRadius = 10.0
        backgroundColorView.layer.masksToBounds = true
        courseImageView.layer.cornerRadius = 10.0
        courseImageView.layer.masksToBounds = true
    }
}
