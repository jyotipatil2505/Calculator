//
//  Calculator.swift
//  Calculator
//
//  Created by Jyoti on 04/08/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class CalculatorVC: UIViewController {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var sevenButton: ButtonClass!
    @IBOutlet var eightButton: ButtonClass!
    @IBOutlet var nineButton: ButtonClass!
    @IBOutlet var ceButton: ButtonClass!
    @IBOutlet var clButton: ButtonClass!
    @IBOutlet var fourButton: ButtonClass!
    @IBOutlet var fiveButton: ButtonClass!
    @IBOutlet var sixButton: ButtonClass!
    @IBOutlet var divideButton: ButtonClass!
    @IBOutlet var oneButton: ButtonClass!
    @IBOutlet var secondButton: ButtonClass!
    @IBOutlet var thirdButton: ButtonClass!
    @IBOutlet var multiplyButton: ButtonClass!
    @IBOutlet var equalButton: ButtonClass!
    @IBOutlet var zeroButton: ButtonClass!
    @IBOutlet var dotButton: ButtonClass!
    @IBOutlet var minusButton: ButtonClass!
    @IBOutlet var plusButton: ButtonClass!
        
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        textField.text = "0"
        
        //let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        //statusBar.backgroundColor = UIColor.black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func processString(input :String) {
        
        if(textField.text == "0" && (Int(input) ?? 0 > 0 || input == "0")){
            textField.text = input
        }
        else{
            textField.text = (textField.text ?? "") + input
        }
        print("PROCESSED STRING : \(textField.text!)")
    }
    
    func addOperator(input :String){
        
        let lastElement = String(textField.text?.suffix(1) ?? "0")
        if Int(lastElement) != nil{
            textField.text = (textField.text ?? "0") + input
        }
        print("FINAL STRING WITH MINUS OPERATOR : \(textField.text!)")
    }
    
    func processDotOperator(input :String) {
        
        let lastElement = String(textField.text?.suffix(1) ?? "0")
        
        if Int(lastElement) != nil{
            
            var string = textField.text ?? "0"
            string = string.replacingOccurrences(of: "+", with: "&")
            string = string.replacingOccurrences(of: "-", with: "&")
            string = string.replacingOccurrences(of: "*", with: "&")
            string = string.replacingOccurrences(of: "/", with: "&")
            
            let array = string.components(separatedBy: "&")
            print("arrayarray : \(array)")
            
            if String(array[array.count - 1]) != "" && !String(array[array.count - 1]).contains("."){
                print("last string does NOT contain the word `.`")
                textField.text = (textField.text ?? "0") + input
            }
            else{
                print("last string does contain the word `.` or it is empty")
            }
        }
    }
    
    //MARK:- IBOutlet Methods
    @IBAction func digitButtonClick(_ sender: ButtonClass) {
        let tag = String(format: "%d", sender.tag)
        processString(input: tag)
    }
    
    @IBAction func dotButtonClick(_ sender: Any) {
        processDotOperator(input: ".")
    }
    
    @IBAction func ceButtonClick(_ sender: Any) {
        textField.text = String(textField.text?.dropLast() ?? "0")
        textField.text = textField.text == "" ? "0" : textField.text
        print("CE OUTPUT : \(textField.text!)")
    }
    
    @IBAction func clButton(_ sender: Any) {
        textField.text = "0"
        print("CLEAR OUTPUT : \(textField.text!)")
    }
    
    @IBAction func minusButtonClick(_ sender: Any) {
        addOperator(input: "-")
    }
    
    @IBAction func plusButton(_ sender: Any) {
        addOperator(input: "+")
    }
    
    @IBAction func multiplyButtonClick(_ sender: Any) {
        addOperator(input: "*")
    }
    
    @IBAction func divideButtonClick(_ sender: Any) {
        addOperator(input: "/")
    }
    
    @IBAction func equalButtonClick(_ sender: Any) {
        
        let lastElement = String(textField.text?.suffix(1) ?? "0")
        
        if Int(lastElement) != nil{
            
            let s = textField.text ?? "0"
            
            let expn = NSExpression(format:s)
                        
            if let string = expn.toFloatingPoint().expressionValue(with: nil, context: nil), Double(self.textField.text!) == nil{
                
                print("string value : \(string)")
                self.textField.text = "\(string)"
            }
        }
    }
}

extension CalculatorVC:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}

extension NSExpression {

    func toFloatingPoint() -> NSExpression {
        
        switch expressionType {
            
            case .constantValue:
                if let value = constantValue as? NSNumber {
                    return NSExpression(forConstantValue: NSNumber(value: value.doubleValue))
                }
            
            case .function:
               let newArgs = arguments.map { $0.map { $0.toFloatingPoint() } }
               return NSExpression(forFunction: operand, selectorName: function, arguments: newArgs)
            
            case .conditional:
               return NSExpression(forConditional: predicate, trueExpression: self.true.toFloatingPoint(), falseExpression: self.false.toFloatingPoint())
            
            case .unionSet:
                return NSExpression(forUnionSet: left.toFloatingPoint(), with: right.toFloatingPoint())
            
            case .intersectSet:
                return NSExpression(forIntersectSet: left.toFloatingPoint(), with: right.toFloatingPoint())
            
            case .minusSet:
                return NSExpression(forMinusSet: left.toFloatingPoint(), with: right.toFloatingPoint())
            
            case .subquery:
                if let subQuery = collection as? NSExpression {
                    return NSExpression(forSubquery: subQuery.toFloatingPoint(), usingIteratorVariable: variable, predicate: predicate)
                }
            
            case .aggregate:
                if let subExpressions = collection as? [NSExpression] {
                    return NSExpression(forAggregate: subExpressions.map { $0.toFloatingPoint() })
                }
            
            case .anyKey:
                fatalError("anyKey not yet implemented")
            
            case .block:
                fatalError("block not yet implemented")
            
            case .evaluatedObject, .variable, .keyPath:
                break // Nothing to do here
            
            @unknown default:
                //<#fatalError()#>
                break
        }
        
        return self
    }
}
