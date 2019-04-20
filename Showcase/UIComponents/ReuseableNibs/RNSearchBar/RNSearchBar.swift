//
//  RCSearchBar.swift
//  Showcase
//
//  Created by James Birtwell on 09/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import Foundation
import UIKit

protocol RNSearchBarDelegate: class {
    func searchIs(active: Bool)
    func handle(searchTerm: String)
}

class RNSearchBar: ReusableViewFromXib {
    
    var active: Bool = false {
        didSet {
            delegate?.searchIs(active: active)
            if active == false { searchTermTextField.text = "" }
        }
    }
    
    var closedWidth: CGFloat {
        return searchIcon.frame.width + (searchIcon.constraints.first!.constant)
    }
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var searchIcon: UIImageView!
    @IBOutlet weak var searchTermTextField: UITextField!
    weak var delegate: RNSearchBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        searchTermTextField.autocapitalizationType = .none
        searchTermTextField.autocorrectionType = .no
        searchTermTextField.returnKeyType = .done
        searchTermTextField.delegate = self
        self.searchTermTextField.addTarget(self, action: #selector(textDidChange), for: UIControl.Event.editingChanged)

        borderView.layer.cornerRadius = borderView.frame.height / 4
        
        let action = #selector(changeIsActive)
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    @objc func changeIsActive() {
        if active {
            searchTermTextField.resignFirstResponder()
        } else {
            searchTermTextField.becomeFirstResponder()
        }
    }
    
    @objc func textDidChange() {
        guard let term = searchTermTextField.text,
        term.count > 2 else {
            return
        }
        delegate?.handle(searchTerm: term)
    }
}

extension RNSearchBar: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        active = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        active = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTermTextField.resignFirstResponder()
        return true
    }
}
