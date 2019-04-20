//
//  ITunesSearchViewModel.swift
//  Showcase
//
//  Created by James Birtwell on 11/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import UIKit

protocol ITunesSearchViewModelDelegate {
    func refreshTableData()
    func handle(error: Error)
    func handle(pushTo: UIViewController)
}

class ITunesSearchViewModel {
    
    let categories = MusicCategory.allCases
    let provider = NativeProvider.shared
    var task: URLSessionDataTask?
    
    var searchResults = [MusicAlbum]() {
        didSet {
           delegate?.refreshTableData()
        }
    }
    var delegate: ITunesSearchViewModelDelegate?

    func handleCollection(indexPath: IndexPath) {
        let category = categories[indexPath.row]
        let route = iTunesRouter.genre(index: category.rawValue)
        NativeProvider.shared.codableRequest(type: route, handleSuccess: handleData, handleError: handleError)
    }
    
    let searchDispatchGroup = DispatchGroup()
    var query: ITunesSearchQuery?
    
    func handleSearch(term: String) {
        searchDispatchGroup.enter()
        if query == nil {
            DispatchQueue.global(qos: .userInitiated).async {
                self.searchDispatchGroup.wait()
                self.sendRequest()
            }
        }
        query = ITunesSearchQuery(term: term, attribute: .artistTerm)
        delay(0.3) {
            self.searchDispatchGroup.leave()
        }
    }
    
    private func sendRequest() {
        task?.cancel()
        let route = iTunesRouter.search(query: query!)
        task = provider.codableRequest(type: route, handleSuccess: handleWrapper, handleError: handleError)
        query = nil
    }
    
    func handleWrapper(wrapper: MusicAlbumWrapper) {
        searchResults = wrapper.results
        task = nil
    }
    
    func handleData(response: ServerResponse) {
        DispatchQueue.main.async { [weak self] in
            let vm = ITunesAlbumListViewModel(albums: response.musicAlbums)
            let vc = ITunesAlbumListViewController(viewModel: vm)
            self?.delegate?.handle(pushTo: vc)
        }
        task = nil
    }
    
    func handleError(error: Error) {
        delegate?.handle(error: error)
    }
    
}

public func delay(_ delay: Double, queue: DispatchQueue = DispatchQueue.main, closure: @escaping ()->()) {
    queue.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
