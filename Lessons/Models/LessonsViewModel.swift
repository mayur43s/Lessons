//
//  LessonsViewModel.swift
//  Lessons
//
//  Created by Mayur Shrivas on 07/01/23.
//

import SwiftUI
import CoreData

final class LessonsViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var lessons: [VideoLesson] = []

    func getLessons() {
        NetworkManager.shared.getLessons { result in
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
                switch result {
                case .success(let lessons):
                    self?.saveToLocalDatabase(lessons: lessons)
                    self?.getSavedDataFromLocalDatabase()
                case .failure(let error):
                    self?.getSavedDataFromLocalDatabase()
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func saveToLocalDatabase(lessons: [Lesson]) {
        let databaseManager = DatabaseManager.shared
        databaseManager.deleteAllRecords("VideoLesson")

        for lesson in lessons {
            let lessonList = VideoLesson(context: databaseManager.managedContext)
            lessonList.id = Int32(lesson.id)
            lessonList.name = lesson.name
            lessonList.details = lesson.description
            lessonList.thumbnail = lesson.thumbnail
            lessonList.videoUrl = lesson.videoUrl
            databaseManager.saveContext()
        }
    }

    private func getSavedDataFromLocalDatabase() {
        let databaseManager = DatabaseManager.shared
        lessons = databaseManager.fetch(VideoLesson.self)
    }
}
