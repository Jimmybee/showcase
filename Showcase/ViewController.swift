//
//  ViewController.swift
//  Showcase
//
//  Created by James Birtwell on 06/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let tableView = UITableView()
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NativeProvider().request(type: .posts, handleSuccess: handle, handleError: handleError)
        setupView()
        
    }

    func handle(posts: [Post]) {
        self.posts = posts
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func handleError(_ error: Error) {
        
    }
    
}

extension ViewController {
    private func setupView() {
        view.addSubview(tableView)
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

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = posts[indexPath.row].title
        return cell
    }
}

