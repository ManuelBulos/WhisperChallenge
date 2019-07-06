//
//  WhisperListPresenterProtocol.swift
//  PopularReplies
//
//  Created by Jose Manuel Solis Bulos on 28/06/19.
//  Copyright © 2019 manuelbulos. All rights reserved.
//

import Foundation

protocol WhisperListPresenterProtocol: AnyObject {
    init(title: String, whisperService: WhisperServiceProtocol, parentWhisper: Whisper?)

    var delegate: WhisperListPresenterDelegate? { get set }
    var whisperService: WhisperServiceProtocol { get set }
    var whisperList: [Whisper]? { get set }
    var parentWhisper: Whisper? { get }

    func viewDidLoad()
    func fetchWhisperList(showOnlyDirectReplies: Bool)
    func didSelectWhisper(at indexPath: IndexPath)
    func getWhisper(at indexPath: IndexPath) -> Whisper?
}
