//
//  ITunesSearchViewController.swift
//  Showcase
//
//  Created by James Birtwell on 09/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    convenience init(asset: UIImage.Asset) {
        self.init()
        let image = UIImage(asset: asset)
        setImage(image, for: .normal)
    }
}

extension UIImageView {
    convenience init(asset: UIImage.Asset) {
        self.init()
        image = UIImage(asset: asset)
    }
}

class ITunesSearchViewController: UIViewController {
    
    private let viewModel = ITunesSearchViewModel()
    private let iTunesHeader = ITunesHeader()
    private let searchBar = RNSearchBar()
    private let collectionViewBacking = UIImageView(asset: .iTunes_flipped_Bg)
    private let searchBarType = UIButton()
    private let searchBarActiveBacking = UIView()
    private let closeSearchBttn = UIButton(asset: .close_icn)
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 50, height: 50)
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return view
    }()
    private let resultsTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupStyle()
        setupCollectionView()
        viewModel.refreshView = refreshView
        registerNotificationObservers()
    }
    
    private func refreshView() {
        DispatchQueue.main.async {
            self.resultsTableView.reloadData()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private var guide: UILayoutGuide { return view.safeAreaLayoutGuide }

    private var seachBarInactive: [NSLayoutConstraint] = []
    private var seachBarActive: [NSLayoutConstraint] = []
    
    private func setupView() {
        view.backgroundColor = UIColor.lightGray
        view.addSubview(iTunesHeader)
        view.addSubview(searchBarActiveBacking)
        searchBarActiveBacking.addSubview(closeSearchBttn)
        view.addSubview(searchBarType)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(resultsTableView)
        view.insertSubview(collectionViewBacking, belowSubview: collectionView)

        constrainITunesHeader()
        constrainBacking()
        constrainCloseBttn()
        constrainSearchBar()
        constrainSearchBarTypeButton()
        constrainCollectionView()
        constrainResultsTableView()
    }
    
    var callOnceAfterLayout = [VoidFunction]()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        callOnceAfterLayout.forEach{ $0() }
        callOnceAfterLayout.removeAll()
    }
}

