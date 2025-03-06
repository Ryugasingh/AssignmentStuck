//
//  AddProductView.swift
//  AssignmentStuck
//
//  Created by Sambhav Singh on 13/02/25.
//

import SwiftUI

struct AddProductView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ProductViewModel

    @State private var productName: String = ""
    @State private var productType: String = ""
    @State private var price: String = ""
    @State private var tax: String = ""
    
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingImagePicker = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Product Details")) {
                    TextField("Product Name", text: $productName)
                    TextField("Product Type", text: $productType)
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                    TextField("Tax", text: $tax)
                        .keyboardType(.decimalPad)
                    
                    Button("Select Image") {
                        isShowingImagePicker = true
                    }
                    
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                }
                
                Section {
                    Button("Submit") {
                        submitProduct()
                    }
                }
                
                if !viewModel.message.isEmpty {
                    Section {
                        Text(viewModel.message)
                            .foregroundColor(viewModel.message.contains("successfully") ? .green : .red)
                    }
                }
            }
            .navigationTitle("Add Product")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
    
    func submitProduct() {
        guard let priceValue = Double(price),
              let taxValue = Double(tax)
        else {
            viewModel.message = "Please enter valid numbers for Price and Tax."
            return
        }
        
        let newProduct = Product(image: "",  // if you need a URL, adjust accordingly
                                 price: priceValue,
                                 productName: productName,
                                 productType: productType,
                                 tax: taxValue)
        
        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
        
        Task {
            let success = await viewModel.addProduct(newProduct, imageData: imageData)
            if success {
                viewModel.message = "Product added successfully!"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    dismiss()
                }
            }
        }
    }
}

