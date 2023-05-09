//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Fenil Bhanavadiya on 2023-05-08.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    @IBOutlet weak var categorySearchBar: UISearchBar!

    var categoriesList = [Category]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    // MARK: TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        
        let categoryName = categoriesList[indexPath.row]
        cell.categoryName.text = categoryName.name
        
        return cell
    }
    
    // MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "category-tasks", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ToDoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categoriesList[indexPath.row]
        }
    }
    
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        
        var categoryName = UITextField()
        
        let addNewCategoryAlert = UIAlertController(title: "New Category", message: "Add new Category by entering name below", preferredStyle: .alert)
        
        addNewCategoryAlert.addTextField() { (newCategoryTextField) in
            newCategoryTextField.placeholder = "Category Name"
            categoryName = newCategoryTextField
        }
        
        let categoryAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = categoryName.text!
            self.categoriesList.append(newCategory)
            self.saveData()
        }
        
        addNewCategoryAlert.addAction(categoryAction)
        addNewCategoryAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(addNewCategoryAlert, animated: true, completion: nil)
        
    }
    
    // MARK: Data Manipulation Methods
    func saveData() {
        
        do {
            try context.save()
        } catch {
            print("Error saving Data, || \(error.localizedDescription) ||")
        }
        tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoriesList = try context.fetch(request)
        } catch {
            print("Error fetching Data, || \(error.localizedDescription) ||")
        }
        tableView.reloadData()
    }
    
}

extension CategoryViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", categorySearchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        loadData(with: request)
        print("\(categorySearchBar.text!)")
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
