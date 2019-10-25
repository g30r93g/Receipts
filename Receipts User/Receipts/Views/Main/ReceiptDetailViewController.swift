//
//  ReceiptDetailViewController.swift
//  Receipts
//
//  Created by George Nick Gorzynski on 25/10/2019.
//  Copyright © 2019 g30r93g. All rights reserved.
//

import UIKit
import MapKit

class ReceiptDetailViewController: UIViewController {
	
	// MARK: IBOutlets
	@IBOutlet weak var receiptCellView: UIView!
	@IBOutlet weak var locationIcon: RoundImageView!
	@IBOutlet weak var locationName: UILabel!
	@IBOutlet weak var timeDate: UILabel!
	@IBOutlet weak var receiptTotal: RoundLabel!
	
	@IBOutlet weak var locationMap: MKMapView!
	
	@IBOutlet weak var itemsPurchasedCollection: UICollectionView!
	
	// MARK: Variables
	var receipt: Receipts.Receipt!
	
	// MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		self.setupView()
	}
	
	// MARK: Methods
	private func setupView() {
		self.locationName.text = self.receipt.storeDetails.name
		self.timeDate.text = "\(self.receipt.date.dateValue().day()) at \(self.receipt.date.dateValue().time())"
		self.receiptTotal.text = "£\(String(format: "%.2f", self.receipt.transactionDetails.total))"
		
		self.setupMapView()
	}
	
	private func setupMapView() {
		
		let center = CLLocationCoordinate2D(latitude: self.receipt.storeDetails.location.latitude, longitude: self.receipt.storeDetails.location.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
		
		self.locationMap.setRegion(region, animated: true)
	}
	
	// MARK: IBActions
	@IBAction func dismissTapped(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
}

extension ReceiptDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.receipt.transactionDetails.items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Receipt Item", for: indexPath) as! ReceiptItem
		let data = self.receipt.transactionDetails.items[indexPath.item]
		
		cell.setupCell(from: data)
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = UIScreen.main.bounds.width - 40
		
		return CGSize(width: width, height: 110)
	}
	
}

extension ReceiptDetailViewController: MKMapViewDelegate {
	
}
