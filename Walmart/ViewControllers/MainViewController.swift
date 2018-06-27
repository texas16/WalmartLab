//
//  MainViewController.swift
//  Walmart
//
//  Created by ilyas on 6/26/18.
//  Copyright © 2018 ilyas. All rights reserved.
//

import UIKit

//struct WalmartProducts: Decodable {
//    let totalProducts: Int?
//    let pageNumber: Int?
//    let pageSize: Int?
//    let statusCode: Int
//    var products: [Product]
//}
//
//struct Product: Decodable {
//    let productId: String?
//    let productName: String?
//    let shortDescription: String?
//    let longDescription: String?
//    let price: String?
//    let productImage: String?
//    let reviewRating: Float
//    let reviewCount: Int
//    let inStock: Bool?
//}

class MainViewController: UIViewController,UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var productTableView: UITableView!
    var products: WalmartProducts!
    var isWating = false
    var pageNumber = 1
    private let refreshControl = UIRefreshControl()
    private var notification: NSObjectProtocol?
    
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))


    override func viewWillAppear(_ animated: Bool)
    {
        self.effectView.removeFromSuperview()
        // TODO: Enhancement
        // If a new item is added into the inventory, notificationCenter observer needs to be implemented HERE
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNavBarImage()
        
        // setting up tableview delegates
        productTableView.delegate = self
        productTableView.dataSource = self
        
        // remove extra space on the top of tableview
        self.automaticallyAdjustsScrollViewInsets = false
        
        // connection test
        if Reachability.isConnectedToNetwork() {
            // api call
            self.loadProducts()
            print("Internet connection available")
        }
        else{
            self.alertMessageOk(title: NSLocalizedString("error", comment:""), message: NSLocalizedString("connection_error", comment:""))
            print("No internet connection available")
        }
        
        // adding refresh control
        // since iOS 10, the UITableView class have a refreshControl property.
        if #available(iOS 10.0, *) {
            productTableView.refreshControl = refreshControl
        } else {
            productTableView.addSubview(refreshControl)
        }
        
        // setting up refresh control properties
        refreshControl.tintColor = UIColor(red:0.0, green:0.5, blue:0.78, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("loading", comment:""), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0)])
        refreshControl.addTarget(self, action:#selector(MainViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        
        //view controller to be notified when the app is brought back to the foreground
        notification = NotificationCenter.default.addObserver(forName: .UIApplicationWillEnterForeground, object: nil, queue: .main) {
            [unowned self] notification in
            self.products = nil
            self.pageNumber = 1
            self.loadProducts()
        }
    }
    
    func loadProducts ()
    {
        self.activityIndicator(NSLocalizedString("loading", comment:""))
        self.fetchProducts(page: self.pageNumber , completion: { success in
            if let products = success as? WalmartProducts
            {
                DispatchQueue.main.async {
                    self.effectView.removeFromSuperview()
                    self.products = products
                    self.productTableView.reloadData()
                }
            }
        })
    }
    
    func addNavBarImage() {
        
        let navController = navigationController!
        
        let image = UIImage(named: "logo-walmart")
        let imageView = UIImageView(image: image)
        
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        
        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    
    // refresh control method
    @objc func handleRefresh(_ refreshControl: UIRefreshControl)
    {
        pageNumber = 1
        fetchProducts(page: pageNumber , completion: { success in
            if let products = success as? WalmartProducts
            {
                DispatchQueue.main.async {
                    self.effectView.removeFromSuperview()
                    self.products = products
                    self.productTableView.reloadData()
                    refreshControl.endRefreshing()
                }
            }
        })
    }
    
    func fetchProducts(page: Int, completion: @escaping ((AnyObject) -> Void)) {
        
        guard let baseURL = URL(string: Constants.API_URL) else { return  }
            let jsonURL = baseURL.appendingPathComponent(Constants.PATH)
                .appendingPathComponent(String(page))
                .appendingPathComponent(Constants.PAGE_SIZE)
        
                // Note: Swift 4 JSONCoder()
                URLSession.shared.dataTask(with: jsonURL) { (data, response, err) in
                    guard let data = data else { return }
                    do {
                        let pageProducts = try JSONDecoder().decode(WalmartProducts.self, from: data)
                        //check response status 200 OK
                        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                            self.alertMessageOk(title: NSLocalizedString("error", comment:""), message: NSLocalizedString("connection_error", comment:""))
                        }
                        else{
                            completion(pageProducts as AnyObject)
                        }
                    }
                        //check error
                    catch let jsonErr {
                        print("Error serializing json:", jsonErr)
                        self.alertMessageOk(title: NSLocalizedString("error", comment:""), message: NSLocalizedString("json_error", comment:""))
                    }
                }.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doPaging() {
        // call the API in this block and after getting the response then
        // paging is done and user can able request another page request by scrolling the tableview at the bottom.
        fetchProducts(page: pageNumber , completion: { success in
            if let products = success as? WalmartProducts
            {
                DispatchQueue.main.async {
                    self.products.products.append(contentsOf:products.products)
                    self.productTableView.reloadData()
                    self.isWating = false
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if indexPath.row == self.products.products.count - 4 && !isWating {
            isWating = true
            self.pageNumber += 1
            self.doPaging()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products == nil ? 0 : self.products.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductTableViewCell
        cell.priceLbl.text = self.products.products[indexPath.row].price
        cell.productNameLbl.text = self.products.products[indexPath.row].productName
        cell.productImageView.loadImageUsingCaches(withUrl:Constants.API_URL + self.products.products[indexPath.row].productImage!)
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "detailvc") as! DetailViewController
        vc.productData = self.products.products
        vc.index = indexPath.row;
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    // hide or unhide navigationbar and status bar during the scroll
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if(velocity.y > 0)
        {
            UIApplication.shared.isStatusBarHidden = true
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        else
        {
            UIApplication.shared.isStatusBarHidden = false
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    func activityIndicator(_ title: String) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = .systemFont(ofSize: 14, weight: .medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }
    
    deinit {
        // make sure to remove the observer when this view controller is dismissed/deallocated
        
        if let notification = notification {
            NotificationCenter.default.removeObserver(notification)
        }
    }
}

