//
//  AddViewController.swift
//  todo
//
//  Created by Jun Takahashi on 2019/05/22.
//  Copyright © 2019年 Jun Takahashi. All rights reserved.
//

import UIKit
import GoogleMaps

class AddViewController: UIViewController {
    
    let taskCollection = TaskCollection.shared

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var mapCanvasView: UIView!
    
    var selectedTask: Task?
    
    var mapView: GMSMapView!
    let marker = GMSMarker()
    
    var locationManager = CLLocationManager()
    
    var zoomLevel: Float = 14.0
    var latitude = 35.6675497
    var longitude = 139.7137988
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let _selectedTask = self.selectedTask,
            let _latitude = _selectedTask.latitude,
            let _longitude =  _selectedTask.longitude {
            self.title = "編集"
            self.titleTextField.text = _selectedTask.title
            self.memoTextView.text = _selectedTask.memo
            self.navigationItem.rightBarButtonItem?.title = "上書き"
            self.latitude = _latitude
            self.longitude = _longitude
        } else {
            self.configureLocationManager()
        }
        
        self.configureGoogleMap()
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if self.selectedTask == nil,
//            let myLocation = self.mapView.myLocation?.coordinate {
//            self.marker.position.latitude = myLocation.latitude
//            self.marker.position.longitude = myLocation.longitude
//            self.mapView.animate(toLocation: marker.position)
//        }
//    }
    
    private func configureGoogleMap(){
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoomLevel)
        let rect = CGRect(x: 0, y: 0, width: mapCanvasView.bounds.width, height: mapCanvasView.bounds.height)
        
        self.mapView = GMSMapView.map(withFrame: rect, camera: camera)
        self.mapCanvasView.addSubview(self.mapView!)

        self.mapView?.isMyLocationEnabled = true // 自分の場所を表示
        self.mapView?.settings.myLocationButton = true // 自分の場所を中心にするボタン表示
        self.mapView?.delegate = self
        
        self.mapCanvasView.addSubview(self.mapView!)
        
        self.marker.position.latitude = latitude
        self.marker.position.longitude = longitude
        self.marker.map = mapView
    }
    
    func configureLocationManager(){
        self.locationManager.delegate = self
        self.locationManager.activityType = .other // 更新タイプ
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest // 距離精度
        self.locationManager.distanceFilter = 50 // 更新頻度に関わる移動距離
    }
    
    @IBAction func didTouchSaveButton(_ sender: Any) {
        guard let title = titleTextField.text else { return }
        if (title.isEmpty) {
            self.singleAlert(title: "タイトルを入力してください", message: nil)
            return
        }
        
        let coordinate = marker.position

        if let _selectedTask = self.selectedTask {
            //編集のフロー
            _selectedTask.title = title
            _selectedTask.memo = memoTextView.text
            _selectedTask.latitude = coordinate.latitude
            _selectedTask.longitude = coordinate.longitude
            self.taskCollection.editTask()
        } else {
            //新規のフロー
            let newTask = Task(title: title)
            newTask.memo = memoTextView.text
            newTask.latitude = coordinate.latitude
            newTask.longitude = coordinate.longitude
            self.taskCollection.addTask(newTask)
        }
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension AddViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.marker.position = coordinate
        print("didTapAt")
    }
}

extension AddViewController: CLLocationManagerDelegate {
    // 位置が変化したら呼び出される
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.locationManager.stopUpdatingLocation() //１回取得したら止めてみる
        print("緯度:\(location.coordinate.latitude) \n経度:\(location.coordinate.longitude) \n取得時刻:\(location.timestamp.description)")
        if self.selectedTask == nil {
            self.marker.position.latitude = location.coordinate.latitude
            self.marker.position.longitude = location.coordinate.longitude
            self.mapView.animate(toLocation: marker.position) //マップの表示を更新
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("まだ許可・不許可の選択を行っていない状態")
            // 許可を求める
            self.locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("ユーザーによって、明示的に拒否されている状態")
        // 設定へ誘導するアナウンスを出す
        case .restricted:
            print("位置情報サービスを使用できない場合")
        // 正常に動作できないというアナウンスを出す
        case .authorizedAlways:
            print("常に位置情報の取得が許可されています")
            // 取得をはじめる
            self.locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            print("使用中に位置情報の取得が許可されています")
            // 取得をはじめる
            self.locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
}
