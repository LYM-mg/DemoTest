//
//  Message+CoreDataProperties.swift
//  coreData01
//
//  Created by i-Techsys.com on 17/1/15.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message");
    }

    @NSManaged public var text: String?
    @NSManaged public var craetDate: NSDate?

}
