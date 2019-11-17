//
//  CategoryTableViewController.swift
//  Wojtal_Oscar_Reminders
//
//  Created by Os on 2019-04-22.
//  Copyright © 2019 Os. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    @IBOutlet var tableViewOutlet: UITableView!
    
    var isEdited: Bool = false
    var edited: ReminderCategory?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        retrieve()
        tableView.reloadData()  //Retrieves any not yet updated data, reloads the table for a fresh view
        isEdited = false    //resets the edited tracker
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem //display an Edit button in the navigation bar for this view controller.
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Passes information to the view edit view controller (helps it decide if its editing a ReminderCategory or adding one)
        if segue.identifier == "addMainToEdit" {
            guard isEdited == false else { //Does not pass any info if the segue is happening without the user pressing the edit button
                
                let teleporter = segue.destination as! ViewController
                let editedCategory: ReminderCategory = edited!
                teleporter.title = editedCategory.name
                
                teleporter.passedInCategory = editedCategory
                return
            }
        }
    }
}

extension CategoryTableViewController {
    /*
     All the code for initializing The table view aspect of this TableViewController is below
     */
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalCategoriesList.count   //Returns the number of rows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        let currentCategory = globalCategoriesList[indexPath.row] //Sets what instance of the categories the "Current cell contains"
        
        cell.accessoryType = .detailDisclosureButton
        cell.textLabel?.text = currentCategory.name //Initializing the cell
        cell.imageView?.image = itemIconToPicture(whichIcon: currentCategory.iconString)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            globalCategoriesList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            save()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {// Executes when the user selects a row
        selectedCategory = globalCategoriesList[indexPath.row]
        selectedCategoryIndex = indexPath.row //Their selections are saved to global variables
        
        performSegue(withIdentifier: "mainToList", sender: self)    //User is segued to see all the lists
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath){    ///user pressed the editing button for a list item
        
        isEdited = true
        edited = globalCategoriesList[indexPath.row]
        
        performSegue(withIdentifier: "addMainToEdit", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {  //Code for when a user rearranges rows
        let temp = globalCategoriesList[fromIndexPath.row]
        globalCategoriesList.remove(at: fromIndexPath.row)
        globalCategoriesList.insert(temp, at: to.row)
        save()
    }
}
