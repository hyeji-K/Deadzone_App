//
//  EmptyView.swift
//  Deadzone
//
//  Created by heyji on 2024/05/10.
//

import UIKit

extension UICollectionView {
    
    func setEmptyView() {
        let emptyView: UIView = {
            let view = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.width, height: self.bounds.height))
            return view
        }()
        
        emptyView.backgroundColor = DZColor.backgroundColor
        self.backgroundView = emptyView
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
