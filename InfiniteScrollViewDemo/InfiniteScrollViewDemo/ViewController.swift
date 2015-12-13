//
//  ViewController.swift
//  InfiniteScrollViewDemo
//
//  Created by Naoki Fujii on 12/12/15.
//  Copyright © 2015 nfujii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: InfiniteScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.dataSource = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: InfiniteScrollViewDataSource {
    func numberOfItemsInScrollView(scrollView: InfiniteScrollView) -> Int {
        return 5
    }
    
    func scrollView(scrollView: InfiniteScrollView, sizeForCellAtIndex index: Int) -> CGSize {
        return self.view.bounds.size
    }
    
    func scrollView(scrollView: InfiniteScrollView, cellForItemAtIndex index: Int) -> UIView {
        let view = UIView(frame: self.view.bounds)
        view.layer.borderColor = UIColor.redColor().CGColor
        view.layer.borderWidth = 4.0
        
        let label = UILabel()
        label.text = String(index)
        label.sizeToFit()
        view.addSubview(label)
        label.center = CGPoint(x: CGRectGetWidth(view.bounds)*0.5, y: CGRectGetHeight(view.bounds)*0.5)
        
        return view
    }
}