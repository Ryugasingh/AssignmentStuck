//
//  ContentView.swift
//  AssignmentStuck
//
//  Created by Sambhav Singh on 11/02/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ProductViewModel() 

    var body: some View {
        NavigationStack {
            List(viewModel.filteredProducts) { product in
                ProductCardView(product: product)
                    .listRowSeparator(.hidden)
            }
            .navigationTitle("Products")
            .listStyle(.plain)
            .searchable(text: $viewModel.searchText, prompt: "Search Product")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: { viewModel.showingAddProduct = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddProduct) {
                AddProductView(viewModel: viewModel)
            }
        }
        .task {
            await viewModel.fetchProducts()
        }
    }
}

#Preview {
    ContentView()
}
