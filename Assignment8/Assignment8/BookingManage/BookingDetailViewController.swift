//
//  BookingDetailViewController.swift
//  assignment7Storyboard
//
//  Created by 陈昕昀 on 3/16/19.
//  Copyright © 2019 XinyunChen. All rights reserved.
//

import UIKit

class BookingDetailViewController: UIViewController,UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate {
    
    var booking = Booking()
    var btnTitle = ""
    var bookingDateValue = 0
    var returnDateValue = 0
    var dateValue = DateFormatter()
    //dateValue.dateFormat = "YYYY MM dd" // 调用别的函数不能写在class里面
    
    
    @IBOutlet weak var movietxt: UITextField!
    @IBOutlet weak var moviecustomerpicker: UIPickerView!
    @IBOutlet weak var customertxt: UITextField!
    @IBOutlet weak var quantitytxt: UITextField!{
        didSet { quantitytxt?.addDoneCancelToolbar() }
    }
    @IBOutlet weak var bookingDatetxt: UITextField!
    @IBOutlet weak var bookingDate: UIDatePicker!
    @IBAction func bookingDatePicker(_ sender: UIDatePicker) {
        //dateValue.dateFormat = "YYYY-MM-dd" // 設定要顯示在Text Field的日期時間格式
        bookingDateValue = bookingDate.date.hashValue
        bookingDatetxt.text = dateValue.string(from: bookingDate.date) // 更新Text Field的內容
    }
    
    @IBOutlet weak var returnDatetxt: UITextField!
    @IBOutlet weak var returnDate: UIDatePicker!
    @IBAction func returnDatePicker(_ sender: UIDatePicker) {
        //dateValue.dateFormat = "YYYY-MM-dd" // 設定要顯示在Text Field的日期時間格式
        returnDateValue = returnDate.date.hashValue
        returnDatetxt.text = dateValue.string(from: returnDate.date) // 更新Text Field的內容
    }
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quantitytxt.delegate = self
        dateValue.dateFormat = "YYYY-MM-dd"
        moviecustomerpicker.dataSource = self as! UIPickerViewDataSource
        moviecustomerpicker.delegate = self as! UIPickerViewDelegate
        // Do any additional setup after loading the view.
        moviecustomerpicker.selectRow(0,inComponent:0,animated:true)
        moviecustomerpicker.selectRow(0,inComponent:1,animated:true)
        moviecustomerpicker.reloadAllComponents()

    }
    override func viewDidAppear(_ animated: Bool) {
        if(title == "Edit Booking Details"){
            movietxt.text = booking.movie?.name
            customertxt.text = booking.customer?.name
            quantitytxt.text = String(booking.quantity!)
            bookingDatetxt.text = booking.bookingDate!
            returnDatetxt.text = booking.returnDate!
            //dateValue.dateFormat = "YYYY-MM-dd"
            bookingDate.setDate(dateValue.date(from: booking.bookingDate!)!, animated: false)
            returnDate.setDate(dateValue.date(from: booking.returnDate!)!, animated: false)
            bookingDateValue = bookingDatetxt.hashValue
            returnDateValue = returnDatetxt.hashValue
        }
        button.setTitle(btnTitle, for:.normal)
    }
    
    //列数
    func numberOfComponents(in moviecustomerpicker: UIPickerView) -> Int {
        return 2
    }
    
    //行数
    func pickerView(_ moviecustomerpicker: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        if 0 == component {
            return AppDelegate.MovieList.count
        }else {
            return AppDelegate.CustomerList.count
        }
    }
    
    //内容
    func pickerView(_ moviecustomerpicker: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        if 0 == component {
            return AppDelegate.MovieList[row].name
        }else {
            return AppDelegate.CustomerList[row].name
        }
    }
    
    func pickerView(_ moviecustomerpicker: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if 0 == component {
            print("111111111")
            movietxt.text = AppDelegate.MovieList[moviecustomerpicker.selectedRow(inComponent: 0)].name
        }else {
            customertxt.text = AppDelegate.CustomerList[moviecustomerpicker.selectedRow(inComponent: 1)].name
            print(customertxt.text)
        }
    }
    
    @IBAction func button(_ sender: UIButton) {
        let mid = moviecustomerpicker.selectedRow(inComponent: 0)
        let movie = AppDelegate.MovieList[mid].name
        print(movie)
        let cid = moviecustomerpicker.selectedRow(inComponent: 1)
        let customer = AppDelegate.CustomerList[cid].name
        print(customer)
        let quantity = quantitytxt.text
        let bookingDate = bookingDatetxt.text
        let returnDate = returnDatetxt.text
        
        if(movie == "" || customer == "" || quantity == "" || bookingDate == "" || returnDate == ""){
                let alertController = UIAlertController(title: "Alert:", message: "You need to input the value!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Edit it!", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }else if(Int(quantity!) == nil){
                let alertController = UIAlertController(title: "Error:", message: "The quantity should be Integer!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Edit it!", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
                quantitytxt.text = ""
        }else if(Movie.FindMovie(name: movie) == nil){
            let alertController = UIAlertController(title: "Error:", message: "Movie \(movie) isn't existed in the system!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Edit it!", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
                movietxt.text = ""
        }else if(Customer.FindCustomer(name: customer) == nil){
            let alertController = UIAlertController(title: "Error:", message: "Customer \(customer) isn't existed in the system!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Edit it!", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
                customertxt.text = ""
            }else if(bookingDateValue >= returnDateValue){
                print(bookingDateValue)
                print(returnDateValue)
                let alertController = UIAlertController(title: "Error:", message: "Booking Date must be smaller than Return Date", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Edit it!", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
                bookingDatetxt.text = ""
                returnDatetxt.text = ""
            }else if(title == "Edit Booking Details"){
                    for item in AppDelegate.BookingList{
                        if(item.id == booking.id){
                            item.movie = Movie.FindMovie(name:movie)!
                            item.customer = Customer.FindCustomer(name:customer)!
                            item.quantity = Int(quantity!)!
                            item.bookingDate = bookingDate!
                            item.returnDate = returnDate!
                        }
                    }
            }else{
            if((Booking.ExistedBooking(movie: movie, customer: customer, quantity: Int(quantity!)!, bookingDate: bookingDate!, returnDate: returnDate!)) != nil){
                let alertController = UIAlertController(title: "Error:", message: "\(movie) Booking for \(customer) is already existed!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Edit it!", style: .default, handler: nil)
                    alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
                    
            }else if((Movie.FindMovie(name: movie)?.quantity)! < Int(quantity!)!){
                let alertController = UIAlertController(title: "Error:", message: "\(movie) only has \(Movie.FindMovie(name: movie)!.quantity) in the system!", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "Edit it!", style: .default, handler: nil)
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                    quantitytxt.text = ""
                }else{
                    let m = Movie.FindMovie(name: movie)!
                let c = Customer.FindCustomer(name: customer)!
                    let booking = Booking(BookingDate: bookingDate!, ReturnDate: returnDate!, Customer:c , Movie:m , Quantity: Int(quantity!)!)
                    m.quantity -= Int(quantity!)!
                    AppDelegate.BookingList.append(booking)
                }
                quantitytxt.text = ""
                bookingDatetxt.text = ""
                returnDatetxt.text = ""
            }
        self.navigationController?.popViewController(animated: true)
        }
    
    //keyboard setting
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        movietxt.resignFirstResponder()
        customertxt.resignFirstResponder()
        quantitytxt.resignFirstResponder()
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
