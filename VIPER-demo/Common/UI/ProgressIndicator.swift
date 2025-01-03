//
//  ProgressIndicator.swift
//  VIPER-demo
//
//  Created by Bipin on 7/3/18.
//

import Foundation
import UIKit

class ProgressIndicator: UIVisualEffectView {
    
    var text: String? {
        didSet {
            label.text = text
            label.textColor = UIColor.gray
        }
    }
    
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    let label: UILabel = UILabel()
    let blurEffect = UIBlurEffect(style: .light)
    let vibrancyView: UIVisualEffectView
    
    init(text: String) {
        self.text = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        self.vibrancyView.backgroundColor = UIColor.lightGray
        self.vibrancyView.alpha = 0.2
        super.init(effect: nil)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.text = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        contentView.addSubview(vibrancyView)
        contentView.addSubview(activityIndictor)
        contentView.addSubview(label)
        activityIndictor.startAnimating()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        //if let superview = self.superview {
            
            let width = UIScreen.main.bounds.width// superview.frame.size.width / 1.8
            let height = UIScreen.main.bounds.height// CGFloat //= 70.0
            self.frame = UIScreen.main.bounds//CGRect(x: superview.frame.size.width / 2 - width / 2,
                                //y: superview.frame.height / 2 - height / 2,
                                //width: width,
                                //height: height)
            vibrancyView.frame = self.bounds
            
            let activityIndicatorSize: CGFloat = 40
            activityIndictor.frame = CGRect(x: width / 2 -  activityIndicatorSize / 2,
                                            y: height / 2 - activityIndicatorSize / 2,
                                            width: activityIndicatorSize,
                                            height: activityIndicatorSize)
            
            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            /*label.text = text
            label.textAlignment = NSTextAlignment.center
            label.frame = CGRect(x: activityIndicatorSize + 5,
                                 y: 0,
                                 width: width - activityIndicatorSize - 15,
                                 height: height)
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 17)*/
        //}
    }
    
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }
}
