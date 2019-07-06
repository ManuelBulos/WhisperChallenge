//
//  WhisperListPresenterDelegate.swift
//  PopularReplies
//
//  Created by Jose Manuel Solis Bulos on 28/06/19.
//  Copyright © 2019 manuelbulos. All rights reserved.
//

import UIKit

protocol WhisperListPresenterDelegate: AnyObject {
    func setTitle(_ title: String)
    func addSubviews()
    func displayAlert(error: Error)
    func displayLoadingIndicator()
    func pushViewController(_ viewController: UIViewController)

    func didFinishFetchingWhisperList()
    func didFailToFindWhisper(at indexPath: IndexPath)
}
