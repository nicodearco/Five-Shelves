//
//  SecondViewController.swift
//  Five Shelves
//
//  Created by Kevin Ryan Nava on 6/3/20.
//  Copyright © 2020 Kevin Ryan Nava. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var singleShelf = ["Empty"]
    var shelfNum = "0"
    
    @IBOutlet weak var shelf1Table: UITableView!
    @IBOutlet weak var shelf2Table: UITableView!
    @IBOutlet weak var shelf3Table: UITableView!
    @IBOutlet weak var shelf4Table: UITableView!
    @IBOutlet weak var shelf5Table: UITableView!
    @IBOutlet weak var shelfViewStackView: UIStackView!
    @IBOutlet weak var shelf1StackView: UIStackView!
    @IBOutlet weak var shelfViewLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    let captionFont = UIFont.preferredFont(forTextStyle: .title3)
    
    var shelvesArray =  [["Empty"],["Empty"],["Empty"],["Empty"],["Empty"],["Empty"]]
    var myItems: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shelf1Table.delegate = self
        shelf1Table.dataSource = self
        shelf2Table.delegate = self
        shelf2Table.dataSource = self
        shelf3Table.delegate = self
        shelf3Table.dataSource = self
        shelf4Table.delegate = self
        shelf4Table.dataSource = self
        shelf5Table.delegate = self
        shelf5Table.dataSource = self
        
        // shelfViewStackView.addArrangedSubview(backButton)
        shelf1StackView.setCustomSpacing(60, after: shelf1Table)
        
        turnObjectsArrayIntoShelvesArray()
        // Do any additional setup after loading the view.
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC : ThirdViewController = segue.destination as! ThirdViewController
        
        destVC.singleShelf = self.singleShelf
        destVC.shelfNum = self.shelfNum
        destVC.myItems = self.myItems
    }
    
    func turnObjectsArrayIntoShelvesArray (){
        for item in myItems {
            let shelf = item.value(forKey: "shelfNumber") as! String
            let itemName = item.value(forKey: "itemName") as! String
            if shelf == "No shelf"{
                if shelvesArray[0][0] == "Empty"{
                    shelvesArray[0].remove(at: 0)
                }
                shelvesArray[0].append(itemName)
            } else if shelf == "Shelf 1" {
                if shelvesArray[1][0] == "Empty"{
                    shelvesArray[1].remove(at: 0)
                }
                shelvesArray[1].append(itemName)
            } else if shelf == "Shelf 2" {
                if shelvesArray[2][0] == "Empty"{
                    shelvesArray[2].remove(at: 0)
                }
                shelvesArray[2].append(itemName)
            } else if shelf == "Shelf 3" {
                if shelvesArray[3][0] == "Empty"{
                    shelvesArray[3].remove(at: 0)
                }
                shelvesArray[3].append(itemName)
            } else if shelf == "Shelf 4" {
                if shelvesArray[4][0] == "Empty"{
                    shelvesArray[4].remove(at: 0)
                }
                shelvesArray[4].append(itemName)
            } else if shelf == "Shelf 5" {
                if shelvesArray[5][0] == "Empty"{
                    shelvesArray[5].remove(at: 0)
                }
                shelvesArray[5].append(itemName)
            }
        }
        print(shelvesArray)
        
    }
    
    //MARK: - BUTTONS
    
    @IBAction func shelfButtonPressed(_ sender: UIButton) {
        if sender.titleLabel?.text == "1" {
            shelfNum = "1"
            singleShelf = shelvesArray[1]
        } else if sender.titleLabel?.text == "2" {
            shelfNum = "2"
            singleShelf = shelvesArray[2]
        } else if sender.titleLabel?.text == "3" {
            shelfNum = "3"
            singleShelf = shelvesArray[3]
        } else if sender.titleLabel?.text == "4" {
            shelfNum = "4"
            singleShelf = shelvesArray[4]
        } else {
            shelfNum = "5"
            singleShelf = shelvesArray[5]
        }
        performSegue(withIdentifier: "segueToShelf", sender: self)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - TABLE VIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shelvesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == shelf1Table {
            let cell = tableView.dequeueReusableCell(withIdentifier: ("shelf1Cell"), for: indexPath)
            cell.textLabel?.font = captionFont
            cell.textLabel?.adjustsFontForContentSizeCategory = true
            cell.textLabel!.text = ""
            if indexPath.row < shelvesArray[1].count {
                cell.textLabel!.text = shelvesArray[1][indexPath.row]
            }
            return cell
        } else if tableView == shelf2Table {
            let cell = tableView.dequeueReusableCell(withIdentifier: ("shelf2Cell"), for: indexPath)
            cell.textLabel?.font = captionFont
            cell.textLabel?.adjustsFontForContentSizeCategory = true
            cell.textLabel!.text = ""
            if indexPath.row < shelvesArray[2].count {
                cell.textLabel!.text = shelvesArray[2][indexPath.row]
            }
            return cell
        } else if tableView == shelf3Table {
            let cell = tableView.dequeueReusableCell(withIdentifier: ("shelf3Cell"), for: indexPath)
            cell.textLabel?.font = captionFont
            cell.textLabel?.adjustsFontForContentSizeCategory = true
            cell.textLabel!.text = ""
            if indexPath.row < shelvesArray[3].count {
                cell.textLabel!.text = shelvesArray[3][indexPath.row]
            }
            return cell
        } else if tableView == shelf4Table {
            let cell = tableView.dequeueReusableCell(withIdentifier: ("shelf4Cell"), for: indexPath)
            cell.textLabel?.font = captionFont
            cell.textLabel?.adjustsFontForContentSizeCategory = true
            cell.textLabel!.text = ""
            if indexPath.row < shelvesArray[4].count {
                cell.textLabel!.text = shelvesArray[4][indexPath.row]
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ("shelf5Cell"), for: indexPath)
            cell.textLabel?.font = captionFont
            cell.textLabel?.adjustsFontForContentSizeCategory = true
            cell.textLabel!.text = ""
            if indexPath.row < shelvesArray[5].count {
                cell.textLabel!.text = shelvesArray[5][indexPath.row]
            }
            return cell
        }
    }
    
    //MARK: - UPDATE UI
    
    func updateUI() {
        shelf1Table.reloadData()
        shelf2Table.reloadData()
        shelf3Table.reloadData()
        shelf4Table.reloadData()
        shelf5Table.reloadData()
    }
    
    
}
