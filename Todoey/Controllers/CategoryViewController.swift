//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Lydia Marion on 12/2/18.
//  Copyright © 2018 Lydia. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    //Initialize realm
    let realm = try! Realm()
    // categories was an array and now is a collection of results of your category object
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.separatorStyle = .none
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the categories.count and if there's no categories return 1
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
            cell.backgroundColor = UIColor(hexString: (category.color))
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
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
    
    //MARK: - Delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
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
            newCategory.color = UIColor.randomFlat.hexValue()
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
