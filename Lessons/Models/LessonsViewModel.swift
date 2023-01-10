//
//  LessonsViewModel.swift
//  Lessons
//
//  Created by Mayur Shrivas on 07/01/23.
//

import SwiftUI

final class LessonsViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var lessons: [Lesson] = []

    func getLessons() {
        NetworkManager.shared.getLessons { result in
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
                switch result {
                case .success(let lessons):
                    self?.lessons = lessons
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
