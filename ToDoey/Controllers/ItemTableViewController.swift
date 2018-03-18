//
//  ItemTableViewController.swift
//  ToDoey
//
//  Created by Rajesh Karmaker on 16/3/18.
//  Copyright © 2018 Rajesh Karmaker. All rights reserved.
//

import UIKit
import CoreData
class ItemTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory:Category?{
        didSet{
            loadData()
        }
    }
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadData()
        searchBar.delegate = self
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
            let item = Item(context: self.context)
            item.title = alertTextField.text
            item.done = false
            item.itemToCategory = self.selectedCategory
            self.itemArray.append(item)
            self.saveData()
            let indexPath = IndexPath(row: self.itemArray.count == 0 ? 0 : self.itemArray.count-1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
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
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        if itemArray[indexPath.row].done == true{
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        cell.textLabel?.text = itemArray[indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            itemArray[indexPath.row].done = !itemArray[indexPath.row].done
            if itemArray[indexPath.row].done == true{
                cell.accessoryType = .checkmark
            }
            else{
                cell.accessoryType = .none
            }
            saveData()
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
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
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    func  saveData() {
        do{
            try context.save()
        }catch{
            print("Save error : \(error)")
        }
    }
    func loadData(request:NSFetchRequest<Item> = Item.fetchRequest() ,with predicate:NSPredicate? = nil){
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "itemToCategory.name MATCHES %@", selectedCategory!.name!)
        let compoudPredicate : NSCompoundPredicate
        if let additionalPredicate = predicate{
            compoudPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate,categoryPredicate])
        }
        else{
            compoudPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate])
        }
        request.predicate = compoudPredicate
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Fetching error : \(error)")
        }
        tableView.reloadData()
    }
}
extension ItemTableViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            loadData()
        }
        else{
            let request:NSFetchRequest<Item> = Item.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            loadData(request: request,with: NSPredicate(format: "title CONTAINS[cd] %@", searchText))
        }
    }
}
