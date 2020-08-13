//
//  ThirdViewController.swift
//  Five Shelves
//
//  Created by Kevin Ryan Nava on 6/4/20.
//  Copyright © 2020 Kevin Ryan Nava. All rights reserved.
//

import UIKit
import CoreData

class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var singleShelfLabel: UILabel!
    @IBOutlet weak var singleShelfTable: UITableView!
    
    var singleShelf = ["Empty"]
    var shelfNum = "0"
    var myItems: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singleShelfTable.delegate = self
        singleShelfTable.dataSource = self
        singleShelfLabel.text = "shelf " + shelfNum
    }
    
    //MARK: - TABLE VIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return singleShelf.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ("singleShelfCell"), for: indexPath)
        cell.textLabel!.font = .preferredFont(forTextStyle: .title2)
        cell.textLabel?.adjustsFontForContentSizeCategory = true
        cell.textLabel!.text = ""
        if indexPath.row < singleShelf.count {
            cell.textLabel!.text = singleShelf[indexPath.row]
        }
        return cell
    }
    
    //MARK: - BUTTONS

    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success) in
               self.delete(tableView, indexPath: indexPath)
           }
           return UISwipeActionsConfiguration(actions: [delete])
       }
    
    
    func delete(_ tableView:UITableView, indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(self.myItems[indexPath.row])
        self.myItems.remove(at: indexPath.row)
        do {
            try context.save()
            print("saved")
        } catch {
            print("failed saving")
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
    }
    
       
//       func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//           let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, success) in
//               self.itemShelfNumber = tableView.cellForRow(at: indexPath)?.detailTextLabel?.text! as! String
//               self.itemNameAndAmount  = tableView.cellForRow(at:indexPath)?.textLabel?.text! as! String
//
//     //          let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//               self.performSegue(withIdentifier: "segueToEdit", sender: self)
//           }
//
//           edit.backgroundColor = #colorLiteral(red: 0.2324790359, green: 0.3831219077, blue: 0.5454628468, alpha: 1)
//
//           return UISwipeActionsConfiguration(actions: [edit])
//       }
    
    
}
