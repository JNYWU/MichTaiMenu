// Clean up +886 and whitespaces in phone numbers
func FormatPhoneNumber(phone: String) -> String {
    
    var formattedNumber: String = phone
    let tel = "tel://"
    
    if phone.first != "+" {
        return "0"
    } else {
        formattedNumber = formattedNumber.trimmingCharacters(in: .whitespaces)
        formattedNumber = tel + formattedNumber
        
        return formattedNumber
    }
}
