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
    @IBOutlet weak var webView: UIWebView!

    let dispose = DisposeBag()
    
    var sections: [JSItemSection] = []
    
    let reloadDataSource = RxTableViewSectionedReloadDataSource<JSItemSection>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        webView.hidden = true
        webView.frame = CGRect.zero
        
        reloadDataSource.configureCell = {
            (dataSource, tableView, indexPath, item: JSItem) in
            let cell: TableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as? TableViewCell ??
                TableViewCell(style: .Default, reuseIdentifier: "Cell")
            
            // bind view
            
            if let cellDetailLabel: UILabel = cell.detailTextLabel {
                item.intOutlet.bindTo(cellDetailLabel.rx_text).addDisposableTo(cell.dispose!)
            }
            
            if let cellTitleLabel: UILabel = cell.textLabel {
                item.strOutlet.bindTo(cellTitleLabel.rx_text).addDisposableTo(cell.dispose!)
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
        let context: JSContext =
            webView.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as! JSContext
        
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
        
        context.setObject(JSItem.self, forKeyedSubscript: "JSItem")
        context.exceptionHandler = { context, exception in
            print("JS Error: \(exception)")
        }
        context.evaluateScript(jsApp)
        context.evaluateScript("fetchPosts();")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

