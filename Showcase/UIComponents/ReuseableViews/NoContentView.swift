//
//  NoContentView.swift
//  Showcase
//
//  Created by James Birtwell on 15/05/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NoContentView: ReusableViewFromXib {

    @IBOutlet weak var noConentLabel: UILabel!
    @IBOutlet weak var noContentBttn: UIButton!
    
    var action: Driver<Void> {
        return noContentBttn.rx.tap.asDriver()
    }
    
}
