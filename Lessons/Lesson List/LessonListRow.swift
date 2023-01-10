//
//  LessonListRow.swift
//  Lessons
//
//  Created by Mayur Shrivas on 07/01/23.
//

import SwiftUI
import Kingfisher

struct LessonListRow: View {
    
    let lesson: VideoLesson

    var body: some View {
        HStack(spacing: 10) {
            KFImage(URL(string: lesson.thumbnail))
                .placeholder {
                    Color.gray
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 56)
                .cornerRadius(5)
                        
            Text(lesson.name)            
        }
        .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
    }
}

