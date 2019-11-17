//
//  globalVariables.swift
//  Wojtal_Oscar_Reminders
//
//  Created by Os on 2019-04-22.
//  Copyright © 2019 Os. All rights reserved.
//

import Foundation
import UIKit

var globalCategoriesList: [ReminderCategory] = []

var isBeingEdited = false
var selectedCategory: ReminderCategory?
var selectedCategoryIndex: Int?
var selectedItem: items?
var selectedItemIndex: Int?

var didSelectItem: Bool = false

enum itemIcons: String, Codable {
    case general
    case work
    case social
    case school
    case home               //Create enums for all the categories
    case family
    case vacation
    case groceries
    case event
}

func itemIconToPicture(whichIcon: itemIcons) -> UIImage {
    
    switch whichIcon {
    case .general:
        return UIImage(named: "023-notification.png")!
    case .social:
        return UIImage(named: "020-message.png")!
    case .school:
        return UIImage(named: "010-puzzle.png")!
    case .home:
        return UIImage(named: "019-market.png")!
    case .family:          // when the app refrences an enum to get an image, this switch statemnt figures out what photo is shown
        return UIImage(named: "011-group.png")!
    case .vacation:
        return UIImage(named: "035-weather.png")!
    case .groceries:
        return UIImage(named: "003-edit.png")!
    case .event:
        return UIImage(named: "004-event.png")!
    case .work:
        return UIImage(named: "036-suitcase.png")!
    }
}

func bubbleSort(array: inout [Int]) -> [Int]{
    for index in 0..<array.count {
        for index2 in 1..<array.count - index {
            if array[index2] < array[index2-1] {
                let tmp = array[index2-1]
                array[index2-1] = array[index2]
                array[index2] = tmp
            }
        }
    }
    return array
}

struct ReminderCategory: Codable, CustomStringConvertible, Equatable {
    
    static func == (lhs: ReminderCategory, rhs: ReminderCategory) -> Bool {
        if(lhs.name == rhs.name && lhs.iconString == rhs.iconString) {
            return true
            } else {
            return false
        }
    }
    
    var name: String
    //var positionInList: Int
    var iconString: itemIcons
    var itemsInCategory : [items] = []
    var description: String
    
    
    init(name:String, iconString:itemIcons) {
        self.name = name
        self.iconString = iconString
        self.description = name
    }
    
    
}

struct items:Codable, Equatable {
    static func == (lhs: items, rhs: items) -> Bool {
        if lhs.description == rhs.description && lhs.activatedAlarm == rhs.activatedAlarm && lhs.dateOfAlarm == rhs.dateOfAlarm {
            return true
        }else {
            return false
        }
    }
    
    let description: String
    //var positionInCategory: Int //Struct for reminders in categories
    var activatedAlarm = false
    var dateOfAlarm: Date?
}

let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let archiveURL = documentsDirectory.appendingPathComponent("ReminderCategory_test").appendingPathExtension("plist")

//create encoder to save data
let propertyListEncoder = PropertyListEncoder()

//function to save my categories
func save(){
    let encodedList = try? propertyListEncoder.encode(globalCategoriesList)
    try? encodedList?.write(to: archiveURL, options: .noFileProtection)
}

//create decoder to recover saved data
let propertyListDecoder = PropertyListDecoder()

//function to retrieve saved data
func retrieve(){
    if let retrievedListData = try? Data(contentsOf: archiveURL),let decodedList = try? propertyListDecoder.decode([ReminderCategory].self, from: retrievedListData){
        globalCategoriesList = decodedList
}
}

