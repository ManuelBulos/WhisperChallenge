//
//  WhisperCollectionViewCell.swift
//  PopularReplies
//
//  Created by Jose Manuel Solis Bulos on 27/06/19.
//  Copyright © 2019 manuelbulos. All rights reserved.
//

import UIKit

class WhisperCollectionViewCell: UICollectionViewCell {

    // MARK: - UI

    private lazy var upArrowLabel: UILabel = {
        let upArrowLabel = UILabel()
        upArrowLabel.translatesAutoresizingMaskIntoConstraints = false
        upArrowLabel.textAlignment = .center
        upArrowLabel.text = "⬆️"
        return upArrowLabel
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: bounds)
        imageView.kf.indicatorType = .activity
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var me2Label: UILabel = {
        let me2Label = UILabel()
        me2Label.translatesAutoresizingMaskIntoConstraints = false
        me2Label.textAlignment = .center
        return me2Label
    }()

    // MARK: - Properties
    
    var me2: Int? {
        didSet {
            me2Label.text = "♥️ \(me2 ?? 0)"
        }
    }

    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(upArrowLabel)
        upArrowLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        upArrowLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        upArrowLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        upArrowLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true

        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: upArrowLabel.bottomAnchor, constant: 8).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24).isActive = true

        addSubview(me2Label)
        me2Label.heightAnchor.constraint(equalToConstant: 16).isActive = true
        me2Label.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        me2Label.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        me2Label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    // MARK: - Public Functions

    func set(whisper: Whisper?, showReplyArrow: Bool = false) {
        if let urlString = whisper?.url, let url = URL(string: urlString) {
            imageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
            me2 = whisper?.me2
        } else {
            imageView.image = nil
            me2 = nil
        }
        upArrowLabel.isHidden = !showReplyArrow
    }

    func cancelDownloadTask() {
        imageView.kf.cancelDownloadTask()
    }
}
