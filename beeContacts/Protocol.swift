//
//  File.swift
//  beeContacts
//
//  Created by Danil on 25/03/2018.
//  Copyright © 2018 Danil. All rights reserved.
//

import Foundation

protocol ContactDelegate {
    func updateContact(contact: ContactObject)
    func addContact(contact: ContactObject)
}
