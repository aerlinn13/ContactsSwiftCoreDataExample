//
//  ViewController.swift
//  beeContacts
//
//  Created by Danil on 24/03/2018.
//  Copyright © 2018 Danil. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context)

class GeneralVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ContactDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addButton(_ sender: Any) {
        contactToPass = nil
        contactIDToPass = defaults.integer(forKey: "contactID") + 1
        performSegue(withIdentifier: "manageContact", sender: self)
    }
    
    
    var contacts = Array<ContactObject>()
    var contactToPass:ContactObject?
    var contactIDToPass:Int?
    let defaults:UserDefaults = UserDefaults.standard
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell") as! ContactTableViewCell
        cell.contactName.text = contacts[indexPath.row].firstName + " " + contacts[indexPath.row].lastName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.contactToPass = contacts[indexPath.row]
        contactIDToPass = nil
        performSegue(withIdentifier: "manageContact", sender: self)
    }
    
    // this method handles row deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // remove the item from the data model
            removeItemFromCoreData(contact: contacts[indexPath.row])
            contacts.remove(at: indexPath.row)
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Not used in our example, but if you were adding a new row, this is where you would do it.
        }
    }
    
    func initialContactsLoading() {
        let initial = defaults.bool(forKey: "initialUploadDone")
        print("initial contacts upload status is done: " + String(describing: initial))
        if !initial {
            print("saving initial data to Core Data.")
            let path = Bundle.main.url(forResource: "data", withExtension: "json")
            let data = try! Data(contentsOf: path!)
            let json = try! JSON(data: data)
            for (_, value) in json {
                let counter = defaults.integer(forKey: "contactID")
                defaults.setValue(counter + 1, forKey: "contactID")
                let newContact = NSManagedObject(entity: entity!, insertInto: context)
                newContact.setValue(value["contactID"].stringValue, forKey: "contactID")
                newContact.setValue(value["firstName"].stringValue, forKey: "firstName")
                newContact.setValue(value["lastName"].stringValue, forKey: "lastName")
                newContact.setValue(value["streetAddress1"].stringValue, forKey: "streetAddress1")
                newContact.setValue(value["streetAddress2"].stringValue, forKey: "streetAddress2")
                newContact.setValue(value["phoneNumber"].stringValue, forKey: "phoneNumber")
                newContact.setValue(value["city"].stringValue, forKey: "city")
                newContact.setValue(value["state"].stringValue, forKey: "state")
                newContact.setValue(value["zipCode"].stringValue, forKey: "zipCode")
                do {
                    try context.save()
                    print("initial contact has been loaded. Id is: " + String(defaults.integer(forKey: "contactID")))
                } catch {
                    print("Failed saving.")
                }
            }
            defaults.set(true, forKey: "initialUploadDone")
        }
    }
    
    func retrieveContacts() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let contact = ContactObject(contactID: data.value(forKey: "contactID") as? String ?? "", firstName: data.value(forKey: "firstName") as? String ?? "", lastName: data.value(forKey: "lastName") as? String ?? "", phoneNumber: data.value(forKey: "phoneNumber") as? String ?? "", streetAddress1: data.value(forKey: "streetAddress1") as? String ?? "", streetAddress2: data.value(forKey: "streetAddress2") as? String ?? "", city: data.value(forKey: "city") as? String ?? "", state: data.value(forKey: "state") as? String ?? "", zipCode: data.value(forKey: "zipCode") as? String ?? "")
                contacts.append(contact)
            }
        } catch {
            
            print("Failed")
        }
    }
    
    func updateContact(contact: ContactObject) {
        updateItemInCoreData(contact: contact)
        contacts[contacts.index(where: {$0.contactID == contact.contactID})!] = contact
        tableView.reloadData()
        print("updateContact invoked.")
    }
    
    func addContact(contact: ContactObject) {
        print("addContact invoked.")
        contacts.append(contact)
        addItemToCoreData(contact: contact)
        tableView.reloadData()
    }
    
    func updateItemInCoreData(contact: ContactObject) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        request.predicate = NSPredicate(format: "contactID == %@", contact.contactID)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            let item = result[0] as! NSManagedObject
            item.setValue(contact.firstName, forKey: "firstName")
            item.setValue(contact.lastName, forKey: "lastName")
            item.setValue(contact.phoneNumber, forKey: "phoneNumber")
            item.setValue(contact.streetAddress1, forKey: "streetAddress1")
            item.setValue(contact.streetAddress2, forKey: "streetAddress2")
            item.setValue(contact.city, forKey: "city")
            item.setValue(contact.state, forKey: "state")
            item.setValue(contact.zipCode, forKey: "zipCode")
            do {
                try context.save()
                print("Contact has been edited in Core Data. Id is: " + contact.contactID)
            } catch {
                print("Failed saving")
            }
        } catch {
            print("Failed")
        }
    }
    
    func addItemToCoreData(contact: ContactObject) {
        let newContact = NSManagedObject(entity: entity!, insertInto: context)
        newContact.setValue(contact.contactID, forKey: "contactID")
        newContact.setValue(contact.firstName, forKey: "firstName")
        newContact.setValue(contact.lastName, forKey: "lastName")
        newContact.setValue(contact.phoneNumber, forKey: "phoneNumber")
        newContact.setValue(contact.streetAddress1, forKey: "streetAddress1")
        newContact.setValue(contact.streetAddress2, forKey: "streetAddress2")
        newContact.setValue(contact.city, forKey: "city")
        newContact.setValue(contact.state, forKey: "state")
        newContact.setValue(contact.zipCode, forKey: "zipCode")
        do {
            try context.save()
            defaults.set(contact.contactID, forKey: "contactID")
            print("new contact has been saved in Core Data. Id is: " + contact.contactID)
        } catch {
            print("Failed saving")
        }
    }
    
    func removeItemFromCoreData(contact: ContactObject) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        request.predicate = NSPredicate(format: "contactID == %@", contact.contactID)
        request.returnsObjectsAsFaults = false
            if let result = try? context.fetch(request) {
                for object in result {
                    context.delete(object as! NSManagedObject)
                    print("Contact has been deleted from Core Data. Id is: " + contact.contactID)
                }
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "manageContact" {
            let nextScene =  segue.destination as! ManageContactsVC
            if let contact = contactToPass {
            nextScene.contact = contact
            }
            nextScene.delegate = self
            nextScene.contactID = contactIDToPass
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialContactsLoading()
        retrieveContacts()
        let nib = UINib(nibName: "ContactTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ContactTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

