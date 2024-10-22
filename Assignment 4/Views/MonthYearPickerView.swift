import SwiftUI

struct MonthYearPickerView: View {
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    @Binding var date: Date
    @Binding var days: [Date]
    @State private var isPickerPresented = false

    var body: some View {
        HStack {
            Button(action: {
                isPickerPresented.toggle()
            }) {
                Text("\(DateFormatter().monthSymbols[selectedMonth - 1]) \(getYearFormat(year: selectedYear))")
                    .font(.system(size: 18))
                    .foregroundColor(.blue)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(5)
            }
            .sheet(isPresented: $isPickerPresented) {
                VStack {
                    HStack {
                        Picker(selection: $selectedMonth, label: Text("Month")) {
                            ForEach(1..<13) { month in
                                Text("\(DateFormatter().monthSymbols[month - 1])").tag(month)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .onChange(of: selectedMonth) {
                            date = updateDateForNewMonthOrYear(newMonth: selectedMonth, newYear: selectedYear, date: date)
                            days = date.calendarDisplayDays
                        }
                        
                        Picker(selection: $selectedYear, label: Text("Year")) {
                            ForEach(1900...2100, id: \.self) { year in
                                Text(getYearFormat(year: year)).tag(year)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .onChange(of: selectedYear) {
                            date = updateDateForNewMonthOrYear(newMonth: selectedMonth, newYear: selectedYear, date: date)
                            days = date.calendarDisplayDays
                        }
                    }
                    Button("Done") {
                        isPickerPresented = false
                    }
                    .padding(.top)
                }
                .padding()
            }

            Spacer()
            
            Button(action: {
                if selectedMonth > 1 {
                    selectedMonth -= 1
                } else {
                    selectedYear -= 1
                    selectedMonth = 12
                }
                date = updateDateForNewMonthOrYear(newMonth: selectedMonth, newYear: selectedYear, date: date)
                days = date.calendarDisplayDays
            }) {
                Image(systemName: "arrowshape.backward.fill")
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(5)
            }
            
            Button(action: {
                if selectedMonth < 12 {
                    selectedMonth += 1
                } else {
                    selectedYear += 1
                    selectedMonth = 1
                }
                date = updateDateForNewMonthOrYear(newMonth: selectedMonth, newYear: selectedYear, date: date)
                days = date.calendarDisplayDays
            }) {
                Image(systemName: "arrowshape.forward.fill")
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(5)
            }
        }
    }
    
    func getYearFormat(year: Int) -> String {
        
        return yearFormatter.string(from: NSNumber(value: year)) ?? String(year)
    }
}
