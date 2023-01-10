//
//  LessonsModel.swift
//  Lessons
//
//  Created by Mayur Shrivas on 07/01/23.
//

import Foundation

struct LessonsModel: Codable {

    let lessons: [Lesson]

}

struct Lesson: Codable, Identifiable {

    let id: Int
    let name: String
    let description: String
    let thumbnail: String
    let videoUrl: String

}
