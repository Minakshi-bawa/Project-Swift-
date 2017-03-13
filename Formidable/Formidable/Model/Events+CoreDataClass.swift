//
//  Events+CoreDataClass.swift
//  Formidable
//
//  Created by Minakshi Bawa on 26/02/17.
//  Copyright © 2017 Shashi. All rights reserved.
//

import Foundation
import CoreData




public class Events: NSManagedObject {

  //MARK:- Static Methods
  static func eventSaving(arrEvent:Any){
    if let dict = arrEvent as? [String:Any] {
     saveEvent(eventObject: dict)
//      if let resultArr = dict[Results] as? [[String:Any]] {
//        for dictEvent in resultArr {
//          saveEvent(eventObject: dictEvent)
//        }
//      }
    }
  }
  
  static func saveEvent(eventObject:Any) {
    
    if var dict = eventObject as? [String:Any], let entity = NSEntityDescription.entity(forEntityName: "Events", in: CoreDataHelper.sharedInstance.bgManagedObjectContext) {
      let context : NSManagedObjectContext = CoreDataHelper.sharedInstance.bgManagedObjectContext
      if let id = (dict["eventId"] as? [String:Any])?[Value] as? String{
        CoreDataHelper.sharedInstance.bgManagedObjectContext.perform({
          
          var eventObj:Events!
          // delete obj if already exist
          if let event = eventWith(id: id){
            eventObj = event
           // code to delete the item
            
            context.delete(eventObj)
          }
          else
          {
//          let attrIds = dict.keys // will do for loop to save all keys
//            for attrId in attrIds{
//              if let attribute = Attribute.createAttribute(id: attrId, object: dict[attrId] ?? ""){
//                attribute.booking = eventObj
//                eventObj.addToAttributes(attribute)
//              }

            eventObj = Events(entity: entity, insertInto: context)
            eventObj.eventId = id
            eventObj.title = dict["title"] as! String?
            if let time = dict["time"] as? String?
            {
              eventObj.time = time
            }
            if let desc = dict["desc"] as? String?
            {
              eventObj.desc = desc
            }
            if let duration = dict["duration"] as? String?
            {
              eventObj.duration = duration
            }
            if let days = dict["days"] as? String?
            {
              eventObj.days = days
            }
            eventObj.status =  dict["status"] as! String == "true" ? true : false
          }
          CoreDataHelper.sharedInstance.saveBackgroundContext()
        })
      }
    }
  }
  static func eventWith(id:String) -> Events? {
    return CoreDataHelper.fetchObjectsOfClassWithName(className:"Events", predicate: NSPredicate(format: "eventId = \(id)"), sortingKeys: nil, context : CoreDataHelper.sharedInstance.bgManagedObjectContext).first as? Events
  }
  
}
