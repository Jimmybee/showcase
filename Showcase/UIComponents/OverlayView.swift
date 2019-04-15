//
//  OverlayView.swift
//  Showcase
//
//  Created by James Birtwell on 14/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import UIKit

class OverlayView: UIView {
    
    var viewTapped: ((Double) -> ())?
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        addGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    static func defaultView() -> OverlayView {
        let view = OverlayView(frame: .zero)
        view.backgroundColor = UIColor.blue
        view.alpha = 0.7
        return view
    }
    
    func withViewTap(_ viewTapped: @escaping (Double) -> ()) -> OverlayView {
        self.viewTapped = viewTapped
        return self
    }
    
    func addGesture() {
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapGesture))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapGesture() {
        viewTapped?(0.2)
    }
    
}



