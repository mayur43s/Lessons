//
//  LessonListView.swift
//  Lessons
//
//  Created by Mayur Shrivas on 07/01/23.
//

import SwiftUI

struct LessonListView: View {
    
    @StateObject var viewModel = LessonsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading { ProgressView() }
                List(viewModel.lessons, id: \.id) { lesson in
                    NavigationLink(destination: LessonDetailView(lesson: lesson)) {
                        LessonListRow(lesson: lesson)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Lessons")
        }
        .onAppear() {
            viewModel.getLessons()
        }
    }

}

struct LessonListView_Previews: PreviewProvider {
    static var previews: some View {
        LessonListView()
    }
}
