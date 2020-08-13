//
//  ViewController.swift
//  Five Shelves
//
//  Created by Kevin Ryan Nava on 6/3/20.
//  Copyright © 2020 Kevin Ryan Nava. All rights reserved.
//

import UIKit
import CoreData
    

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let bodyFont = UIFont.preferredFont(forTextStyle: .title2)
    let detailFont = UIFont.preferredFont(forTextStyle: .callout)
    
    @IBOutlet weak var itemList: UITableView!
    @IBOutlet weak var textEntry: UITextField!
    @IBOutlet weak var amountPicker: UIPickerView!
    @IBOutlet weak var shelfPicker: UIPickerView!
    @IBOutlet weak var yourItemsLabel: UILabel!
    let shelfPickerData = ["No shelf","Shelf 1","Shelf 2","Shelf 3","Shelf 4","Shelf 5"]
    let amountPickerData = ["Amount","1","2","3","4","5","6","7","8","9","10"]
    var myItems: [NSManagedObject] = []
    var searchItems: [NSManagedObject] = []
    var sortingAlphabetically = true
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var shelfSortButton: UIButton!
    @IBOutlet weak var nameSortButton: UIButton!
    @IBOutlet weak var toShelfViewButton: UIButton!
    var sortingNumerically = true
    var itemShelfNumber = "No shelf"
    var itemNameAndAmount = ""
    
    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        
        
        
        getData()
        super.viewDidLoad()
        //        self.setupHideKeyboardOnTap()
        
        // Do any additional setup after loading the view.
        
        //MARK: - DATA SOURCE AND DELEGATE
        amountPicker.dataSource = self
        amountPicker.delegate = self
        shelfPicker.delegate = self
        shelfPicker.dataSource = self
        itemList.delegate = self
        itemList.dataSource = self
        textEntry.delegate = self
        
        container = NSPersistentContainer(name: "MyItem")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        
        //MARK: - AESTHETICS AND HAPTIC FEEDBACK
        //
        myButton.addTarget(self, action: #selector(tappedHeavy), for: .touchUpInside)
        nameSortButton.addTarget(self, action: #selector(tappedMedium), for: .touchUpInside)
        shelfSortButton.addTarget(self, action: #selector(tappedMedium), for: .touchUpInside)
        toShelfViewButton.addTarget(self, action: #selector(tappedHeavy), for: .touchUpInside)
        
        itemList.backgroundColor = UIColor.clear
        
        myButton.setTitleColor(UIColor(named: "BlackDark"), for: .highlighted)
        nameSortButton.setTitleColor(UIColor(named: "BlackDark"), for: .highlighted)
        shelfSortButton.setTitleColor(UIColor(named: "BlackDark"), for: .highlighted)
        
        nameSortButton.titleLabel?.font = detailFont
        shelfSortButton.titleLabel?.font = detailFont
        nameSortButton.titleLabel?.adjustsFontForContentSizeCategory = true
        shelfSortButton.titleLabel?.adjustsFontForContentSizeCategory = true
        nameSortButton.titleLabel?.adjustsFontSizeToFitWidth = true
        shelfSortButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
    
    @objc func tappedHeavy() {
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    @objc func tappedMedium() {
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    
    //MARK: - PROCESS TEXT ENTRY
    
    func processTextEntry() {
        let enteredText = textEntry.text
        if enteredText != nil {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "MyItem", in: context)
            let newEntity = NSManagedObject(entity: entity!, insertInto: context)
            let shelfName = shelfPickerData[shelfPicker.selectedRow(inComponent: 0)]
            let amountChoice = amountPickerData[amountPicker.selectedRow(inComponent: 0)]
            if amountChoice == "Amount"{
                newEntity.setValue(enteredText!, forKey: "itemName")
            } else {
                let amountChosenPlusEnteredText = String(amountChoice) + " " + enteredText!
                newEntity.setValue(amountChosenPlusEnteredText, forKey: "itemName")
            }
            newEntity.setValue(shelfName, forKey: "shelfNumber")
            //           let tempItem = Item(name: enteredText!, shelf: shelfName)
            //            myItemsArray.append(tempItem)
            myItems.insert(newEntity, at: 0)
            
            do {
                try context.save()
                print("saved")
            } catch {
                print("failed saving")
            }
        }
    }
    
    //MARK: - CORE DATA
    
    func delete(_ tableView:UITableView, indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let itemToBeDeleted = self.myItems[indexPath.row]
        
//        var findIndex = 0
//        for searchItem in searchItems {
//            if searchItem.value(forKey: "itemName") as! String == itemToBeDeleted.value(forKey: "itemName") as! String {
//                break
//            }
//            findIndex+=1
//        }
//        self.searchItems.remove(at: findIndex)
        context.delete(itemToBeDeleted)
        self.myItems.remove(at: indexPath.row)
        do {
            try context.save()
            print("saved")
        } catch {
            print("failed saving")
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        self.updateUI()
    }
    
    //MARK: - AUTOCOMPLETE
    
    @IBAction func textEntryChanged(_ sender: UITextField) {
        searchItems = []
        let currEntry = textEntry.text!
//        let count = textEntry.text!.count
        for item in myItems {
            var match = true
            let currItemName = item.value(forKey: "itemName") as? String
//            for x in 0..<count {
            if !currItemName!.contains(currEntry){
                    match = false
                }
//            }
            if match {
                searchItems.append(item)
            }
        }
        itemList.reloadData()
    }
    
    
    @IBAction func unwindToViewControllerA(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    
    //MARK: - PREP FOR NEXT VCs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToShelves"{
            let destVC : SecondViewController = segue.destination as! SecondViewController
            destVC.myItems = self.myItems
        } else {
            let destVC : EditViewController = segue.destination as! EditViewController
            destVC.shelfNumber = itemShelfNumber
            destVC.itemName = itemNameAndAmount
        }
        
    }
    
    //MARK: - TO SHELF VIEW BUTTON
    
    @IBAction func toShelfView(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToShelves", sender: self)
    }
    
    //MARK: - ADD ITEM BUTTON
    
    @IBAction func addItem(_ sender: UIButton) {
        processTextEntry()
        updateUI()
        textEntry.endEditing(true)
    }
    
    
    //MARK: - SORT BUTTONS
    
    @IBAction func sortByName(_ sender: UIButton) {
        if sortingAlphabetically {
            sortingAlphabetically = false
            myItems.sort {
                let currName = $0.value(forKey: "itemName") as! String
                let nextName = $1.value(forKey: "itemName") as! String
                let currNameNoNums = currName.components(separatedBy:CharacterSet.letters.inverted).joined()
                let nextNameNoNums = nextName.components(separatedBy:CharacterSet.letters.inverted).joined()
                return currNameNoNums < nextNameNoNums
            }
        } else {
            sortingAlphabetically = true
            
            
            myItems.sort {
                let currName = $0.value(forKey: "itemName") as! String
                let nextName = $1.value(forKey: "itemName") as! String
                let currNameNoNums = currName.components(separatedBy:CharacterSet.letters.inverted).joined()
                let nextNameNoNums = nextName.components(separatedBy:CharacterSet.letters.inverted).joined()
                return currNameNoNums > nextNameNoNums
            }
        }
        
        UIView.transition(with: itemList,
                          duration: 1.0,
        options: [.transitionFlipFromBottom, .curveEaseInOut],
        animations: { self.updateUI() })
    }
    
    @IBAction func sortByShelf(_ sender: UIButton) {
        if sortingNumerically {
            sortingNumerically = false
            myItems.sort {
                let currNum = $0.value(forKey: "shelfNumber") as! String
                let nextNum = $1.value(forKey: "shelfNumber") as! String
                return currNum < nextNum
            }
        } else {
            sortingNumerically = true
            
            myItems.sort {
                let currNum = $0.value(forKey: "shelfNumber") as! String
                let nextNum = $1.value(forKey: "shelfNumber") as! String
                return currNum > nextNum
            }
        }
        
        UIView.transition(with: itemList,
                          duration: 1.0,
        options: [.transitionFlipFromBottom, .curveEaseInOut],
        animations: { self.updateUI() })
    }
    
    //MARK: - UPDATE UI
    
    func updateUI() {
        itemList.reloadData()
    }
    
    
    //MARK: - TABLE
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let verticalPadding: CGFloat = 8
        
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 22
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
        
        cell.center.y = cell.center.y + cell.frame.height / 2
        cell.alpha = 0
        UIView.animate(withDuration: 0.7, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            cell.center.y = cell.center.y - cell.frame.height / 2
            cell.alpha = 1
        }, completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success) in
            self.delete(tableView, indexPath: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, success) in
            self.itemShelfNumber = (tableView.cellForRow(at: indexPath)?.detailTextLabel?.text!)! as String
            self.itemNameAndAmount  = (tableView.cellForRow(at:indexPath)?.textLabel?.text!)! as String

  //          let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            self.performSegue(withIdentifier: "segueToEdit", sender: self)
        }
        
        edit.backgroundColor = #colorLiteral(red: 0.2324790359, green: 0.3831219077, blue: 0.5454628468, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var dataSource = [NSManagedObject]()
        
        if textEntry.text == "" {
            dataSource = myItems
        } else {
            dataSource = searchItems
        }
        if indexPath.row < dataSource.count {
            let myItem = dataSource[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! ItemListCell
            cell.textLabel?.text = myItem.value(forKey: "itemName") as? String
            cell.detailTextLabel?.text = myItem.value(forKey: "shelfNumber") as? String
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! ItemListCell
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
            return cell
        }
    }
    
    
    
    
    //MARK: - PICKER
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == amountPicker {
            return amountPickerData.count
        } else {
            return shelfPickerData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == amountPicker {
            return amountPickerData[row]
        } else {
            return shelfPickerData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        
        label.textAlignment = .center
        label.font = bodyFont
        label.adjustsFontForContentSizeCategory = true
        
        // where data is an Array of String
        
        if pickerView == amountPicker {
            label.text = amountPickerData[row]
        } else {
            label.text = shelfPickerData[row]
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        let font = bodyFont
        let height =  font.pointSize + 15.0;
        if height < 30 {
            return 30;
        } else {
            return height;
        }
    }
    
    
    //MARK: - GET DATA METHOD
    
    func getData() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyItem")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                //              myItemsArray.append(Item(name: data.value(forKey: "itemName") as! String, shelf: data.value(forKey: "shelfNumber") as! String))
                myItems.append(data)
            }
        } catch {
            print("failed")
        }
        
    }
    
    //MARK: - TEXT FIELD
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        processTextEntry()
        updateUI()
        textEntry.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textEntry.text = ""
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""
        
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // make sure the result is under 22 characters
        return updatedText.count <= 22
    }
    
    
    
}

