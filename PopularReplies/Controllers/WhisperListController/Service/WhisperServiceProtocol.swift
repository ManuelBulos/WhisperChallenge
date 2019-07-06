//
//  WhisperServiceProtocol.swift
//  PopularReplies
//
//  Created by Jose Manuel Solis Bulos on 27/06/19.
//  Copyright © 2019 manuelbulos. All rights reserved.
//

import Foundation

protocol WhisperServiceProtocol: AnyObject {
    typealias Callback = (Result<[Whisper], Swift.Error>) -> Void

    init(limit: Int)

    func fetchWhisperList(for whisper: Whisper?, completion: @escaping Callback)
}
