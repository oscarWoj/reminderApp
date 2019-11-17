//
//  ViewController.swift
//  Wojtal_Oscar_Reminders
//
//  Created by Os on 2019-04-21.
//  Copyright © 2019 Os. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var UIImageOutlet: UIImageView!
    @IBOutlet weak var categoryTextFeild: UITextField!  //Creating outlets for all object/feilds visible on the view controller
    @IBOutlet weak var pickerObject: UIPickerView!
    
    var currentName: String?
    var currentIcon: itemIcons?
    var passedInCategory: ReminderCategory?
    var passedInCategoryIndex: Int?
    
    let pickerViewArray: [itemIcons] = [.general, .work, .social, .school, .home, .family, .vacation, .groceries, .event]   //Creating an array for the picker to display
    
    func structToArrayPosition(name: itemIcons) -> Int {
        switch name {
        case .general:
            return 0
        case .social:
            return 2
        case .school:
            return 3
        case .home:
            return 4
        case .family:          // figures out where the current structures icon is in the array
            return 5
        case .vacation:
            return 6
        case .groceries:
            return 7
        case .event:
            return 8
        case .work:
            return 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        retrieve()

        if let passedInCategory = passedInCategory {
            
            /*
            Executes if the user passed in a category(edits it instead of making a new one)
                Sets the preselected category name, along with its icon, and the picker, to be displayed when the view appears
            */
            pickerObject.selectRow(structToArrayPosition(name: passedInCategory.iconString), inComponent: 0, animated: true)
            UIImageOutlet.image = itemIconToPicture(whichIcon: passedInCategory.iconString)
            categoryTextFeild.text = passedInCategory.name
            currentIcon = passedInCategory.iconString
            currentName = passedInCategory.name
            
        } else {
            /*
            If no category is passed in, then just set a default value (General icon and picker)
            */
            pickerObject.selectRow(0, inComponent: 0, animated: true)
            UIImageOutlet.image = itemIconToPicture(whichIcon: pickerViewArray[0])
            currentIcon = pickerViewArray.first
            categoryTextFeild.text = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerObject.delegate = self       //Connect picker in storyboard to picker in code
        self.pickerObject.dataSource = self
        }
    
    
    @IBAction func saveButton(_ sender: UIButton) {

        if categoryTextFeild.text != "" {
            /*
            If the textfeild is not empty, the following code executes
            */
            currentName = categoryTextFeild.text!
            
            if let passedInCategory = passedInCategory {

                /*
                 it now checks if a category was passed in, if it was, it looks for the instance of the category in the global array, edits it, saves, and presents an alert informing the user its been updated
                 */
                
                
                let alert = UIAlertController(title: "Category Updated!", message: "", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                    (_)in
                    self.performSegue(withIdentifier: "unwindToMain", sender: self)
                })
                alert.addAction(OKAction)
                
                retrieve()
                
                let currentlyEditedCategoryIndex: Int = globalCategoriesList.firstIndex(of: passedInCategory)!
                globalCategoriesList[currentlyEditedCategoryIndex] = ReminderCategory(name: currentName!, iconString: currentIcon!)
                save()
                
                self.present(alert, animated: true, completion: nil) // Presents alert
                
            } else {
            /*
             If they werent editing a catagory and wanted a new instance, the following code appends an instance and displays an alert
             */
                let alert = UIAlertController(title: "Category Added!", message: "", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                    (_)in
                    self.performSegue(withIdentifier: "unwindToMain", sender: self)
                })
                alert.addAction(OKAction)
                
                globalCategoriesList.append(ReminderCategory(name: currentName!, iconString: currentIcon!))
                save()
                self.present(alert, animated: true, completion: nil)
            }
            
        } else {
            //If the user has not typed something in:
            let noTitleTextAlert = UIAlertController(title: "Error!", message: "You have not typed in a title", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                (_)in
            })
            noTitleTextAlert.addAction(OKAction)
            
            self.present(noTitleTextAlert, animated: true, completion: nil)
        }
    }
}


extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    /*
     Initializing all UIPicker components
    */
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewArray[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        currentIcon = pickerViewArray[row]
        pickerObject.selectRow(row, inComponent: 0, animated: true)
        UIImageOutlet.image = itemIconToPicture(whichIcon: pickerViewArray[row])
        }
}
