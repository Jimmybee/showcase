//
//  LoadingBarView.swift
//  Showcase
//
//  Created by James Birtwell on 11/05/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import UIKit
import SnapKit

class LoadingBarView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let indicator = UIView()
    var animating = false
    
    var widthForLinearBar: CGFloat {
        return superview?.frame.width ?? UIScreen.main.bounds.width
    }
    
    var heightForLinearBar: CGFloat {
        return 5
    }
    
    private func setup() {
        self.backgroundColor = .white
        let backgroundView = UIView()
        backgroundView.backgroundColor = .blue
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        indicator.backgroundColor = .red
        addSubview(indicator)
    }
    
    func startAnimating() {
        animating = true
        snp.updateConstraints({ $0.height.equalTo(5) })
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.layoutIfNeeded()
        }) { [weak self] (_) in
            self?.animatePartA()
        }
    }
    
    func stopAnimating() {
        animating = false
        snp.updateConstraints({ $0.height.equalTo(0) })
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.layoutIfNeeded()
        }) { (_) in
            self.indicator.frame = .zero
        }
    }
    
    private func animatePartA() {
        guard let superview = self.superview,
            animating else { return }
        self.indicator.frame = CGRect(x: 0, y: 0, width: 0, height: self.heightForLinearBar)
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [.calculationModeLinear], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.indicator.frame = CGRect(x: 0, y: 0, width: self.widthForLinearBar*0.7, height: self.heightForLinearBar)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.indicator.frame = CGRect(x: superview.frame.width, y: 0, width: self.widthForLinearBar*0.7, height: self.heightForLinearBar)
            })
            
        }) { [weak self](completed) in
            self?.animatePartB()
        }
    }
    
    private func animatePartB() {
        guard let superview = self.superview,
            animating else { return }
        self.indicator.frame = CGRect(x: -self.widthForLinearBar*0.7, y: 0, width: self.widthForLinearBar*0.7, height: self.heightForLinearBar)
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.indicator.frame = CGRect(x: 0, y: 0, width: self.widthForLinearBar*0.7, height: self.heightForLinearBar)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.indicator.frame = CGRect(x: superview.frame.width, y: 0, width: self.widthForLinearBar*0.05, height: self.heightForLinearBar)
            })
            
        }) { [weak self] (completed) in
            self?.animatePartA()
        }
    }
}
