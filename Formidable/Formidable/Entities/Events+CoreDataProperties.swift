//
//  Events+CoreDataProperties.swift
//  
//
//  Created by Minakshi Bawa on 11/04/17.
//
//

import Foundation
import CoreData


extension Events {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Events> {
        return NSFetchRequest<Events>(entityName: "Events");
    }

    @NSManaged public var days: String?
    @NSManaged public var desc: String?
    @NSManaged public var duration: String?
    @NSManaged public var eventId: String?
    @NSManaged public var status: Bool
    @NSManaged public var time: String?
    @NSManaged public var title: String?

}
