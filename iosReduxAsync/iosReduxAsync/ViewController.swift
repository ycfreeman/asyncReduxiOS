//
//  ViewController.swift
//  iosReduxAsync
//
//  Created by Freeman on 27/05/2016.
//  Copyright © 2016 Freeman. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import JavaScriptCore
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let webView: UIWebView = UIWebView()

    let dispose = DisposeBag()
    
    var sections: [JSItemSection] = []
    
    let reloadDataSource = RxTableViewSectionedAnimatedDataSource<JSItemSection>()
    
    @IBOutlet weak var button: UIButton!
    
    lazy var context: JSContext? = {
        guard let context = self.webView.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as? JSContext else {
            return nil
        }
        
        return context
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        webView.hidden = true
        webView.frame = CGRect.zero
        webView.delegate = self

        view.addSubview(webView)
        
        
        reloadDataSource.configureCell = {
            (dataSource, tableView, indexPath, item: JSItem) in
            let cell: TableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as? TableViewCell ??
                TableViewCell(style: .Default, reuseIdentifier: "Cell")
            
            // bind view
            
            if let cellDetailLabel: UILabel = cell.detailTextLabel {
                item.intOutlet.observeOn(MainScheduler.asyncInstance).bindTo(cellDetailLabel.rx_text).addDisposableTo(cell.dispose!)
            }
            
            if let cellTitleLabel: UILabel = cell.textLabel {
                item.strOutlet.observeOn(MainScheduler.asyncInstance).bindTo(cellTitleLabel.rx_text).addDisposableTo(cell.dispose!)
            }
            
            return cell
        }
        
        reloadDataSource.titleForHeaderInSection = {
            (dataSource, section: Int) in
            let itemSection = dataSource.sectionModels[section]
            return itemSection.header
        }
        
        ItemService.sharedInstance.sectionsObservable
            // observe on main thread, and drive tableview
            .throttle(0.16, scheduler: MainScheduler.asyncInstance)
            .catchErrorJustReturn([])
            .observeOn(MainScheduler.instance)
            .bindTo(tableView.rx_itemsWithDataSource(reloadDataSource))
            .addDisposableTo(dispose)
        
        
        
        // seems we can just make a hidden webView and use JSContext inside
        
        
//        context = webView.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as? JSContext
        
//        let context: JSContext = JSContext()
//        WTWindowTimers().extend(context)
//        XMLHttpRequest().extend(context)
        
        
        // load js file from bundle and evaluate
        // invoke from redux if changes occur
        // we can have rx stuff here in native environment
        // we also need an adaptor that converts js object to native object / view model
        // then we consume the native object / view model

        guard let url = NSBundle.mainBundle().URLForResource("app", withExtension: "js"),
            appJSData = NSData(contentsOfURL: url),
            script = String(data: appJSData, encoding: NSUTF8StringEncoding)
        else { return }
        
        let jsApp: String = "\(script)"
        
        // so we evaluate it
        
        context?.setObject(JSItem.self, forKeyedSubscript: "JSItem")
        context?.exceptionHandler = { context, exception in
            print("JS Error: \(exception)")
        }
        context?.evaluateScript(jsApp)
        context?.evaluateScript("fetchMorePosts();")
        
        button.rx_tap
            .observeOn(MainScheduler.instance)
            .bindNext {
                [weak context] in
                context?.evaluateScript("fetchMorePosts();")
            }.addDisposableTo(dispose)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UIWebViewDelegate {
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(request)
        
        return true
    }
}

