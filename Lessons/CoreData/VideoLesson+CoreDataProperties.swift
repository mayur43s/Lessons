//
//  VideoLesson+CoreDataProperties.swift
//  
//
//  Created by Mayur Shrivas on 10/01/23.
//
//

import Foundation
import CoreData


extension VideoLesson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VideoLesson> {
        return NSFetchRequest<VideoLesson>(entityName: "VideoLesson")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String
    @NSManaged public var details: String
    @NSManaged public var thumbnail: String
    @NSManaged public var videoUrl: String
    @NSManaged public var filePath: String?

}
