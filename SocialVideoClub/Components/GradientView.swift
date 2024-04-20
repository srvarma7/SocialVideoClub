//
//  GradientView.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 17/04/24.
//

import UIKit

class GradientView: UIView {
    
    var colors: [CGColor] = [
        UIColor.black.withAlphaComponent(0.7).cgColor,
        UIColor.black.withAlphaComponent(0).cgColor
    ] {
        didSet {
            gradientLayer.colors = colors
        }
    }
    
    var locations: [NSNumber] = [
        0,
        1
    ] {
        didSet {
            gradientLayer.locations = locations
        }
    }
    
    lazy private var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = colors
        gradient.locations = locations
        return gradient
    }()
    
    init(colors: [CGColor], locations: [NSNumber]) {
        self.init()
        self.colors = colors
        self.locations = locations
        layer.addSublayer(gradientLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