// MARK: Setup Constraints
extension ITunesSearchViewController {
    private func constrainITunesHeader() {
        let setView = iTunesHeader
        setView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            setView.topAnchor.constraint(equalTo: view.topAnchor),
            setView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            setView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            setView.bottomAnchor.constraint(equalTo: guide.centerYAnchor)
            ])
    }
    
    private func constrainBacking() {
        let setView = searchBarActiveBacking
        setView.translatesAutoresizingMaskIntoConstraints = false
        let backingExpanded = setView.bottomAnchor.constraint(equalTo: searchBarType.bottomAnchor, constant: Padding.medium.rawValue)
        let topExpanded = setView.topAnchor.constraint(equalTo: view.topAnchor)
        let backingCollapsed = setView.heightAnchor.constraint(equalToConstant: 50)
        let bottomCollapsed = setView.bottomAnchor.constraint(equalTo: view.topAnchor)
        
        NSLayoutConstraint.activate([
            backingCollapsed,
            bottomCollapsed,
            setView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            setView.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
            ])
        seachBarActive.append(backingExpanded)
        seachBarActive.append(topExpanded)
        seachBarInactive.append(backingCollapsed)
        seachBarInactive.append(bottomCollapsed)
    }
    
    private func constrainCloseBttn() {
        let setView = closeSearchBttn
        closeSearchBttn.translatesAutoresizingMaskIntoConstraints = false
        guard let superViewGuide = closeSearchBttn.superview?.safeAreaLayoutGuide else {
            ClientError.unknownError("View not added").log()
            return
        }
        let searchActiveTop = setView.topAnchor.constraint(equalTo: guide.topAnchor, constant: Padding.margin.rawValue)
        let searchInActiveTop = setView.bottomAnchor.constraint(equalTo: superViewGuide.topAnchor, constant: 0)
        NSLayoutConstraint.activate([
            searchInActiveTop,
            setView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: Padding.margin.rawValue)
            ])
        seachBarActive.append(searchActiveTop)
        seachBarInactive.append(searchInActiveTop)
        
    }
    
    private func constrainSearchBarTypeButton() {
        let setView = searchBarType
        setView.clipsToBounds = true
        let activeHeight = setView.heightAnchor.constraint(equalToConstant: 40)
        let inactiveHeight = setView.heightAnchor.constraint(equalToConstant: 0)
        setView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            setView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            inactiveHeight,
            setView.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor, constant: Padding.medium.rawValue),
            setView.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: -Padding.medium.rawValue)
            ])
        
        seachBarActive.append(activeHeight)
        seachBarInactive.append(inactiveHeight)
    }
    
    private func constrainSearchBar() {
        let setView = searchBar
        setView.translatesAutoresizingMaskIntoConstraints = false
        let middleAnchor = setView.bottomAnchor.constraint(equalTo: guide.centerYAnchor)
        let topAnchor = setView.centerYAnchor.constraint(equalTo: closeSearchBttn.centerYAnchor)
        let inactivatedLeading = setView.leadingAnchor.constraint(equalTo: guide.leadingAnchor)
        let activatedLeading = setView.leadingAnchor.constraint(equalTo: closeSearchBttn.leadingAnchor, constant: Padding.margin.rawValue)
        let inactiveHeight = setView.heightAnchor.constraint(equalToConstant: 80)
        let activeHeight = setView.heightAnchor.constraint(equalToConstant: 60)
        
        NSLayoutConstraint.activate([
            middleAnchor,
            inactiveHeight,
            inactivatedLeading,
            setView.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
            ])
        seachBarActive.append(topAnchor)
        seachBarActive.append(activatedLeading)
        seachBarActive.append(activeHeight)
        
        seachBarInactive.append(middleAnchor)
        seachBarInactive.append(inactivatedLeading)
        seachBarInactive.append(inactiveHeight)
        
    }
    
    private func constrainCollectionView() {
        let setView = collectionView
        setView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            setView.topAnchor.constraint(equalTo: iTunesHeader.bottomAnchor),
            setView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            setView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            setView.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
            ])
        
        let backing = collectionViewBacking
        backing.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backing.topAnchor.constraint(equalTo: setView.topAnchor),
            backing.bottomAnchor.constraint(equalTo: setView.bottomAnchor),
            backing.leadingAnchor.constraint(equalTo: setView.leadingAnchor),
            backing.trailingAnchor.constraint(equalTo: setView.trailingAnchor)
            ])
    }
    
    private func constrainResultsTableView() {
        let setView = resultsTableView
        setView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            setView.topAnchor.constraint(equalTo: searchBarActiveBacking.bottomAnchor),
            setView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            setView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            setView.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
            ])
    }
    
    private func setupStyle() {
        collectionView.backgroundColor = UIColor(white: 1, alpha: 0)
        
        searchBar.delegate = self
        
        searchBarType.layer.cornerRadius = 10
        searchBarType.clipsToBounds = true
        searchBarType.setTitle(ITunesStrings.artist.localized, for: .normal)
        searchBarType.backgroundColor = .white
        searchBarType.setTitleColor(.darkGray, for: .normal)
        
        searchBarActiveBacking.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
        
        closeSearchBttn.tintColor = .white
        closeSearchBttn.addTarget(self, action: #selector(handleCloseTap), for: .touchUpInside)
        
        resultsTableView.alpha = 0
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier())
        
        callOnceAfterLayout.append { [weak self] in
            guard let self = self else { return }
            let layout = (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout)
            layout.itemSize = CGSize(width: self.view.bounds.width / 3 - 1, height: self.collectionView.bounds.height / 2 - 1)
        }
    }
}

//MARK: Action Handlers
extension ITunesSearchViewController {
    @objc private func handleCloseTap() {
        searchBar.searchTermTextField.resignFirstResponder()
    }
}

extension ITunesSearchViewController: RNSearchBarDelegate {
    func handle(error: Error) {
        
    }
    
    func handle(searchTerm: String) {
        viewModel.handleSearch(term: searchTerm)
    }
    
    func searchIs(active: Bool) {
        if active {
            seachBarInactive.forEach{ $0.isActive = false }
            seachBarActive.forEach{ $0.isActive = true }
        } else {
            seachBarActive.forEach{ $0.isActive = false }
            seachBarInactive.forEach{ $0.isActive = true }
        }

        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.resultsTableView.alpha = active ? 1 : 0
            self.view.layoutIfNeeded()
        }
    }
}

extension ITunesSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier(), for: indexPath) as! CategoryCollectionViewCell
        cell.category = viewModel.categories[indexPath.row]
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.handleCollection(indexPath: indexPath)
    }
    
}

extension ITunesSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.searchResults[indexPath.row].artistName
        return cell
    }
}

extension ITunesSearchViewController {
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            resultsTableView.contentInset  = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        }
    }
    
    @objc func keyboardDidHide(_ notification: NSNotification) {
        resultsTableView.contentInset = .zero
    }
    
    func registerNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidHide),
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )
    }
}
extension UIView {
    var topSafeArea : CGFloat {
        var height: CGFloat = 0
        if #available(iOS 11, *) { // iPhone X basically
            height += UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        }
        return height
    }
    
    var bottomSafeArea : CGFloat {
        var height: CGFloat = 0
        if #available(iOS 11, *) { // iPhone X basically
            height += UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        }
        return height
    }
}

public extension UICollectionViewCell {
    
    class func identifier() -> String {
        return String(describing: self)
    }
    
}
typealias VoidFunction = () -> ()
