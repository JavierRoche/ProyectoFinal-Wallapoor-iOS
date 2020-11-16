//
//  ProductViewController+Layout.swift
//  Wallapobre
//
//  Created by APPLE on 01/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit
import MessageKit

extension NewProductViewController: UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: UITextView / UITextField Delegates (Hiding Keyboard)
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    /// Control del numero de caracteres en UITextView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == Constants.NewParagraph {
            textView.resignFirstResponder()
            return false
        }
        
        let currentText = descriptionTextView.text ?? String()
        guard let range = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: range, with: text)
        /// Se permiten 200 caracteres para la descripcion
        return updatedText.count < 200
    }
    
    /// Control del numero de caracteres en UITextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == Constants.NewParagraph {
            textField.resignFirstResponder()
            return false
        }
        
        if textField == titleTextField {
            let currentText = titleTextField.text ?? String()
            guard let range = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: range, with: string)
            /// Se permiten 40 caracteres  para el titulo
            return updatedText.count < 40
            
        } else if textField == priceTextField {
            let currentText = priceTextField.text ?? String()
            guard let range = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: range, with: string)
            /// Se permiten 6 numeros para el precio
            return updatedText.count < 6
            
        } else if textField == categoryTextField {
            let currentText = categoryTextField.text ?? String()
            guard let range = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: range, with: string)
            /// No se permite escribir, solo seleccionar
            return updatedText.count < 0
        }
        return true
    }
    
    
    // MARK: UIPickerView DataSource / UIPickerView Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewModel.numberOfCategories()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.viewModel.getCategoryViewModel(at: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.viewModel.categoryPicked = Category(rawValue: row)
        
        DispatchQueue.main.async { [weak self] in
            self?.categoryTextField.text = self?.viewModel.getCategoryViewModel(at: row)
        }
    }
}



