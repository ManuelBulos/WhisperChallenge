//
//  WhisperListViewController.swift
//  PopularReplies
//
//  Created by Jose Manuel Solis Bulos on 27/06/19.
//  Copyright © 2019 manuelbulos. All rights reserved.
//

import UIKit
import Kingfisher

class WhisperListViewController: UIViewController {

    // MARK: - UI

    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())

        collectionView.register(WhisperCollectionViewCell.self,
                                forCellWithReuseIdentifier: WhisperCollectionViewCell.identifier)

        collectionView.register(WhisperCollectionViewCell.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: WhisperCollectionViewCell.identifier)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    // MARK: - Properties

    let presenter: WhisperListPresenterProtocol

    // MARK: - Life Cycle

    init(presenter: WhisperListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        presenter.fetchWhisperList(showOnlyDirectReplies: false) // true = shows direct replies to parent || false = shows the max path sum
    }
}

// MARK: - WhisperListPresenterDelegate

extension WhisperListViewController: WhisperListPresenterDelegate {
    func setTitle(_ title: String) {
        self.title = title
    }

    func addSubviews() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        collectionView.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
    }

    func displayLoadingIndicator() {
        activityIndicator.startAnimating()
    }

    func didFinishFetchingWhisperList() {
        activityIndicator.stopAnimating()
        collectionView.reloadData()
    }

    func displayAlert(error: Error) {
        let title = "Sorry, something went wrong"
        let message = error.localizedDescription
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

    func didFailToFindWhisper(at indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? WhisperCollectionViewCell
        cell?.set(whisper: nil)
    }

    func pushViewController(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
