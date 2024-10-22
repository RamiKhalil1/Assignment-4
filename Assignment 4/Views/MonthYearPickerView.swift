import SwiftUI

struct MonthYearPickerView: View {
    
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    @Binding var date: Date
    @Binding var days: [Date]
    @State private var isMonthPickerPresented = false
    @State private var isYearPickerPresented = false
    
    var body: some View {
        HStack {
            Button(action: {
                isMonthPickerPresented.toggle()
            }) {
                Text("\(DateFormatter().monthSymbols[selectedMonth - 1])")
                    .font(.system(size: 18))
                    .foregroundColor(.blue)
            }
            .sheet(isPresented: $isMonthPickerPresented) {
                VStack {
                    Picker(selection: $selectedMonth, label: Text("Month")) {
                        ForEach(1..<13) { month in
                            Text("\(DateFormatter().monthSymbols[month - 1])").tag(month)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .onChange(of: selectedMonth) {
                        date = updateDateForNewMonthOrYear(newMonth: selectedMonth, newYear: selectedYear, date: date)
                    }
                    Button("Done") {
                        isMonthPickerPresented = false
                    }
                }
            }
            
            Button(action: {
                isYearPickerPresented.toggle()
            }) {
                Text(yearFormatter.string(from: NSNumber(value: selectedYear)) ?? "\(selectedYear)")
                    .font(.system(size: 18))
                    .foregroundColor(.blue)
            }
            .sheet(isPresented: $isYearPickerPresented) {
                VStack {
                    Picker(selection: $selectedYear, label: Text("Year")) {
                        ForEach(1900...2100, id: \.self) { year in
                            Text("\(year)").tag(year)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .onChange(of: selectedYear) {
                        date = updateDateForNewMonthOrYear(newMonth: selectedMonth, newYear: selectedYear, date: date)
                    }
                    Button("Done") {
                        isYearPickerPresented = false
                    }
                }
            }
            
            Spacer()
            
            Button(){
                if selectedMonth > 1 {
                    selectedMonth -= 1
                } else {
                    selectedYear -= 1
                    selectedMonth = 12
                }
                date = updateDateForNewMonthOrYear(newMonth: selectedMonth, newYear: selectedYear, date: date)
                days = date.calendarDisplayDays
            } label: {
                Image(systemName: "arrowshape.backward.fill")
            }
            
            Button(){
                if selectedMonth < 12 {
                    selectedMonth += 1
                } else {
                    selectedYear += 1
                    selectedMonth = 1
                }
                date = updateDateForNewMonthOrYear(newMonth: selectedMonth, newYear: selectedYear, date: date)
                days = date.calendarDisplayDays
            } label: {
                Image(systemName: "arrowshape.forward.fill")
            }
        }
    }
}
