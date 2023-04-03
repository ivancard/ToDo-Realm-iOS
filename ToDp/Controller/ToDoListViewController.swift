//
//  ViewController.swift
//  ToDp
//
//  Created by ivan cardenas on 02/04/2023.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    let realm = try! Realm()

    var selectedCategory: Category? {
        didSet{
            loadToDos()
        }
    }
    var arrayItem: Results<Item>?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayItem?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        if let item = arrayItem?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done  ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }



        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = arrayItem?[indexPath.row ] {
            do {
                try realm.write {
                    item.done.toggle()
                }
            } catch {
                print(error)
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new ToDo", message: "" , preferredStyle: .alert)

        let action = UIAlertAction(title: "Add ToDo", style: .default) { [self] action in

            if let currentCategory = self.selectedCategory {
                do  {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print(error )
                }
            }
            tableView.reloadData()
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create a ToDo"
            textField = alertTextField
        }
        alert.addAction(action)

        present(alert, animated: true)
    }

    @IBAction func searchDidChange(_ sender: UITextField) {
        if sender.text?.trimmingCharacters(in: .whitespaces) == "" {
            loadToDos()
        } else {
            arrayItem = arrayItem?.filter("title CONTAINS[cd] %@", sender.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        }
        tableView.reloadData()
    }

    func loadToDos() {
        arrayItem = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

}
