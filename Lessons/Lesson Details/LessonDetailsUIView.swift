//
//  LessonDetailsUIView.swift
//  Lessons
//
//  Created by Mayur Shrivas on 07/01/23.
//

import UIKit
import SnapKit
import Kingfisher

final class LessonDetailsUIView: UIView {
    
    let previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.tintColor = .white
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .left
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        return label
    }()
    
    let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitle("Previous lesson", for: .normal)
        button.setImage(UIImage.init(systemName: "chevron.left"), for: .normal)
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.semanticContentAttribute = .forceRightToLeft
        button.setTitle("Next lesson", for: .normal)
        button.setImage(UIImage.init(systemName: "chevron.right"), for: .normal)
        return button
    }()
        
    var playButtonCallback: (() -> Void)?
    var previousButtonCallback: (() -> Void)?
    var nextButtonCallback: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        createInitialUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createInitialUI() {
        //previewImageView
        addSubview(previewImageView)
        previewImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(220)
        }
        
        //playButton
        addSubview(playButton)
        playButton.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        playButton.snp.makeConstraints { make in
            make.center.equalTo(previewImageView.snp.center)
            make.width.height.equalTo(50)
        }
        
        //titleLabel
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(previewImageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        //bodyLabel
        addSubview(bodyLabel)
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        //previousButton
        addSubview(previousButton)
        previousButton.addTarget(self, action: #selector(previousButtonAction), for: .touchUpInside)
        previousButton.snp.makeConstraints { make in
            make.top.equalTo(bodyLabel.snp.bottom).offset(15)
            make.leading.equalTo(titleLabel)
        }
        
        //nextButton
        addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        nextButton.snp.makeConstraints { make in
            make.centerY.equalTo(previousButton.snp.centerY)
            make.trailing.equalTo(titleLabel)
        }

    }
    
    func setLessonDetails(lesson: VideoLesson?) {
        guard let lesson = lesson else {
            return
        }
        titleLabel.text = lesson.name
        bodyLabel.text = lesson.details
        previewImageView.kf.setImage(with: URL(string: lesson.thumbnail))
    }
    
    //MARK: Actions -
    
    @objc func playButtonAction() {
        playButtonCallback?()
    }
    
    @objc func previousButtonAction() {
        previousButtonCallback?()
    }
    
    @objc func nextButtonAction() {
        nextButtonCallback?()
    }
}
