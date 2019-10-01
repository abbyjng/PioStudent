//
//  CreateAccountViewController.swift
//  PioStudent
//
//  Created by Abigail Ng on 4/6/19.
//  Copyright © 2019 Abigail Ng. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var gradeTextField: UITextField!
    @IBOutlet weak var nhsStudentSwitch: UISwitch!
    @IBOutlet weak var tutorTuteeSwitch: UISwitch!
    @IBOutlet weak var accessCodeTextField: UITextField!
    
    var ref: DatabaseReference!
    
    var handle: AuthStateDidChangeListenerHandle!
    
    lazy var textFields: [UITextField] = [nameTextField, passwordTextField, confirmPasswordTextField, emailTextField, phoneNumberTextField, gradeTextField]
    
    override func viewWillDisappear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if currentLogin.uid != "" {
                self.ref.child("users").child(currentLogin.uid).setValue(currentLogin.arrayInfo)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        nhsStudentSwitch.isOn = false
        tutorTuteeSwitch.isOn = false
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "The access code is Pioneer's school code, as given in standardized testing. See a teacher if further assistance is required.", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.popoverPresentationController?.sourceView = (sender as! UIView)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        var passed = true
        for field in textFields {
            if field.text == "" {
                let alertController = UIAlertController(title: "Please fill in all fields.", message: nil, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                alertController.popoverPresentationController?.sourceView = (sender as! UIView)
                
                present(alertController, animated: true, completion: nil)
                passed = false
            }
        }

        if passwordTextField.text!.count < 6 {
            let alertController = UIAlertController(title: "Your password must be 6 characters or longer.", message: nil, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            alertController.popoverPresentationController?.sourceView = (sender as! UIView)
            
            present(alertController, animated: true, completion: nil)
            passed = false
        }
        else if passwordTextField.text != confirmPasswordTextField.text {
            let alertController = UIAlertController(title: "Your passwords do not match.", message: nil, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            alertController.popoverPresentationController?.sourceView = (sender as! UIView)
            
            present(alertController, animated: true, completion: nil)
            passed = false
        }
        if accessCodeTextField.text! != "230088" {
            let alertController = UIAlertController(title: "The access code entered is incorrect.", message: nil, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            alertController.popoverPresentationController?.sourceView = (sender as! UIView)
            
            present(alertController, animated: true, completion: nil)
            passed = false
        }
        if passed {
            currentLogin = Person(name: nameTextField.text!, password: passwordTextField.text!, email: emailTextField.text!, phoneNumber: phoneNumberTextField.text!, grade: gradeTextField.text!, nhsStudent: nhsStudentSwitch.isOn, tutorTutee: tutorTuteeSwitch.isOn)
            Auth.auth().createUser(withEmail: currentLogin.email, password: currentLogin.password) { (user, error) in
                let user = Auth.auth().currentUser
                if let user = user {
                    print("the current login has received its uid")
                    currentLogin.uid = user.uid
                    self.performSegue(withIdentifier: "createAccount", sender: nil)
                }
            }
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

}
