//
//  ManageContactsVC.swift
//  beeContacts
//
//  Created by Danil on 24/03/2018.
//  Copyright © 2018 Danil. All rights reserved.
//

import UIKit

class ManageContactsVC: UITableViewController {
    
    var fields = ["First Name", "Last Name", "Phone Number", "Street Address Line 1", "Street Address Line 2", "City", "State", "Zip Code" ]
    var contact:ContactObject?
    var delegate:ContactDelegate!
    var contactID:Int?
    
    @IBAction func cancelButton(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        var editedFieldValues = Array<String>()
        for (index, _) in fields.enumerated() {
            let cell = tableView.cellForRow(at: IndexPath(item: index, section: 0)) as! ManageContactTableViewCell
            if let text = cell.fieldValue.text {
                editedFieldValues.append(text)
            }
        }
        if let id = contactID {
            let newContact = ContactObject(contactID: String(id), firstName: editedFieldValues[0], lastName: editedFieldValues[1], phoneNumber: editedFieldValues[2], streetAddress1: editedFieldValues[3], streetAddress2: editedFieldValues[4], city: editedFieldValues[5], state: editedFieldValues[6], zipCode: editedFieldValues[7])
            delegate.addContact(contact: newContact)
        } else {
            if let id = contact?.contactID {
            print(id)
            let editedContact = ContactObject(contactID: id, firstName: editedFieldValues[0], lastName: editedFieldValues[1], phoneNumber: editedFieldValues[2], streetAddress1: editedFieldValues[3], streetAddress2: editedFieldValues[4], city: editedFieldValues[5], state: editedFieldValues[6], zipCode: editedFieldValues[7])
            delegate.updateContact(contact: editedContact)
            }
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageContactTableViewCell") as! ManageContactTableViewCell
        cell.fieldName.text = fields[indexPath.row]
        switch indexPath.row {
        case 0: cell.fieldValue.text = contact?.firstName
        case 1: cell.fieldValue.text = contact?.lastName
        case 2: cell.fieldValue.text = contact?.phoneNumber
        case 3: cell.fieldValue.text = contact?.streetAddress1
        case 4: cell.fieldValue.text = contact?.streetAddress2
        case 5: cell.fieldValue.text = contact?.city
        case 6: cell.fieldValue.text = contact?.state
        case 7: cell.fieldValue.text = contact?.zipCode
        default: break

        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ManageContactTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ManageContactTableViewCell")
        if let _ = contact {
            self.title = "Edit Contact"
        } else {
            self.title = "Add Contact"
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
