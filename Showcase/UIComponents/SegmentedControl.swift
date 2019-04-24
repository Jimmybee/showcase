//
//  SegmentedControl.swift
//  Showcase
//
//  Created by James Birtwell on 23/04/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import RxCocoa

class SegmentedControl<T: SegmentEnum>: UIView {
    
    private var segments: [T]
    private var activeBttns = [UIButton]()
    private let disposeBag = DisposeBag()
    
    var selectionVar = Variable<T?>(nil)
    var isEnabled: Bool = true {
        didSet {
            activeBttns.forEach({ $0.isEnabled = self.isEnabled })
        }
    }
    
    func set(segment: T, as enabled: Bool) {
        activeBttns[segment.rawValue].isEnabled = enabled
        guard let selectedValue = selectionVar.value else { return }
        if activeBttns[selectedValue.rawValue].isEnabled == false {
            for button in activeBttns {
                if button.isEnabled == true {
                    selectionVar.value = T(rawValue: button.tag)
                    return
                }
            }
        }
    }
    
    private var horizontalBttnStackContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    init(frame: CGRect = .zero, segments: [T], spacing: CGFloat = 0) {
        self.segments = segments
        super.init(frame: CGRect.zero)
        setupView()
        setupBttnConstraints()
        observeSelectedSegment()
        horizontalBttnStackContainer.spacing = spacing

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    private func setupView() {
        let bttns = segments.map({ UIButton(title: $0.title) })
        bttns.forEach({ $0.setupAsControlBttn() })
        activeBttns = bttns
    }
    
    private func setupBttnConstraints() {
        self.addSubview(horizontalBttnStackContainer)
        horizontalBttnStackContainer.snp.makeConstraints({ $0.edges.equalToSuperview() })
        for (index ,bttn) in activeBttns.enumerated() {
            horizontalBttnStackContainer.addArrangedSubview(bttn)
            bttn.tag = index
            bttn.isSelected = false
            bttn.addTarget(self, action: #selector(clueBttnTapped(sender:)), for: .touchUpInside)
        }
        activeBttns.first?.isSelected = true
    }
    
    @objc func clueBttnTapped(sender: UIButton) {
        selectionVar.value = T(rawValue: sender.tag)
    }
    
    private func observeSelectedSegment() {
        selectionVar.asObservable().filterNil().subscribe(onNext: { (bttnSelected) in
            if !self.isEnabled { return }
            for bttn in self.activeBttns {
                bttn.isSelected = false
            }
            self.activeBttns[bttnSelected.rawValue].isSelected = true
        })
            .disposed(by: disposeBag)
    }
    
}
