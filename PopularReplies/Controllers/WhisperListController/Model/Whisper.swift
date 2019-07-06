//
//  Whisper.swift
//  PopularReplies
//
//  Created by Jose Manuel Solis Bulos on 27/06/19.
//  Copyright © 2019 manuelbulos. All rights reserved.
//

import Foundation

class Whisper: Codable {

    // MARK: - JSON object properties

    let wid: String?

    let url: String?

    let text: String?

    let me2: Int?

    let replies: Int = .zero

    let nickname: String?

    // MARK: - N-ary tree properties

    weak var parent: Whisper?

    var children: [Whisper]? {
        didSet {
            children?.forEach({ $0.parent = self })
        }
    }

    init(me2: Int) {
        self.wid = nil
        self.url = nil
        self.text = nil
        self.me2 = me2
        self.nickname = nil
        self.parent = nil
        self.children = [Whisper]()
    }
}

extension Whisper {
    func add(child: Whisper) {
        if children == nil {
            children = [child]
        } else {
            self.children?.append(child)
        }
        child.parent = self
    }
}

extension Whisper: CustomStringConvertible, Hashable {
    static func == (lhs: Whisper, rhs: Whisper) -> Bool {
        return lhs.wid == rhs.wid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(wid)
    }

    var description: String {
        return wid ?? String()
    }
}
