//
//  LessonDetailsViewController.swift
//  Lessons
//
//  Created by Mayur Shrivas on 07/01/23.
//

import UIKit
import SwiftUI
import ProgressHUD
import AVKit

struct LessonDetailView: UIViewControllerRepresentable {
    typealias UIViewControllerType = LessonDetailsViewController
    
    let lesson: VideoLesson
    
    func makeUIViewController(context: Context) -> LessonDetailsViewController {
        return LessonDetailsViewController(lesson: lesson)
    }
    
    func updateUIViewController(_ uiViewController: LessonDetailsViewController, context: Context) {
        
    }
}

final class LessonDetailsViewController: UIViewController {
    
    var lesson: VideoLesson?
    
    let containerView = LessonDetailsUIView()
    let downloadManager = DownloadManager()

    init(lesson: VideoLesson) {
        self.lesson = lesson
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = containerView
    }

    //MARK: View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.setLessonDetails(lesson: lesson)
        containerView.playButtonCallback = {
            self.playViedo()
        }
        containerView.previousButtonCallback = {
            self.goToPreviousLessson()
        }
        containerView.nextButtonCallback = {
            self.goToNextLessson()
        }
        setupProgressHUD()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.parent?.navigationItem.largeTitleDisplayMode = .never
            self.showDowloadButtonIfNeeded()
        }
    }
    
    //MARK: Private Helpers -
    private func setupProgressHUD() {
        ProgressHUD.colorProgress = .systemBlue
        ProgressHUD.colorHUD = .systemGray6
        ProgressHUD.colorStatus = .systemBlue
    }
    
    private func showDowloadButtonIfNeeded() {
        guard let videoUrl = self.lesson?.videoUrl else  {
            return
        }
        
        if !downloadManager.checkFileExists(videoUrl: videoUrl) {
            let button = UIButton(type: .system)
            button.setTitle("Download", for: .normal)
            button.setImage(UIImage.init(systemName: "icloud.and.arrow.down"), for: .normal)
            button.addTarget(self, action: #selector(downloadVideo), for: .touchUpInside)
            var titleEdgeInsets = button.titleEdgeInsets
            titleEdgeInsets.right = -10
            button.titleEdgeInsets = titleEdgeInsets
            let rightBarButton = UIBarButtonItem(customView: button)
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
    
    private func playViedo() {
        guard let videoUrl = self.lesson?.videoUrl else  {
            return
        }
        
        var player: AVPlayer? {
            if downloadManager.checkFileExists(videoUrl: videoUrl) {
                let url = downloadManager.getFileUrlWith(videoUrl: videoUrl)
                let asset = AVAsset(url: url)
                return AVPlayer(playerItem: AVPlayerItem(asset: asset))
                
            } else {
                if let videoURL = URL(string: videoUrl) {
                    return AVPlayer(url: videoURL)
                }
            }
            return nil
        }
        
        let avPlayerVC = AVPlayerViewController()
        avPlayerVC.player = player
        present(avPlayerVC, animated: true) {
            avPlayerVC.player?.play()
        }
    }
    
    private func goToPreviousLessson() {
        let databaseManager = DatabaseManager.shared
        let lessons = databaseManager.fetch(VideoLesson.self)

        for (index, lessonData) in lessons.enumerated() {
            if lesson?.id == lessonData.id {
                var previousIndex = index - 1
                if previousIndex <= 0 {
                    previousIndex = lessons.count - 1
                }
                lesson = lessons[previousIndex]
                break
            }
        }
        containerView.setLessonDetails(lesson: lesson)
        showDowloadButtonIfNeeded()
    }
    
    private func goToNextLessson() {
        let databaseManager = DatabaseManager.shared
        let lessons = databaseManager.fetch(VideoLesson.self)
        
        for (index, lessonData) in lessons.enumerated() {
            if lesson?.id == lessonData.id {
                var nextIndex = index + 1
                if nextIndex >= lessons.count {
                    nextIndex = 0
                }
                lesson = lessons[nextIndex]
                break
            }
        }
        containerView.setLessonDetails(lesson: lesson)
        showDowloadButtonIfNeeded()
    }
}
