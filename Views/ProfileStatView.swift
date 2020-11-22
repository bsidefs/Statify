//
//  ProfileStatView.swift
//  Statify
//
//  Created by Brian Tamsing on 11/19/20.
//

import UIKit

class ProfileStatView: UIView {

    // MARK: - Properties
    
    var statLabel           = UILabel()
    var statTypeLabel       = UILabel()
    
    var containerView       : UIView!
    var activityIndicator   : UIActivityIndicatorView!
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(statType: ProfileStatType) {
        self.init(frame: .zero)
        self.statTypeLabel.text = statType.rawValue
        self.activityIndicator  = UIActivityIndicatorView(style: .medium)
    }
    
    
    // MARK: - Methods
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints               = false
        addSubviews(statLabel,statTypeLabel)
        
        statLabel.font                                          = UIFont.systemFont(ofSize: 18, weight: .medium)
        statLabel.textColor                                     = #colorLiteral(red: 0.1137254902, green: 0.7254901961, blue: 0.3294117647, alpha: 1)
        
        statTypeLabel.font                                      = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        statTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        statLabel.translatesAutoresizingMaskIntoConstraints     = false
    }
    
    
    func setConstraints() {
        let topPadding: CGFloat   = 5
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 70),
            widthAnchor.constraint(equalToConstant: 70),
            
            statLabel.topAnchor.constraint(equalTo: topAnchor, constant: topPadding),
            statLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            statLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            statLabel.heightAnchor.constraint(equalToConstant: 30),
            
            statTypeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            statTypeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            statTypeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topPadding),
            statTypeLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    
    func setStat(_ stat: Int) {
        self.statLabel.text = String(stat)
    }
    
    
    func presentActivityIndicator() {
        DispatchQueue.main.async {
            self.containerView = UIView(frame: self.statLabel.bounds)
            self.statLabel.addSubview(self.containerView)
            
            self.containerView.backgroundColor   = .clear
            self.containerView.alpha             = 0
            
            UIView.animate(withDuration: 0.25, animations: { self.containerView.alpha = 0.7 })
            
            self.containerView.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
    }
    
    
    func dismissActivityIndicator() {
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.activityIndicator = nil
        }
    }
}
