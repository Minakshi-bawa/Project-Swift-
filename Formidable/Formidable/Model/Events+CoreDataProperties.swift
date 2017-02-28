//
//  Events+CoreDataProperties.swift
//  Formidable
//
//  Created by Minakshi Bawa on 26/02/17.
//  Copyright © 2017 Shashi. All rights reserved.
//

import Foundation
import CoreData


extension Events {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Events> {
        return NSFetchRequest<Events>(entityName: "Events");
    }

    @NSManaged public var time: String?
    @NSManaged public var desc: String?
    @NSManaged public var duration: String?
    @NSManaged public var status: Bool
    @NSManaged public var days: String?
    @NSManaged public var eventId: String?

}
