//
//  ViewController.swift
//  ToDoApp
//
//  Created by Fenil Bhanavadiya on 2023-01-05.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }
    
    var taskArray = [Task]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.title = selectedCategory?.name
        // calling method for loading data from Tasks.plist file
        loadData()
    }
    
    // MARK: TableView datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo-item", for: indexPath) as! ToDoTaskTableViewCell
        let task = taskArray[indexPath.row]
        
        cell.itemLabel.text = task.title
        cell.accessoryType = task.done ? .checkmark : .none
        return cell
    }
    
    // MARK: TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(taskArray[indexPath.row])
//        taskArray.remove(at: indexPath.row)
        
        taskArray[indexPath.row].done = !taskArray[indexPath.row].done
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Add button action
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        
        // action to be performed when Add button will be clicked
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New Task", message: "Tasks those need to be completed", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newTask = Task(context: self.context)
            
            newTask.title = textField.text!
            newTask.done = false
            newTask.parentCategory = self.selectedCategory
            self.taskArray.append(newTask)
            self.saveData()
        }
        
        alert.addTextField() { (alertTextField) in
            alertTextField.placeholder = "Enter a task to be completed..."
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Additional supporting methods
    
    // method for saving data in the Tasks.plist file
    func saveData() {
        
        do {
            try context.save()
        } catch {
            print("Error occurred while saving the context, || \(error) ||")
        }
        tableView.reloadData()
        
    }
    
    // method for fetching data from Tasks.plist file
    func loadData(with request: NSFetchRequest<Task> = Task.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            let coumpoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            request.predicate = coumpoundPredicate
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            taskArray = try context.fetch(request)
        } catch {
            print("Error occurred while fetching the data, || \(error) ||")
        }
        
        tableView.reloadData()
    }
    
}

// MARK: SearchBar Delegate Implementation
extension ToDoViewController: UISearchBarDelegate {
    
    // search bar delegate method
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadData(with: request, predicate: predicate)
        
        print(searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
