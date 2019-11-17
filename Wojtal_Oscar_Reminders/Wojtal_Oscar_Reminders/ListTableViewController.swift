//
//  ListTableViewController.swift
//  Wojtal_Oscar_Reminders
//
//  Created by Os on 2019-04-25.
//  Copyright © 2019 Os. All rights reserved.
//

import UIKit




class ListTableViewController: UITableViewController {
    
    @IBOutlet var tableViewOutlet: UITableView!
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        retrieve()
        self.title = selectedCategory!.name //Sets the title of the view controller to the name of the category
        tableViewOutlet.reloadData()
        didSelectItem = false
        }
}



extension ListTableViewController {
    /*
    All of the following code sets up the table view with the lists from each category
     
    */
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (selectedCategory?.itemsInCategory.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        let specificInstanceOfItem = selectedCategory?.itemsInCategory[indexPath.row] //For convenience sake, setting a specified instance lets me focus on a single variable instead of something like: "selectedCategory?.itemsInCategory[indexPath.row].description"
        
        cell.accessoryType = .disclosureIndicator //
        cell.textLabel?.text = specificInstanceOfItem!.description
        
        if specificInstanceOfItem?.activatedAlarm == true {
            cell.imageView?.image = UIImage(named: "021-clock") //If there is an alarm, it shows the symbol
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        didSelectItem = true
        selectedItem = selectedCategory!.itemsInCategory[indexPath.row] //sets global variables to whichever row they pick and segues to edit screen
        selectedItemIndex = indexPath.row
        
        performSegue(withIdentifier: "listToEdit", sender: self)
        
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            selectedCategory!.itemsInCategory.remove(at: indexPath.row) //If they delete something from the table view, this code executes to remove it from the code and update the global list
            globalCategoriesList[selectedCategoryIndex!] = selectedCategory!
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            save()
        }
    }
}
