Invariant:  idi-1
Description: "One of identifier or telecom or family and given names or address or birthdate SHALL be present"
Expression:  "identifier.exists() or telecom.exists() or (name.family.exists() and name.given.exists()) or (address.line.exists() and address.city.exists()) or birthDate.exists()"
Severity:   #error

Invariant:  idi-2
Description: "Either the given or family name SHALL be present"
Expression: "given.exists() or family.exists()"
Severity:   #error

//==========================================================================================================
// Weighted values:
// ----------------
//    10	Digital Identifier, Passport Number (PPN) and issuing country, Driver’s License Number (DL) and Issuing US State, or other State ID Number and Issuing US State (max weight of 10 for this category, even if multiple Numbers included)
//     4	Address (including line plus zip or city and state), telecom email or telecom phone, identifier (other than Digital Identifier, passport, DL or other state ID--for example, Insurance Member Identifier along with Payer Identifier, Medical Record Number and assigner, or SSN Last 5) OR Individual Profile Photo (i.e. max weight of 5 for any combination of 2 or more of these)
//     3	First Name & Last Name
//     2  Date of Birth
// 
// Base Invariant:
// ---------------
//     ((identifier.type.coding.exists(code = 'PPN') and identifier.value.exists()).toInteger()*10) +
//     ((identifier.type.coding.exists(code = 'DL' or code = 'STID') and identifier.value.exists()).toInteger()*10) +
//     ((((address.exists(use = 'home') and address.line.exists() and address.city.exists()).toInteger() + (identifier.type.coding.exists(code != 'PPN' and code != 'DL')).toInteger() + ((telecom.exists(system = 'email') and telecom.value.exists()) or (telecom.exists(system = 'phone') and telecom.value.exists())).toInteger() + (photo.exists()).toInteger()) > 1).toInteger() * 4) +
//     ((name.family.exists() and name.given.exists()).toInteger()*4)

Invariant:  idi-L0
Description: "Combined weighted values of included elements must have a minimum value of 9 (see Patient Weighted Elements table)"
Expression: "(
               (identifier.type.coding.exists(code = 'PPN' or code = 'DL' or code = 'STID') and identifier.value.exists()).toInteger()*10 +
               (min
                  (5,
                  (address.exists(use = 'home') and address.line.exists() and (address.zip.exists() or (address.state.exists() and address.city.exists()))).toInteger() + 
                  (telecom.exists(system = 'email') and telecom.value.exists()).toInteger() + 
                  (telecom.exists(system = 'phone') and telecom.value.exists()).toInteger() + 
                  (photo.exists()).toInteger()
                  )
               )*4 + 
               (name.family.exists() and name.given.exists()).toInteger()*3 + 
               (birthDate.exists().toInteger()*2)
             ) >= 9"
Severity:   #error

Invariant:  idi-L1
Description: "Demographics are consistent with a verification event performed as part of a documented identity verification process and the combined weighted values of included elements must have a minimum value of 10 (see Patient Weighted Elements table)"
Expression: "(
               (identifier.type.coding.exists(code = 'PPN' or code = 'DL' or code = 'STID') and identifier.value.exists()).toInteger()*10 +
               (min
                  (5,
                  (address.exists(use = 'home') and address.line.exists() and (address.zip.exists() or (address.state.exists() and address.city.exists()))).toInteger() + 
                  (telecom.exists(system = 'email') and telecom.value.exists()).toInteger() + 
                  (telecom.exists(system = 'phone') and telecom.value.exists()).toInteger() + 
                  (photo.exists()).toInteger()
                  )
               )*4 + 
               (name.family.exists() and name.given.exists()).toInteger()*3 + 
               (birthDate.exists().toInteger()*2)
             ) >= 10"
Severity:   #error
