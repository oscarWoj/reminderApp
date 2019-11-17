//
//  ListEditViewController.swift
//  Wojtal_Oscar_Reminders
//
//  Created by Os on 2019-04-25.
//  Copyright © 2019 Os. All rights reserved.
//

import UIKit
import UserNotifications

class ListEditViewController: UIViewController {
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindToList", sender: self)
    }//Segues back without saving data
    
    @IBOutlet weak var titleOfReminderOutlet: UITextField!
    @IBOutlet weak var UISwitchOutlet: UISwitch!    //Initialize objects in the viewController
    @IBOutlet weak var UIDatePickerOutlet: UIDatePicker!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        retrieve()                      //Retreive data and set the name 
        self.title = selectedCategory?.name
        
        if didSelectItem == true {            // If the user is editing a list item, set the default value of the UISwitch to whatever the list Item
            UISwitchOutlet.setOn((selectedItem?.activatedAlarm)!, animated: true)
            titleOfReminderOutlet.text = selectedItem?.description
            
            if selectedItem?.activatedAlarm == true {
                UIDatePickerOutlet.date = (selectedItem?.dateOfAlarm)!  //If the alarm was previously on, set the date to the date of the alarm
                UISwitchOutlet.setOn(true, animated: true)
            }
            
        } else {
            titleOfReminderOutlet.text = ""
            UISwitchOutlet.setOn(false, animated: true) //set a default if the user is not editing a list item
        }
        
    }
    func deleteReminder(andItem: items){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [andItem.description])    //Deletes a notification
    }
    
    func createReminder(for category: ReminderCategory, andItem: items) {
        let content = UNMutableNotificationContent()
        content.title = category.name
        content.body = andItem.description      //Creates a reminder for the time and name of the instance of ReminderCategory and items
        content.sound = UNNotificationSound.default
        let notifDate = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: UIDatePickerOutlet.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: notifDate, repeats: true)
        let request = UNNotificationRequest(identifier: andItem.description, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        if titleOfReminderOutlet.text != "" && UIDatePickerOutlet.date > Date() {
            /*
             If its not empty, the date is the future, the following code executes
            */
            var dateAlarm: Date? = nil
            
            if selectedItem?.activatedAlarm == true {
                deleteReminder(andItem: selectedItem!)// if there previously was an alarm, it gets deleted
            }
            
            if UISwitchOutlet.isOn {
                dateAlarm = UIDatePickerOutlet.date
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: {didAllow, error in}) //requests access to push notifications
            }
            
            let newItem = items.init(description: titleOfReminderOutlet.text!, activatedAlarm: UISwitchOutlet.isOn, dateOfAlarm: dateAlarm)
            
            if UISwitchOutlet.isOn {
                 createReminder(for: selectedCategory!, andItem: newItem) // If the reminder switch is on, a reminder alarm is creted
            }
            
            
            if didSelectItem  == false {
                /*If its a brand new instance they are creating
                 find the current category, add this item into the category, and then save
                */
                selectedCategory?.itemsInCategory.append(newItem)
                globalCategoriesList[selectedCategoryIndex!] = selectedCategory!
                
            } else {
                /*
                 replaces the item in the global
                 */
                selectedCategory?.itemsInCategory[selectedItemIndex!] = newItem
                globalCategoriesList[selectedCategoryIndex!] = selectedCategory!
            }
            
        save() // saves changes and unwinds to list
        performSegue(withIdentifier: "unwindToList", sender: self)
        
        } else {
            if titleOfReminderOutlet.text == "" {
            let noTitleTextAlert = UIAlertController(title: "Error!", message: "You have not typed in a title", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                (_)in   //displays an alert if the user has not typed something in
            })
            noTitleTextAlert.addAction(OKAction)
            self.present(noTitleTextAlert, animated: true, completion: nil)
        }
            if UIDatePickerOutlet.date <= Date() {
                let noTitleTextAlert = UIAlertController(title: "Error!", message: "Please pick a time in the future", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                    (_)in //displays an alert if the user has not pick a valid date
                })
                noTitleTextAlert.addAction(OKAction)
                self.present(noTitleTextAlert, animated: true, completion: nil)
            }
        }
    }
}
