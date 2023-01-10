//
//  LessonDetailsViewController.swift
//  Lessons
//
//  Created by Mayur Shrivas on 07/01/23.
//

import UIKit
import SwiftUI
import Combine
import ProgressHUD

struct LessonDetailView: UIViewControllerRepresentable {
    typealias UIViewControllerType = LessonDetailsViewController
    
    let lesson: Lesson
    
    func makeUIViewController(context: Context) -> LessonDetailsViewController {
        return LessonDetailsViewController(lesson: lesson)
    }
    
    func updateUIViewController(_ uiViewController: LessonDetailsViewController, context: Context) {
        
    }
}

final class LessonDetailsViewController: UIViewController {
    
    var lesson: Lesson? = nil
    
    let containerView = LessonDetailsUIView()
    let downloadManager = DownloadManager()

    init(lesson: Lesson) {
        self.lesson = lesson
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = containerView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.setLessonDetails(lesson: lesson)
        
        ProgressHUD.colorProgress = .systemBlue
        ProgressHUD.colorHUD = .systemGray6
        ProgressHUD.colorStatus = .systemBlue

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.parent?.navigationItem.largeTitleDisplayMode = .never
            self.showDowloadButtonIfNeeded()
        }
    }
    
    private func showDowloadButtonIfNeeded() {
        guard let videoUrl = self.lesson?.videoUrl else  {
            return
        }
        
        if !downloadManager.checkFileExists(videoUrl: videoUrl) {
            let rightBarButton = UIBarButtonItem(image: UIImage.init(systemName: "icloud.and.arrow.down"), style: .plain, target: self, action: #selector(downloadVideo))
            parent?.navigationItem.rightBarButtonItem = rightBarButton
        } else {
            hideDownloadButton()
        }
    }
    
    private func hideDownloadButton() {
        parent?.navigationItem.rightBarButtonItem = nil
    }
    
    @objc func downloadVideo() {
        guard let videoUrl = self.lesson?.videoUrl, !downloadManager.checkFileExists(videoUrl: videoUrl) else  {
            return
        }
        downloadManager.downloadFile(videoUrl: videoUrl, downloadProgress: { [weak self] progress in
            DispatchQueue.main.async {
                ProgressHUD.showProgress("Downloading...", progress)
                if progress == 1.0 {
                    ProgressHUD.dismiss()
                    self?.hideDownloadButton()
                }
            }
        })
    }
    
}
