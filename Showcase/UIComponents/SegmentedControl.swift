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

struct SegmententValid<T: SegmentEnum> {
    let segment: T
    let valid: Bool
}

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
    
    func set(segmentValid: SegmententValid<T>) {
        activeBttns.first(where: {$0.tag == segmentValid.segment.rawValue})?.isEnabled = segmentValid.valid
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
    
    private func setupView() {
        let bttns = segments.map({ UIButton(segment: $0) })
        bttns.forEach({ $0.setupAsControlBttn() })
        activeBttns = bttns
    }
    
    private func setupBttnConstraints() {
        self.addSubview(horizontalBttnStackContainer)
        horizontalBttnStackContainer.snp.makeConstraints({ $0.edges.equalToSuperview() })
        for bttn in activeBttns {
            horizontalBttnStackContainer.addArrangedSubview(bttn)
            bttn.isSelected = false
            bttn.addTarget(self, action: #selector(clueBttnTapped(sender:)), for: .touchUpInside)
        }
        activeBttns.first?.isSelected = true
    }
    
    @objc func clueBttnTapped(sender: UIButton) {
        selectionVar.value = T(rawValue: sender.tag)
    }
    
    private func observeSelectedSegment() {
        selectionVar.asObservable().filterNil().subscribe(onNext: { [weak self] (segmentSelected) in
            guard let self = self,
                self.isEnabled else { return }
            for bttn in self.activeBttns {
                bttn.isSelected = false
            }
            self.activeBttns.first(where: {$0.tag == segmentSelected.rawValue})?.isSelected = true
        })
            .disposed(by: disposeBag)
    }
    
}
