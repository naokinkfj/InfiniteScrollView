//
//  InfiniteScrollView.swift
//  InfiniteScrollViewDemo
//
//  Created by Naoki Fujii on 12/12/15.
//  Copyright © 2015 nfujii. All rights reserved.
//

import UIKit

public protocol InfiniteScrollViewDataSource: NSObjectProtocol {
    func numberOfItemsInScrollView(scrollView: InfiniteScrollView) -> Int
    func scrollView(scrollView: InfiniteScrollView, sizeForCellAtIndex index: Int) -> CGSize
    func scrollView(scrollView: InfiniteScrollView, cellForItemAtIndex index: Int) -> UIView
}

public enum InfiniteScrollViewScrollDirection {
    case Vertical
    case Horizontal
}

public class InfiniteScrollView: UIScrollView {
    weak public var dataSource: InfiniteScrollViewDataSource?

    private var containerView = UIView()
    private var numberOfItems: Int = 0
    private var rectsOfAllItems = [CGRect]()
    
    public var infiniteScrollEnabled = true {
        didSet(old) {
            if old != infiniteScrollEnabled {
                if infiniteScrollEnabled {
                    
                } else {
                    
                }
            }
        }
    }
    
//    private let messageInterceptor = MessageInterceptor<UIScrollViewDelegate>()
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
//        super.delegate = messageInterceptor
    }
    
    private func commonInit() {
//        self.messageInterceptor.middleMan = self
        
        self.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        containerView.frame = CGRect(origin: CGPointZero, size: self.contentSize)
        containerView.userInteractionEnabled = false
        self.addSubview(containerView)
    }
    
//    override public var delegate: InfiniteScrollViewDelegate? {
//        get {
//            return self.messageInterceptor.receiver
//        }
//        set {
//            self.messageInterceptor.receiver = newValue
//        }
//    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        guard let dataSource = self.dataSource else {
            return
        }
        
        let visibleBounds = self.convertRect(self.bounds, toView: containerView)
        
        // remove subviews out of visible bounds
        for v in self.containerView.subviews {
            if !CGRectIntersectsRect(v.frame, visibleBounds) {
                Log.d("remove:" + NSStringFromCGRect(v.frame))
                v.removeFromSuperview()
            }
        }
        
        // add subviews visible
        for (index, rect) in rectsOfAllItems.enumerate() {
            if CGRectIntersectsRect(rect, visibleBounds) {
                if !visibleIndexSet.contains(index) {
                    let v = dataSource.scrollView(self, cellForItemAtIndex: index)
                    v.frame = rect
                    containerView.addSubview(v)
                    Log.d("add:" + NSStringFromCGRect(v.frame))
                    visibleIndexSet.insert(index)
                }
            } else {
                visibleIndexSet.remove(index)
            }
        }
        
        if infiniteScrollEnabled {
            var insets = self.contentInset
            insets.left = self.bounds.width
            insets.right = self.bounds.width
            self.contentInset = insets
        } else {
            self.contentInset = UIEdgeInsetsZero
        }
    }
    
    private var visibleIndexSet: Set<Int> = []
    public func reloadData() {
        guard let dataSource = self.dataSource else {
            return
        }
        
        numberOfItems = dataSource.numberOfItemsInScrollView(self)
        
        rectsOfAllItems.removeAll()
        var topLeft = CGPointZero
        for i in (0..<numberOfItems) {
            let rect = CGRect(origin: topLeft, size: dataSource.scrollView(self, sizeForCellAtIndex: i))
            rectsOfAllItems.append(rect)
            
            topLeft.x = CGRectGetMaxX(rect)
        }
        
        self.contentSize = CGSize(width: topLeft.x, height: CGRectGetHeight(self.bounds))
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    
    // MARK: - KVO
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        containerView.frame = CGRect(origin: CGPointZero, size: self.contentSize)
    }
}




extension InfiniteScrollView: UIScrollViewDelegate {
    
}


// Intercept Objective-C delegate messages within a subclass
// http://stackoverflow.com/questions/3498158/intercept-objective-c-delegate-messages-within-a-subclass/18777565#18777565
//private class MessageInterceptor: NSObject, UIScrollViewDelegate {
//    weak var receiver: InfiniteScrollViewDelegate?
//    weak var middleMan: InfiniteScrollViewDelegate?
//    
//    override func respondsToSelector(aSelector: Selector) -> Bool {
//        if let middleMan = middleMan where middleMan.respondsToSelector(aSelector) {
//            return true
//        }
//        if let receiver = receiver where receiver.respondsToSelector(aSelector) {
//            return true
//        }
//        return super.respondsToSelector(aSelector)
//    }
//    
//    override func forwardingTargetForSelector(aSelector: Selector) -> AnyObject? {
//        if let middleMan = middleMan where middleMan.respondsToSelector(aSelector) {
//            return middleMan
//        }
//        if let receiver = receiver where receiver.respondsToSelector(aSelector) {
//            return receiver
//        }
//        return super.forwardingTargetForSelector(aSelector)
//    }
//}
