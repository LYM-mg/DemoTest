//
//  Department+CoreDataProperties.swift
//  coreData01
//
//  Created by i-Techsys.com on 17/1/13.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import Foundation
import CoreData


extension Department {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Department> {
        return NSFetchRequest<Department>(entityName: "Department");
    }

    @NSManaged public var departNo: String?
    @NSManaged public var name: String?
    @NSManaged public var creatDate: Date?

}
