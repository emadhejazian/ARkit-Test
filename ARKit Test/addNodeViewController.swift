//
//  ViewController.swift
//  ARKit Test
//
//  Created by EmadHejazian on 1/13/18.
//  Copyright © 2018 EmadHejazian. All rights reserved.
//

import UIKit
import ARKit
import CoreLocation

class addNodeViewController: UIViewController ,ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var txtAngel: UITextField!
    @IBOutlet weak var txtDistance: UITextField!
    
    @IBOutlet weak var txtX: UITextField!
    @IBOutlet weak var txtY: UITextField!
    @IBOutlet weak var txtZ: UITextField!
    
    @IBOutlet weak var lblCompassInfo: UILabel!
    
    //##compass
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //##compass
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
        
        //
        sceneView.delegate = self
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        /*The coordinate system's y-axis is parallel to gravity,
         its x- and z-axes are oriented to compass heading,
         and its origin is the initial position of the device.*/
        configuration.worldAlignment = .gravityAndHeading
        sceneView.session.run(configuration)
        
        
        
        
        
//        addBoxByPolarCoordinate(distance: 1,
//                                angle: -90)
        addBoxByCartesianCoordinate(x: 0, y: 0, z: -1)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func addBoxByCartesianCoordinate(x: Float = 0, y: Float = 0, z: Float = -0.2) {
        let box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 5)
        
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(x, y, z)

        sceneView.scene.rootNode.addChildNode(boxNode)
    }
    
    func addBoxByPolarCoordinate(distance:Double,angle degree:Double,elevate:Double = 0.0) {

        //Polar Coordinate :
        //https://en.wikipedia.org/wiki/Polar_coordinate_system#Converting_between_polar_and_Cartesian_coordinates

        let y = elevate
        let x = Double(distance * cos(Double.pi * degree / 180))
        //-1 :z must b negetaive for showing in front of camera
        //(90 - degree) : degree is depend on X axis but we need a degree depend on Z axis
        let z = -1 * Double(distance * sin(Double.pi * (degree - 90) / 180)) //accept Degree

        addBoxByCartesianCoordinate(x: Float(x), y: Float(y), z: Float(z))
    }
    
    @IBAction func btnAddBoxByCartesianCoordinate(_ sender: UIButton) {
        addBoxByCartesianCoordinate(x: Float(txtX.text!)!,
                                    y: Float(txtY.text!)!,
                                    z: Float(txtZ.text!)!)
    }
    
    @IBAction func btnAddBoxByPolarCoordinate(_ sender: UIButton) {
        addBoxByPolarCoordinate(distance: Double(txtDistance.text!)!,
                                angle: Double(txtAngel.text!)!)
    }
    
    @IBAction func btnBaclClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

//MARK: HIDE KEYBOARD
extension addNodeViewController:UITextFieldDelegate
{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension addNodeViewController : CLLocationManagerDelegate
{
    //##compass
    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        print (heading.magneticHeading)
        lblCompassInfo.text = heading.magneticHeading.description
    }
}

