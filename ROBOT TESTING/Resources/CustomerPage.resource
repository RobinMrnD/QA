
*** Settings ***
Library    SeleniumLibrary
Library    ../Libraries/CustomLibraries.py
Library    Collections
Variables  ../Variables/customerpage.py
Resource   App.resource

*** Keywords ***
Go To Customers Page
    Click Element    ${nav_btn_customers}
    Wait Until Element Is Visible    //table/tbody//tr

Create Customer
    [Arguments]    ${user}
    Click Element    ${customers_btn_create}
    Wait Until Element Is Visible    ${customers_txt_firstname}
    Input Text    ${customers_txt_firstname}    ${user["name"].split(" ")[0]}
    Input Text    ${customers_txt_lastname}    ${user["name"].split(" ")[1]}
    Input Text    ${customers_txt_email}    ${user["email"]}
    Input Text    ${customers_txt_birthday}    ${user["birthday"]}
    Input Text    ${customers_txt_address}    ${user["address"]["street"]} ${user["address"]["suite"]}
    Input Text    ${customers_txt_city}    ${user["address"]["city"]}
    Input Text    ${customers_txt_stateAbbr}    ${user["stateAbbr"]}
    Input Text    ${customers_txt_zipcode}    ${user["address"]["zipcode"]}
    Input Text    ${customers_txt_password}    ${user["password"]}
    Input Text    ${customers_txt_confirm_password}    ${user["password"]}
    Click Button    ${customers_btn_save}
    Wait Until Page Contains    Customer created

Verify Customer Input
    [Arguments]    ${user}

    ${first_name}    Get Element Attribute    ${customers_txt_firstname}    value
    Should Be Equal As Strings    ${user["name"].split(" ")[0]}    ${first_name}
    Log To Console    First Name Input Is Correct

    ${second_name}   Get Element Attribute    ${customers_txt_lastname}     value
    Should Be Equal As Strings    ${user["name"].split(" ")[1]}    ${second_name}
    Log To Console    Second Name Input Is Correct

    ${email}         Get Element Attribute    ${customers_txt_email}        value
    Should Be Equal As Strings    ${user["email"]}    ${email}
    Log To Console    Email Input Is Correct

    ${birthday}      Get Element Attribute    ${customers_txt_birthday}     value
    ${birthday}=     Format Birthday    ${birthday}
    Should Be Equal As Strings    ${user["birthday"]}    ${birthday}
    Log To Console    Birthday Input Is Correct

    ${address}       Get Element Attribute    ${customers_txt_address}      value
    Should Be Equal As Strings    ${user["address"]["street"]} ${user["address"]["suite"]}    ${address}
    Log To Console    Address Input Is Correct

    ${city}          Get Element Attribute    ${customers_txt_city}         value
    Should Be Equal As Strings    ${user["address"]["city"]}    ${city}
    Log To Console    City Input Is Correct

    ${stateAbbr}     Get Element Attribute    ${customers_txt_stateAbbr}    value
    Should Be Equal As Strings    ${user["stateAbbr"]}    ${stateAbbr}
    Log To Console    State Abbr Input Is Correct

    ${zipcode}       Get Element Attribute    ${customers_txt_zipcode}      value
    Should Be Equal As Strings    ${user["address"]["zipcode"]}    ${zipcode}
    Log To Console    Zipcode Input Is Correct

    ${password}      Get Element Attribute    ${customers_txt_password}     value
    Should Be Equal As Strings    ${user["password"]}    ${password}
    Log To Console    Password Input Is Correct

    ${confirm_password}    Get Element Attribute    ${customers_txt_confirm_password}    value
    Should Be Equal As Strings    ${user["password"]}    ${confirm_password}
    Log To Console    Confirm Password Input Is Correct

    &{verified_customer}=    Create Dictionary
    ...    first_name=${first_name}
    ...    last_name=${second_name}
    ...    email=${email}
    ...    birthday=${birthday}
    ...    address=${address}
    ...    city=${city}
    ...    stateAbbr=${stateAbbr}
    ...    zipcode=${zipcode}
    ...    password=${password}
    ...    confirm_password=${confirm_password}

    Log To Console    ===== Verified Customer Captured =====
    Log To Console    ${verified_customer}

    Append To List    ${ALL_VERIFIED_CUSTOMERS}    ${verified_customer}
    Set Suite Variable    ${ALL_VERIFIED_CUSTOMERS}

    Log To Console    ===== Current Accumulated Customers =====
    Log To Console    ${ALL_VERIFIED_CUSTOMERS}

    Go To Customers Page
    Refresh Current Page



    # Go To Customers Page
    # Refresh Current Page
    # ${fetched_name}    Get Text     ((${table_row})[1]//td)[2]
    # IF    "\\n" in """${fetched_name}"""
    #     ${fetched_name}    Evaluate    """${fetched_name}""".replace("\\n","")[1:]
    # END
    # Should Contain     ${user["name"]}    ${fetched_name}
    # Log To Console    ${fetched_name}
    

