//
//  EditViewController.swift
//  Five Shelves
//
//  Created by Kevin Ryan Nava on 6/5/20.
//  Copyright © 2020 Kevin Ryan Nava. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    let bodyFont = UIFont.preferredFont(forTextStyle: .title1)
    
    var shelfNumber = "No shelf"
//    var amountNumber = "Amount"
    var itemName = ""
    
    @IBOutlet weak var textEntry: UITextField!
//    @IBOutlet weak var amountPicker: UIPickerView!
    @IBOutlet weak var shelfPicker: UIPickerView!
    let shelfPickerData = ["No shelf","Shelf 1","Shelf 2","Shelf 3","Shelf 4","Shelf 5"]
//    let amountPickerData = ["Amount","1","2","3","4","5","6","7","8","9","10"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        amountPicker.delegate = self
//        amountPicker.dataSource = self
        shelfPicker.delegate = self
        shelfPicker.dataSource = self
        textEntry.text = itemName
        if shelfNumber == "Shelf 1"{
            shelfPicker.selectRow(1, inComponent:0, animated:false)
        } else if shelfNumber == "Shelf 2"{
            shelfPicker.selectRow(2, inComponent:0, animated:false)
        } else if shelfNumber == "Shelf 3"{
            shelfPicker.selectRow(3, inComponent:0, animated:false)
        } else if shelfNumber == "Shelf 4"{
            shelfPicker.selectRow(4, inComponent:0, animated:false)
        } else if shelfNumber == "Shelf 5"{
            shelfPicker.selectRow(5, inComponent:0, animated:false)
        } else {
            shelfPicker.selectRow(0, inComponent:0, animated:false)
        }
//        if amountNumber == "Amount" {
//            amountPicker.selectRow(0, inComponent:0, animated:false)
//        } else {
//            amountPicker.selectRow(Int(amountNumber)!, inComponent:0, animated:false)
//        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if pickerView == amountPicker {
//            return amountPickerData.count
//        } else {
            return shelfPickerData.count
//        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if pickerView == amountPicker {
//            return amountPickerData[row]
//        } else {
            return shelfPickerData[row]
//        }
    }
        
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()

        label.textAlignment = .center
        label.font = bodyFont
        label.adjustsFontForContentSizeCategory = true
        
        // where data is an Array of String
        
//        if pickerView == amountPicker {
//            label.text = amountPickerData[row]
//        } else {
            label.text = shelfPickerData[row]
//        }
        
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
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyItem")

        fetchRequest.predicate = NSPredicate(format: "(itemName = %@) && (shelfNumber = %@)", argumentArray: [itemName, shelfNumber])

        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {

                results![0].setValue(textEntry.text, forKey: "itemName")
                results![0].setValue(shelfPickerData[shelfPicker.selectedRow(inComponent: 0)], forKey: "shelfNumber")
            }
        } catch {
            print("Fetch Failed: \(error)")
        }

        do {
            try context.save()
           }
        catch {
            print("Saving Core Data Failed: \(error)")
        }
        self.performSegue(withIdentifier: "backToHomeSegue", sender: self)
    }
    
}
