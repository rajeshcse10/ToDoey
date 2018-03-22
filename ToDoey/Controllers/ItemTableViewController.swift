//
//  ItemTableViewController.swift
//  ToDoey
//
//  Created by Rajesh Karmaker on 16/3/18.
//  Copyright © 2018 Rajesh Karmaker. All rights reserved.
//

import UIKit
import RealmSwift
class ItemTableViewController: UITableViewController {
    let realm = try! Realm()
    var selectedCategory:Category?{
        didSet{
            loadData()
        }
    }
    var itemArray:Results<ToDoItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addplusButtonToNavigationBar()
    }
    func addplusButtonToNavigationBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
    }
    @objc func addItem(){
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Add new item"
            alertTextField = textField
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
                do{
                    let item = ToDoItem()
                    item.title = alertTextField.text!
                    item.done = false
                    try self.realm.write {
                        self.realm.add(item)
                        currentCategory.items.append(item)
                    }
                }catch{
                    print("Error in saving Item object : \(error)")
                }
            }
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
        // #warning Incomplete implementation, return the number of rows
        return itemArray!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        if itemArray![indexPath.row].done == true{
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        cell.textLabel?.text = itemArray![indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = tableView.cellForRow(at: indexPath)
        if let item = itemArray?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("Error in updating item : \(error)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
  
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


 
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let item = itemArray?[indexPath.row]{
                do{
                    try realm.write {
                        realm.delete(item)
                    }
                }catch{
                    print("Error in deleting item : \(error)")
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    func loadData(){
        itemArray = selectedCategory!.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

