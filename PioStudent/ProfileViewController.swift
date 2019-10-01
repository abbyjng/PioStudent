//
//  ProfileViewController.swift
//  PioStudent
//
//  Created by Abigail Ng on 4/6/19.
//  Copyright © 2019 Abigail Ng. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    var ref: DatabaseReference!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var gradeTextField: UITextField!
    @IBOutlet weak var nhsStudentSwitch: UISwitch!
    @IBOutlet weak var tutorTuteeSwitch: UISwitch!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        nameTextField.isEnabled = false
        passwordTextField.isEnabled = false
        emailTextField.isEnabled = false
        phoneNumberTextField.isEnabled = false
        gradeTextField.isEnabled = false
        nhsStudentSwitch.isEnabled = false
        tutorTuteeSwitch.isEnabled = false
        
        nameTextField.text = currentLogin.name
        passwordTextField.text = currentLogin.password
        emailTextField.text = currentLogin.email
        phoneNumberTextField.text = currentLogin.phoneNumber
        gradeTextField.text = currentLogin.grade
        nhsStudentSwitch.isOn = currentLogin.nhsStudent
        tutorTuteeSwitch.isOn = currentLogin.tutorTutee
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tutorTuteeSwitchFlipped(_ sender: Any) {
        if tutorTuteeSwitch.isOn != currentLogin.tutorTutee {
            let alertController = UIAlertController(title: "Are you sure? This action will delete all of your requests. Switch back before saving if you would like to cancel.", message: nil, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            alertController.popoverPresentationController?.sourceView = (sender as! UIView)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        if editButton.title! == "Edit" {
            nameTextField.isEnabled = true
            emailTextField.isEnabled = true
            phoneNumberTextField.isEnabled = true
            gradeTextField.isEnabled = true
            nhsStudentSwitch.isEnabled = true
            tutorTuteeSwitch.isEnabled = true
            logoutButton.isHidden = true
            editButton.title = "Done"
        } else {
            nameTextField.isEnabled = false
            emailTextField.isEnabled = false
            phoneNumberTextField.isEnabled = false
            gradeTextField.isEnabled = false
            nhsStudentSwitch.isEnabled = false
            tutorTuteeSwitch.isEnabled = false
            logoutButton.isHidden = false
            editButton.title = "Edit"
            
            if currentLogin.tutorTutee != tutorTuteeSwitch.isOn {
                currentLogin.requests = []
                self.ref.child("requests").child(currentLogin.uid).removeValue()
                currentLogin.accepted = []
            }
            
            currentLogin.name = nameTextField.text!
            currentLogin.password = passwordTextField.text!
            currentLogin.email = emailTextField.text!
            currentLogin.phoneNumber = phoneNumberTextField.text!
            currentLogin.grade = gradeTextField.text!
            currentLogin.nhsStudent = nhsStudentSwitch.isOn
            currentLogin.tutorTutee = tutorTuteeSwitch.isOn
            
            self.ref.child("users").child(currentLogin.uid).setValue(currentLogin.arrayInfo)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func logoutButtonPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            currentLogin = Person(name: "", password: "", email: "", phoneNumber: "", grade: "", nhsStudent: false, tutorTutee: false)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}
