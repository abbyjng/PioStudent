//
//  Request.swift
//  PioStudent
//
//  Created by Abigail Ng on 4/5/19.
//  Copyright © 2019 Abigail Ng. All rights reserved.
//

import Foundation

class Request: Equatable {
    var person: Person
    var subject: String
    var className: String
    var teacher: String
    var daysFree: [String]
    var hoursFree: [String]
    
    var daysFreeString: String {
        var final = ""
        for day in daysFree {
            final += day + " "
        }
        return final
    }
    
    var hoursFreeString: String {
        var final = ""
        for hour in hoursFree {
            final += hour + " "
        }
        return final
    }
    
    static func daysArrayToString(daysString: String) -> [String] {
        var arrFinal: [String] = []
        var currStr = ""
        for x in daysString {
            if x != " " {
                currStr += "\(x)"
            } else {
                arrFinal.append(currStr)
                currStr = ""
            }
        }
        return arrFinal
    }
    
    static func hoursArrayToString(hoursString: String) -> [String] {
        var arrFinal: [String] = []
        var currStr = ""
        for x in hoursString {
            if x != " " {
                currStr += "\(x)"
            } else {
                arrFinal.append(currStr)
                currStr = ""
            }
        }
        return arrFinal
    }
    
    var requestInfo: [String: String] {
        return ["uid": person.uid, "subject": subject, "className": className, "teacher": teacher, "daysFree": daysFreeString, "hoursFree": hoursFreeString]
    }
    
    init(person: Person, subject: String, className: String, teacher: String, daysFree: [String], hoursFree: [String]) {
        self.person = person
        self.subject = subject
        self.className = className
        self.teacher = teacher
        self.daysFree = daysFree
        self.hoursFree = hoursFree
    }
    
    static func ==(lhs: Request, rhs: Request) -> Bool {
        return lhs.person.name == rhs.person.name && lhs.subject == rhs.subject && lhs.className == rhs.className && lhs.teacher == rhs.teacher
    }
}
