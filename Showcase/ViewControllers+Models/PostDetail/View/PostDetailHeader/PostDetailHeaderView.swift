//
//  PostDetailHeaderView.swift
//  Showcase
//
//  Created by James Birtwell on 12/05/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PostDetailHeaderView: ReusableViewFromXib {
    typealias Model = (userName: String, postTitle: String, postBody: String, commentCount: Observable<Int>)

    let bag = DisposeBag()
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postBodyLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    
    func setup(model: Model) {
        userNameLabel.text = model.userName
        postTitleLabel.text = model.postTitle
        postBodyLabel.text = model.postBody
        model.commentCount
            .map { (count) -> String in
                let withCount = String(format: PlaceholderStrings.comment_count.localized, arguments: [count])
                return count == 0 ? PlaceholderStrings.no_comments.localized : withCount
            }
            .startWith(PlaceholderStrings.loading_comments.localized)
            .catchErrorJustReturn(PlaceholderStrings.failed_loading.localized)
            .debug("commentCount")
            .bind(to: commentCountLabel.rx.text)
            .disposed(by: bag)
    }
}
