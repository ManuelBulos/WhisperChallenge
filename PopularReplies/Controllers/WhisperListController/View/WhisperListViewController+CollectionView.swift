//
//  WhisperListViewController+CollectionView.swift
//  PopularReplies
//
//  Created by Jose Manuel Solis Bulos on 28/06/19.
//  Copyright © 2019 manuelbulos. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDataSource

extension WhisperListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return presenter.whisperList?.count ?? 0
    }

    // UICollectionViewCell
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WhisperCollectionViewCell.identifier,
                                                            for: indexPath) as? WhisperCollectionViewCell else {
                                                                fatalError("Failed to instantiate WhisperCollectionViewCell")
        }
        cell.set(whisper: presenter.getWhisper(at: indexPath), showReplyArrow: presenter.parentWhisper != nil)
        return cell
    }

    // UICollectionViewHeader
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                           withReuseIdentifier: WhisperCollectionViewCell.identifier,
                                                                           for: indexPath) as? WhisperCollectionViewCell else {
                                                                            fatalError("Failed to instantiate Header ")
        }
        header.set(whisper: presenter.parentWhisper)
        return header
    }
}

// MARK: - UICollectionViewDelegate

extension WhisperListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if presenter.parentWhisper == nil {
            presenter.didSelectWhisper(at: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let cell = cell as? WhisperCollectionViewCell
        cell?.cancelDownloadTask()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension WhisperListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if presenter.parentWhisper != nil {
            let width = (collectionView.frame.width) - 6
            return CGSize(width: width, height: width / 1.25)
        } else {
            let width = (collectionView.frame.width / 2) - 6
            return CGSize(width: width, height: width * 1.5)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if presenter.parentWhisper != nil {
            let width = collectionView.frame.width - 6
            return CGSize(width: width, height: width)
        } else {
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
}
