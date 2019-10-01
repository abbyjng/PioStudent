//
//  Person.swift
//  PioStudent
//
//  Created by Abigail Ng on 4/6/19.
//  Copyright © 2019 Abigail Ng. All rights reserved.
//

import Foundation

class Person: Equatable {
    var uid: String
    var name: String
    var password: String
    var email: String
    var phoneNumber: String
    var grade: String
    var nhsStudent: Bool
    var tutorTutee: Bool
    var requests: [Request]
    var accepted: [Request]
    
    static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    var arrayInfo: [String: String] {
        return ["name": self.name, "email": self.email, "phoneNumber": self.phoneNumber, "grade": self.grade, "nhsStudent":  "\(self.nhsStudent)", "tutorTutee": "\(self.tutorTutee)"]
    }
    
    var requestsInfo: [String: [String: String]] {
        var info: [String: [String: String]] = [:]
        for x in requests {
            info[x.className] = x.requestInfo
        }
        return info
    }
    
    var acceptedInfo: [String: [String: String]] {
        var info: [String: [String: String]] = [:]
        for x in accepted {
            info[x.className] = x.requestInfo
        }
        return info
    }
    
    
    
    init(name: String, password: String, email: String, phoneNumber: String, grade: String, nhsStudent: Bool, tutorTutee: Bool) {
        self.uid = ""
        self.name = name
        self.password = password
        self.email = email
        self.phoneNumber = phoneNumber
        self.grade = grade
        self.nhsStudent = nhsStudent
        self.tutorTutee = tutorTutee
        self.requests = []
        self.accepted = []
    }
}

var currentLogin = Person(name: "", password: "", email: "", phoneNumber: "", grade: "", nhsStudent: false, tutorTutee: false)

var loggedIn = false
