//
//  ViewController.swift
//  Showcase
//
//  Created by James Birtwell on 06/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import UIKit

class PostsListViewController: UIViewController {
    
    let tableView = UITableView()
    let viewModel: PostListViewModel
    
    init(viewModel: PostListViewModel) {
        self.viewModel =  viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.refreshView = refreshView
    }
    
   
    private func refreshView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension PostsListViewController {
    private func setupView() {
        view.addSubview(tableView)
        navigationItem.title = PlaceholderStrings.posts_list.localized
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let guide = view.layoutMarginsGuide
        tableView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    }
}

extension PostsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        logD("Loading table with \(viewModel.posts.count) rows")
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.posts[indexPath.row].title
        return cell
    }
}

