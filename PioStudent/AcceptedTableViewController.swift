//
//  AcceptedTableViewController.swift
//  PioStudent
//
//  Created by Abigail Ng on 5/15/19.
//  Copyright © 2019 Abigail Ng. All rights reserved.
//

import UIKit
import Firebase

class AcceptedTableViewController: UITableViewController, UITabBarControllerDelegate {

    var ref: DatabaseReference!
    
    var requests: [Request] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tabBarController!.delegate = self
        
        ref = Database.database().reference()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return requests.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell", for: indexPath)
        let request = requests[indexPath.row]
        cell.textLabel?.text = "\(request.subject) - \(request.className) - \(request.teacher)"
        
        cell.detailTextLabel?.text = "Days: "
        if !request.daysFree.isEmpty {
            for day in request.daysFree {
                cell.detailTextLabel?.text! += day + " "
                
            }
        } else {
            cell.detailTextLabel?.text! += "none "
        }
        
        cell.detailTextLabel?.text! += "|| Hours: "
        if !request.hoursFree.isEmpty {
            for hour in request.hoursFree {
                cell.detailTextLabel?.text! += hour + " "
            }
        } else {
            cell.detailTextLabel?.text! += "none"
        }
        
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requests = []
        if !currentLogin.tutorTutee {
            ref.child("accepted").observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? NSDictionary {
                    for z in value {
                        for y in (z.1 as? NSDictionary)! {
                            var correct = false
                            var currRequest: Request = Request(person: Person(name: "", password: "", email: "", phoneNumber: "", grade: "", nhsStudent: false, tutorTutee: false), subject: "", className: "", teacher: "", daysFree: [], hoursFree: [])
                            for x in (y.1 as? NSDictionary)! {
                                if x.0 as! String == "subject" {
                                    currRequest.subject = x.1 as? String ?? ""
                                } else if x.0 as! String == "className" {
                                    currRequest.className = x.1 as? String ?? ""
                                } else if x.0 as! String == "teacher" {
                                    currRequest.teacher = x.1 as? String ?? ""
                                } else if x.0 as! String == "daysFree" {
                                    currRequest.daysFree = Request.daysArrayToString(daysString: x.1 as? String ?? "")
                                } else if x.0 as! String == "hoursFree" {
                                    currRequest.hoursFree = Request.hoursArrayToString(hoursString: x.1 as? String ?? "")
                                } else if x.0 as! String == "uid" {
                                    if x.1 as? String ?? "" == currentLogin.uid {
                                        correct = true
                                        var newPerson = Person(name: "", password: "", email: "", phoneNumber: "", grade: "", nhsStudent: false, tutorTutee: false)
                                        self.ref.child("users").child(z.0 as? String ?? "").observeSingleEvent(of: .value, with: { (snapshot) in
                                            if let value = snapshot.value as? NSDictionary {
                                                newPerson.uid = (z.0 as? String)!
                                                newPerson.name = value["name"] as? String ?? ""
                                                newPerson.password = value["password"] as? String ?? ""
                                                newPerson.email = value["email"] as? String ?? ""
                                                newPerson.phoneNumber = value["phoneNumber"] as? String ?? ""
                                                newPerson.grade = value["grade"] as? String ?? ""
                                                if value["nhsStudent"] as? String ?? "" == "true" {
                                                    newPerson.nhsStudent = true
                                                } else {
                                                    newPerson.nhsStudent = false
                                                }
                                                if value["tutorTutee"] as? String ?? "" == "true" {
                                                    newPerson.tutorTutee = true
                                                } else {
                                                    newPerson.tutorTutee = false
                                                }
                                                currRequest.person = newPerson
                                            }
                                        }) { (error) in
                                            print(error.localizedDescription)
                                        }
                                    }
                                }
                            }
                            if correct {
                                self.requests.append(currRequest)
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }) { (error) in
                print(error.localizedDescription)
            }
        } else {
            ref.child("accepted").child(currentLogin.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? NSDictionary {
                    for y in value {
                        var currRequest: Request = Request(person: currentLogin, subject: "", className: "", teacher: "", daysFree: [], hoursFree: [])
                        for x in (y.1 as? NSDictionary)! {
                            if x.0 as! String == "subject" {
                                currRequest.subject = x.1 as? String ?? ""
                            } else if x.0 as! String == "className" {
                                currRequest.className = x.1 as? String ?? ""
                            } else if x.0 as! String == "teacher" {
                                currRequest.teacher = x.1 as? String ?? ""
                            } else if x.0 as! String == "daysFree" {
                                currRequest.daysFree = Request.daysArrayToString(daysString: x.1 as? String ?? "")
                            } else if x.0 as! String == "hoursFree" {
                                currRequest.hoursFree = Request.hoursArrayToString(hoursString: x.1 as? String ?? "")
                            } else if x.0 as! String == "uid" {
                                var newPerson = Person(name: "", password: "", email: "", phoneNumber: "", grade: "", nhsStudent: false, tutorTutee: false)
                                self.ref.child("users").child(x.1 as? String ?? "").observeSingleEvent(of: .value, with: { (snapshot) in
                                    if let value = snapshot.value as? NSDictionary {
                                        newPerson.uid = (x.1 as? String)!
                                        newPerson.name = value["name"] as? String ?? ""
                                        newPerson.password = value["password"] as? String ?? ""
                                        newPerson.email = value["email"] as? String ?? ""
                                        newPerson.phoneNumber = value["phoneNumber"] as? String ?? ""
                                        newPerson.grade = value["grade"] as? String ?? ""
                                        if value["nhsStudent"] as? String ?? "" == "true" {
                                            newPerson.nhsStudent = true
                                        } else {
                                            newPerson.nhsStudent = false
                                        }
                                        if value["tutorTutee"] as? String ?? "" == "true" {
                                            newPerson.tutorTutee = true
                                        } else {
                                            newPerson.tutorTutee = false
                                        }
                                        currRequest.person = newPerson
                                    }
                                }) { (error) in
                                    print(error.localizedDescription)
                                }
                            }
                        }
                        self.requests.append(currRequest)
                    }
                    currentLogin.accepted = self.requests
                    self.tableView.reloadData()
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
        tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 1 {
            tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let requestDetailViewController = segue.destination as? RequestDetailViewController,
            let index = tableView.indexPathForSelectedRow?.row
        {
            requestDetailViewController.request = requests[index]
            requestDetailViewController.source = "accepted"
        }
    }
    
}
