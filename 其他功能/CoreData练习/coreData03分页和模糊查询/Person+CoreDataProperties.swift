//
//  Person+CoreDataProperties.swift
//  coreData01
//
//  Created by i-Techsys.com on 17/1/13.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person");
    }

    @NSManaged public var height: Float
    @NSManaged public var name: String?
    @NSManaged public var birthday: Date?
    @NSManaged public var depart: Department?

}
