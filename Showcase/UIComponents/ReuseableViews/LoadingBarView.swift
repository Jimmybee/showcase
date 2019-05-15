//
//  LoadingBarView.swift
//  Showcase
//
//  Created by James Birtwell on 11/05/2019.
//  Copyright © 2019 James Birtwell. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

extension Reactive where Base: LoadingBarView {
    var animating: ControlProperty<Bool> {
        return controlProperty(editingEvents: UIControl.Event.valueChanged,
                               getter: { $0.animating },
                               setter: { $0.animating = $1 })
    }
}

class LoadingBarView: UIControl {
    
    private let indicator = UIView()
    private let bag = DisposeBag()
    
    var animating = false  {
        didSet {
            sendActions(for: .valueChanged)
        }
    }
    var widthForLinearBar: CGFloat {
        return superview?.frame.width ?? UIScreen.main.bounds.width
    }
    var heightForLinearBar: CGFloat = 5
    var widthMultiplerLargeBar: CGFloat = 0.7
    var widthMultiplierSmallBar: CGFloat = 0.05
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .white
        let backgroundView = UIView()
        backgroundView.backgroundColor = .lightGray
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        indicator.backgroundColor = .blue
        addSubview(indicator)
        observeAnimating()
    }
    
    private func observeAnimating() {
        rx.animating.distinctUntilChanged()
            .subscribe(onNext: { [weak self] (animate) in
                guard let self = self else { return }
                animate ? self.startAnimating() : self.stopAnimating()
            }).disposed(by: bag)
    }
    
    private func startAnimating() {
        snp.updateConstraints({ $0.height.equalTo(heightForLinearBar) })
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.layoutIfNeeded()
        }) { [weak self] (_) in
            self?.animatePartA()
        }
    }
    
    private func stopAnimating() {
        snp.updateConstraints({ $0.height.equalTo(0) })
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.layoutIfNeeded()
        }) { [weak self] (_) in
            self?.indicator.frame = .zero
        }
    }
    
    // Bar grows as it crosses
    private func animatePartA() {
        guard let superview = self.superview,
            animating else { return }
        indicator.frame = CGRect(x: 0, y: 0, width: 0, height: heightForLinearBar)
        let fullIndicatorFrameLeft = CGRect(x: 0, y: 0, width: widthForLinearBar*widthMultiplerLargeBar, height: heightForLinearBar)
        let fullInidcatorFrameOffRight = CGRect(x: superview.frame.width, y: 0, width: widthForLinearBar*widthMultiplerLargeBar, height: heightForLinearBar)
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [.calculationModeCubicPaced], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: { [weak self] in
                guard let self = self else { return }
                self.indicator.frame = fullIndicatorFrameLeft
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: { [weak self] in
                guard let self = self else { return }
                self.indicator.frame = fullInidcatorFrameOffRight
            })
        }) { [weak self](completed) in
            self?.animatePartB()
        }
    }
    
    
    // Bar shrinks as it crosses
    private func animatePartB() {
        guard let superview = self.superview,
            animating else { return }
        let fullIndicatorFrameOffLeft = CGRect(x: -widthForLinearBar*widthMultiplerLargeBar, y: 0, width: widthForLinearBar*widthMultiplerLargeBar, height: heightForLinearBar)
        indicator.frame = fullIndicatorFrameOffLeft
        let fullIndicatorFrameLeft = CGRect(x: 0, y: 0, width: self.widthForLinearBar*self.widthMultiplerLargeBar, height: self.heightForLinearBar)
        let smallInidcatorFrameOffRight = CGRect(x: superview.frame.width, y: 0, width: self.widthForLinearBar*self.widthMultiplierSmallBar, height: self.heightForLinearBar)
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: { [weak self] in
                guard let self = self else { return }
                self.indicator.frame = fullIndicatorFrameLeft
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: { [weak self] in
                guard let self = self else { return }
                self.indicator.frame = smallInidcatorFrameOffRight
            })
            
        }) { [weak self] (completed) in
            self?.animatePartA()
        }
    }

}
