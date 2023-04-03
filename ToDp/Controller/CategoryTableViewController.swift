//
//  CategoryTableViewController.swift
//  ToDp
//
//  Created by ivan cardenas on 02/04/2023.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    let realm = try! Realm()

    var categoryArray: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    func loadCategories() {

        categoryArray   = realm.objects(Category.self)
        tableView.reloadData()
    }

    func save(category: Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print(error)
        }
        tableView.reloadData()
    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "" , preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory )
        }

        alert.addTextField() { alertTextField in
            alertTextField.placeholder = "Create a Category"
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }

}

//MARK: - TableViewDelegate and DataSource

extension CategoryTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let item = categoryArray?[indexPath.row]

        cell.textLabel?.text = item?.name 

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //code to navigate
        performSegue(withIdentifier: "goToItems", sender: self)
    }
}
