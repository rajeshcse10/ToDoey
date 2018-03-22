//
//  CategoryTableViewController.swift
//  ToDoey
//
//  Created by Rajesh Karmaker on 16/3/18.
//  Copyright © 2018 Rajesh Karmaker. All rights reserved.
//

import UIKit
import RealmSwift
class CategoryTableViewController: UITableViewController {
    var categoryArray:Results<Category>?
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        addplusButtonToNavigationBar()
        loadData()
    }
    func addplusButtonToNavigationBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCategory))
    }
    @objc func addCategory(){
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Add new category"
            alertTextField = textField
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            let category = Category()
            category.name = alertTextField.text!
            self.save(with: category)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = categoryArray![indexPath.row].name
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let category = categoryArray?[indexPath.row]{
                do{
                    try realm.write {
                        realm.delete(category)
                    }
                }catch{
                    print("Error in deleting category : \(error)")
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "itemSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemSegue"{
            let destination = segue.destination as! ItemTableViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                 destination.selectedCategory = categoryArray![indexPath.row]
            }
        }
    }
    func  save(with data:Category) {
        do{
            try realm.write {
                realm.add(data)
            }
        }catch{
            print("Error in saving category object : \(error)")
        }
    }
    func loadData(){
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
}
