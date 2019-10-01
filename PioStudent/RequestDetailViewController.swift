//
//  RequestDetailViewController.swift
//  PioStudent
//
//  Created by Abigail Ng on 4/6/19.
//  Copyright © 2019 Abigail Ng. All rights reserved.
//

import UIKit
import Firebase

class RequestDetailViewController: UIViewController {
    
    var ref: DatabaseReference!

    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    @IBOutlet weak var cornerButton: UIBarButtonItem!
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    
    @IBOutlet weak var contactInfoLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailStackView: UIStackView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var phoneNumberStackView: UIStackView!
    
    @IBOutlet weak var mSwitch: UISwitch!
    @IBOutlet weak var tuSwitch: UISwitch!
    @IBOutlet weak var wSwitch: UISwitch!
    @IBOutlet weak var thSwitch: UISwitch!
    @IBOutlet weak var fSwitch: UISwitch!
    
    lazy var daySwitches: [UISwitch] = [mSwitch, tuSwitch, wSwitch, thSwitch, fSwitch]
    var days = ["M", "Tu", "W", "Th", "F"]
    
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var switch2: UISwitch!
    @IBOutlet weak var switch3: UISwitch!
    @IBOutlet weak var switch4LL: UISwitch!
    @IBOutlet weak var switch4EL: UISwitch!
    @IBOutlet weak var switch5: UISwitch!
    @IBOutlet weak var switch6: UISwitch!
    
    lazy var hourSwitches: [UISwitch] = [switch1, switch2, switch3, switch4LL, switch4EL, switch5, switch6]
    var hours = ["1st", "2nd", "3rd", "4thLL", "4thEL", "5th", "6th"]
    
    var request: Request?
    
    var source: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        let defaultColor = switch1.tintColor
        if source == "accepted" {
            cornerButton.title = ""
            cornerButton.isEnabled = false
            emailStackView.isHidden = false
            phoneNumberStackView.isHidden = false
            contactInfoLabel.isHidden = false
            emailLabel.text = request!.person.email
            phoneNumberLabel.text = request!.person.phoneNumber
        } else if currentLogin.tutorTutee {
            cornerButton.title = "Take request"
            cornerButton.tintColor = defaultColor
            cornerButton.isEnabled = true
            emailStackView.isHidden = true
            phoneNumberStackView.isHidden = true
            contactInfoLabel.isHidden = true
        } else {
            cornerButton.title = "Delete"
            cornerButton.tintColor = UIColor.red
            cornerButton.isEnabled = true
            emailStackView.isHidden = true
            phoneNumberStackView.isHidden = true
            contactInfoLabel.isHidden = true
        }
        
        for daySwitch in daySwitches {
            daySwitch.isOn = false
            daySwitch.isEnabled = false
        }
        for hourSwitch in hourSwitches {
            hourSwitch.isOn = false
            hourSwitch.isEnabled = false
        }
        
        if currentLogin.tutorTutee {
            navigationTitle.title = request?.person.name
        } else {
            navigationTitle.title = request?.className
        }
        
        subjectLabel.text = request?.subject
        classLabel.text = request?.className
        teacherLabel.text = request?.teacher
        for day in request!.daysFree {
            daySwitches[days.firstIndex(of: day)!].isOn = true
        }
        for hour in request!.hoursFree {
            hourSwitches[hours.firstIndex(of: hour)!].isOn = true
        }
            
    }
    

}
