//
//  WhisperListPresenter.swift
//  PopularReplies
//
//  Created by Jose Manuel Solis Bulos on 27/06/19.
//  Copyright © 2019 manuelbulos. All rights reserved.
//

import UIKit

class WhisperListPresenter: WhisperListPresenterProtocol {

    // MARK: - Types

    enum Error: Swift.Error, LocalizedError {
        case whisperNotFound
        case imageForWhisperNotFound
        case pathNotFound

        var errorDescription: String? {
            switch self {
            case .whisperNotFound: return "Failed to find whisper"
            case .imageForWhisperNotFound: return "Failed to find image for whisper"
            case .pathNotFound: return "Failed to find path for whisper"
            }
        }
    }

    typealias ReplyChain = [Whisper]

    // MARK: - Properties

    weak var delegate: WhisperListPresenterDelegate?

    var whisperService: WhisperServiceProtocol

    var whisperList: [Whisper]?

    var parentWhisper: Whisper?

    let title: String

    let dispatchGroup: DispatchGroup = DispatchGroup()

    required init(title: String, whisperService: WhisperServiceProtocol, parentWhisper: Whisper? = nil) {
        self.title = title
        self.parentWhisper = parentWhisper
        self.whisperService = whisperService
    }

    func viewDidLoad() {
        delegate?.setTitle(title)
        delegate?.addSubviews()
    }

    func getWhisper(at indexPath: IndexPath) -> Whisper? {
        if whisperList?.indices.contains(indexPath.item) ?? false {
            return whisperList?[indexPath.item]
        } else {
            return nil
        }
    }

    func didSelectWhisper(at indexPath: IndexPath) {
        if let whisper = getWhisper(at: indexPath) {
            guard let title: String = whisper.nickname else { return }
            let presenter = WhisperListPresenter(title: title, whisperService: whisperService, parentWhisper: whisper)
            let popularListViewController = WhisperListViewController(presenter: presenter)
            delegate?.pushViewController(popularListViewController)
        } else {
            delegate?.didFailToFindWhisper(at: indexPath)
        }
    }

    func fetchWhisperList(showOnlyDirectReplies: Bool) {
        delegate?.displayLoadingIndicator()
        if let whisper = parentWhisper, !showOnlyDirectReplies {
            downloadTree(root: whisper) { [weak self] (tree) in
                guard let sum = self?.rootToLeafSum(root: whisper) else { return }
                guard let hasSum = self?.hasPathSum(root: whisper, sum: sum) else { return }
                print("path has sum of \(sum): ", hasSum)
            }
        } else {
            // shows direct replies to parent if parentWhisper is not nil, otherwise shows a list of popular wishes
            whisperService.fetchWhisperList(for: parentWhisper) { [weak self] (result)  in
                guard let self = self else { return }
                switch result {
                case .success(let whisperList):
                    self.whisperList = whisperList
                    self.delegate?.didFinishFetchingWhisperList()
                case .failure(let error):
                    self.delegate?.displayAlert(error: error)
                }
            }
        }
    }

    func downloadTree(root: Whisper, completion: @escaping ((Whisper) -> Void)) {
        getChildren(for: root)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dispatchGroup.notify(queue: .main) {
                completion(root)
            }
        }
    }

    func getChildren(for root: Whisper) {
        self.dispatchGroup.enter()
        whisperService.fetchWhisperList(for: root) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let children):
                print("root: ", root, "children: ", children, "\n")
                root.children = children
                for child in children {
                    self.getChildren(for: child)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.dispatchGroup.leave()
        }
    }
}

// MARK: - N-ary tree functions

extension WhisperListPresenter {
    // First we find the maximum sum
    func rootToLeafSum(root: Whisper?) -> Int {
        // if node is null return 0
        if root == nil { return 0 }
        // sum of all the childrens
        let mappedChildren = root?.children?.map({ rootToLeafSum(root: $0) })
        // find the child with the greatest value
        let maximumChild = mappedChildren?.sorted(by:{ $0 > $1 }).first ?? 0
        // child value non optional
        let rootValue = root?.me2 ?? 0
        // final sum
        let sum = maximumChild + rootValue
        return sum
    }

    // Then, we find the path with the given sum
    func hasPathSum(root: Whisper?, sum: Int) -> Bool {
        // if node is null return sum == 0
        guard let root = root else { return sum == 0 }
        // child value non optional
        let value = root.me2 ?? 0
        // substract value from sum
        let subSum = sum - value
        // if subSum reaches 0 it means we found the leaf for the given sum
        if subSum == 0 {
            didFindLeaf(root)
            return true
        }
        // an array of booleans indicating if the node has path sum
        if let conditionCollection = root.children?.map({ hasPathSum(root: $0, sum: subSum) }) {
            let hasSum = conditionCollection.filter { (condition) -> Bool in
                return condition
            }.count > 0
            return hasSum
        } else {
            return false
        }
    }

    // Finally, the recursive function "hasPathSum" calls this function when finished
    func didFindLeaf(_ leaf: Whisper) {
        if !(whisperList?.isEmpty ?? true) { return }
        // variable to store the leaf's parents
        var replyChain: [Whisper]? = [Whisper]()
        // recursive function to reach root
        getParent(for: leaf, replyChain: &replyChain)
        // remove root
        if let parentWhisper = parentWhisper, let index = replyChain?.firstIndex(of: parentWhisper) { replyChain?.remove(at: index) }
        // reverse the order
        guard let replyChainNoRoot = replyChain?.reversed() else { return }
        // set new reply chain as our whisperList
        whisperList = Array(replyChainNoRoot)
        // call method to update collection view
        delegate?.didFinishFetchingWhisperList()
        // print path
        print("Root: \(parentWhisper?.wid ?? String()) PATH : \n",
            whisperList?.map({ "ID: \($0.wid ?? String()) hearts: \($0.me2 ?? 0)" }) ?? String())
    }

    func getParent(for leaf: Whisper, replyChain: inout [Whisper]? = nil) {
        // append the node
        replyChain?.append(leaf)
        // if node  has parent we call this function again
        guard let parent = leaf.parent else { return }
        // keep appending nodes
        getParent(for: parent, replyChain: &replyChain)
    }

    // Simple N-ary tree sample
    func mockNaryTree() -> Whisper {
        let root = Whisper(me2: 0)

        let first = Whisper(me2: 1)
        let second = Whisper(me2: 2)
        let third = Whisper(me2: 3)
        second.add(child: third)
        first.add(child: second)
        root.add(child: first)

        let a = Whisper(me2: 5)
        let b = Whisper(me2: 5)
        let c = Whisper(me2: 5)
        b.add(child: c)
        a.add(child: b)
        root.add(child: a)

        let x = Whisper(me2: 45)
        b.add(child: x)

        return root
    }
}
