//
//  AddRequestViewController.swift
//  PioStudent
//
//  Created by Abigail Ng on 4/5/19.
//  Copyright © 2019 Abigail Ng. All rights reserved.
//

import UIKit
import Firebase

class AddRequestViewController: UIViewController {
    
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var classTextField: UITextField!
    @IBOutlet weak var teacherTextField: UITextField!
    
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
    @IBOutlet weak var switch4EL: UISwitch!
    @IBOutlet weak var switch4LL: UISwitch!
    @IBOutlet weak var switch5: UISwitch!
    @IBOutlet weak var switch6: UISwitch!
    
    lazy var hourSwitches: [UISwitch] = [switch1, switch2, switch3, switch4LL, switch4EL, switch5, switch6]
    var hours = ["1st", "2nd", "3rd", "4thLL", "4thEL", "5th", "6th"]
    
    var ref: DatabaseReference!
    
    var request: Request?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        for daySwitch in daySwitches {
            daySwitch.isOn = false
        }
        
        for hourSwitch in hourSwitches {
            hourSwitch.isOn = false
        }
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender as? UIBarButtonItem)!.title == "Add"  {
            var onDays: [String] = []
            for daySwitch in daySwitches {
                if daySwitch.isOn {
                    onDays.append(days[daySwitches.firstIndex(of: daySwitch)!])
                }
            }
            var onHours: [String] = []
            for hourSwitch in hourSwitches {
                if hourSwitch.isOn {
                    onHours.append(hours[hourSwitches.firstIndex(of: hourSwitch)!])
                }
            }
            request = Request(person: currentLogin, subject: subjectTextField.text!, className: classTextField.text!, teacher: teacherTextField.text!, daysFree: onDays, hoursFree: onHours)
            if currentLogin.requests.count <= 7 {
                currentLogin.requests.append(request!)
                self.ref.child("requests").child(currentLogin.uid).setValue(currentLogin.requestsInfo)
            } else {
                let alertController = UIAlertController(title: "You have reached the maximum allowed number of requests.", message: nil, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                alertController.popoverPresentationController?.sourceView = (sender as! UIView)
                
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    

}
