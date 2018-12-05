//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Lydia Marion on 12/2/18.
//  Copyright © 2018 Lydia. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    //Initialize realm
    let realm = try! Realm()
    // categories was an array and now is a collection of results of your category object
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.rowHeight = 80
        
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the categories.count and if there's no categories return 1
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        cell.delegate = self
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    // what should happen if I click to a category
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // takes you to the todolistcontroller of the selected category
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }

    //MARK: - Data Manipulation Methods
    func save(category : Category){
        do {
            // Commit changes to realm
            try realm.write {
                // add similar to append
                realm.add(category)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }

    func loadCategories() {
        //look inside realm all our categories
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }

    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // Creating a local variable
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // What will happen once the user click the ADD ITEM button on our UIAlert
            let newCategory = Category()
            newCategory.name = textField.text!
            // Saving
            self.save(category: newCategory)
        }
        // Adding a textfield to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}


//MARK: - SwipeCell Delegate Methods
extension CategoryViewController : SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            if let categoryForDeletion = self.categories?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                    }
                } catch {
                    print("Error deleting data, \(error)")
                }
            }
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
}
