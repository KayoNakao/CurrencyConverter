 //
//  ContentView.swift
//  CurrencyConvertor
//
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    @FocusState private var baseAmountIsFocused: Bool
    @FocusState private var conversionAmountIsFocused: Bool
    @State private var amount = ""
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text(viewModel.errorMessage)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.red)
                    Spacer()
                }
                Text("Amount")
                    .font(.system(size: 15))
                TextField("", value: $viewModel.baseAmount, formatter: viewModel.numberFormatter)
                    .focused($baseAmountIsFocused)
                    .onSubmit {
                        viewModel.convert()
                        baseAmountIsFocused = false
                        conversionAmountIsFocused = false
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.clear)
                            .stroke(Color.gray, lineWidth: 1)
                    }
                    .overlay(alignment: .trailing) {
                        HStack {
                            viewModel.baseCurrency.image()
                                .resizable()
                                .scaledToFill()
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                            Menu {
                                ForEach(CurrencyChoice.allCases) { currentChoice in
                                    Button {
                                        viewModel.baseCurrency = currentChoice
                                        viewModel.convert()
                                    } label: {
                                        Text(currentChoice.fetchMenuName())
                                    }

                                }
                            } label: {
                                Text(viewModel.baseCurrency.rawValue)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(.black)
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(.black)
                            }


                        }
                        .padding(.trailing)
                    }
                HStack {
                    Spacer()
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.vertical)
                    Spacer()
                }
                Text("Converted To")
                    .font(.system(size: 15))
                TextField("", value: $viewModel.convertedAmount, formatter: viewModel.numberFormatter)
                    .focused($conversionAmountIsFocused)
                    .font(.system(size: 15, weight: .semibold))
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.clear)
                            .stroke(Color.gray, lineWidth: 1)
                    }
                    .overlay(alignment: .trailing) {
                        HStack {
                            viewModel.conversionCurrency.image()
                                .resizable()
                                .scaledToFill()
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                            Menu {
                                ForEach(CurrencyChoice.allCases) { currencyChoice in
                                    Button(action: {
                                        viewModel.conversionCurrency = currencyChoice
                                        viewModel.convert()
                                        
                                    }, label: {
                                        Text(currencyChoice.fetchMenuName())
                                    })
                                }

                            } label: {
                                Text(viewModel.conversionCurrency.rawValue)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(.black)
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(.black)
                            }

                        }
                        .padding(.trailing)
                    }
                HStack {
                    Spacer()
                    Text("1.000000 \(viewModel.baseCurrency.rawValue) = \(viewModel.conversionRate) \(viewModel.conversionCurrency.rawValue)")
                        .font(.system(size: 18, weight: .semibold))
                        .padding(.top, 25)
                    Spacer()
                }
            }
            .padding(.horizontal)
            .task({
                await viewModel.fetchRates()
            })
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    ProgressView()
                        .tint(.white)
                }
            }
        }
        .onTapGesture {
            viewModel.convert()
            baseAmountIsFocused = false
            conversionAmountIsFocused = false
        }
    }
}

#Preview {
    ContentView()
}
