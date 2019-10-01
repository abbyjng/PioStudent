//
//  ListingsTableViewController.swift
//  PioStudent
//
//  Created by Abigail Ng on 4/5/19.
//  Copyright © 2019 Abigail Ng. All rights reserved.
//

import UIKit
import Firebase

class ListingsTableViewController: UITableViewController, UITabBarControllerDelegate {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var navigationBarTitle: UINavigationItem!
    
    var ref: DatabaseReference!
    
    var requests: [Request] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController!.delegate = self
        
        ref = Database.database().reference()
        
        loadRequests()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func loadRequests() {
        requests = []
        if currentLogin.tutorTutee {
            navigationBarTitle.title = "Current Requests"
            addButton.isEnabled = false
            addButton.title = ""
            ref.child("requests").observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? NSDictionary {
                    for z in value {
                        for y in (z.1 as? NSDictionary)! {
                            var newPerson = Person(name: "", password: "", email: "", phoneNumber: "", grade: "", nhsStudent: false, tutorTutee: false)
                            self.ref.child("users").child((z.0 as? String)!).observeSingleEvent(of: .value, with: { (snapshot) in
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
                                }
                            }) { (error) in
                                print(error.localizedDescription)
                            }
                            var currRequest: Request = Request(person: newPerson, subject: "", className: "", teacher: "", daysFree: [], hoursFree: [])
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
                                }
                            }
                            self.requests.append(currRequest)
                        }
                    }
                }
                self.tableView.reloadData()
            }) { (error) in
                print(error.localizedDescription)
            }
        } else {
            navigationBarTitle.title = "Your Requests"
            addButton.isEnabled = true
            addButton.title = "+"
            ref.child("requests").child(currentLogin.uid).observeSingleEvent(of: .value, with: { (snapshot) in
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
                            }
                        }
                        self.requests.append(currRequest)
                    }
                    currentLogin.requests = self.requests
                    self.tableView.reloadData()
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
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
        if tabBarIndex == 0 {
            loadRequests()
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let requestDetailViewController = segue.destination as? RequestDetailViewController,
            let index = tableView.indexPathForSelectedRow?.row
             {
                requestDetailViewController.request = requests[index]
                requestDetailViewController.source = "listings"
        }
    }
    
    @IBAction func unwindToListings(unwindSegue: UIStoryboardSegue) {
        
    }
    
    @IBAction func add(_ unwindSegue: UIStoryboardSegue) {
        if let addRequestViewController = unwindSegue.source as? AddRequestViewController {
            requests.append(addRequestViewController.request!)
        }
    }
    
    @IBAction func cornerButtonPressed(_ unwindSegue: UIStoryboardSegue) {
        if let requestDetailViewController = unwindSegue.source as? RequestDetailViewController {
            if currentLogin.tutorTutee {
                var currentAccepted: NSDictionary = [:]
                ref.child("accepted").child(currentLogin.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let value = snapshot.value as? NSDictionary {
                        currentAccepted = value
                        var dictionary: [String: [String: String]] = [:]
                        for x in currentAccepted {
                            dictionary[x.0 as! String] = x.1 as? [String: String]
                        }
                        dictionary[requestDetailViewController.request!.className] = requestDetailViewController.request!.requestInfo
                        self.ref.child("accepted").child(currentLogin.uid).setValue(dictionary)
                    } else {
                        self.ref.child("accepted").child(currentLogin.uid).child(requestDetailViewController.request!.className).setValue(requestDetailViewController.request!.requestInfo)
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
                self.ref.child("requests").child(requestDetailViewController.request!.person.uid).child(requestDetailViewController.request!.className).removeValue()
                
            } else {
                self.ref.child("requests").child(currentLogin.uid).child(requestDetailViewController.request!.className).removeValue()
                currentLogin.requests.remove(at: requests.firstIndex(of: requestDetailViewController.request!)!)
            }
            if let index = requests.firstIndex(of: requestDetailViewController.request!) {
                requests.remove(at: index)
            }
        }
    }
}
