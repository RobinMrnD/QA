
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


    Go To Customers Page
    Refresh Current Page

    


Open Customer By Index
    [Arguments]    ${index}
    ${locator}=    Set Variable    //table//tbody//tr[${index}]//td[2]//a
    Click Element    ${locator}
    Wait Until Element Is Visible    ${customers_txt_firstname}

Verify Customer Data
    [Arguments]    ${user}    ${index}
    Go To Customers Page
    Wait Until Element Is Visible    ${table_row}
    Open Customer By Index    ${index}
    Verify Customer Input    ${user}


# May sometimes bug out and may need to be retried
Update Customer Table
    [Arguments]    ${users}
    ${total}=    Get Length    ${users}
    ${end}=      Evaluate    ${total} + 1

    FOR    ${index}    IN RANGE    1    ${end}
        ${user_index}=    Evaluate    ${index} - 1
        ${user}=          Set Variable    ${users}[${user_index}]

        Go To Customers Page
        Open Customer By Index    ${index + 5}    
        Wait Until Element Is Visible    ${customers_txt_firstname}

        Clear And Input Text    ${customers_txt_firstname}  ${user["name"].split(" ")[0]}
        Clear And Input Text    ${customers_txt_lastname}   ${user["name"].split(" ")[1]}
        Clear And Input Text    ${customers_txt_email}    ${user["email"]}
        Input Text    ${customers_txt_birthday}    ${user["birthday"]}
        Clear And Input Text    ${customers_txt_address}    ${user["address"]["street"]} ${user["address"]["suite"]}
        Clear And Input Text    ${customers_txt_city}    ${user["address"]["city"]}
        Clear And Input Text    ${customers_txt_stateAbbr}    ${user["stateAbbr"]}
        Clear And Input Text    ${customers_txt_zipcode}    ${user["address"]["zipcode"]}
        Clear And Input Text    ${customers_txt_password}    ${user["password"]}
        Clear And Input Text    ${customers_txt_confirm_password}     ${user["password"]}

        Click Button    ${customers_btn_save}
        Wait Until Page Contains    Customer updated
    END


Clear And Input Text
    [Arguments]    ${locator}    ${value}
    Click Element    ${locator}
    Press Keys       ${locator}    CTRL+A    BACKSPACE
    Input Text       ${locator}    ${value}

Get Table Row Data
    Sleep    3s
    ${last_seen}    Get Text    ${last_seen_selector}
    Log To Console    ${last_seen}
    ${orders}    Get Text    ${orders_selector}
    Log To Console    ${orders}
    ${total_spent}    Get Text    ${total_spent_selector}
    Log To Console    ${total_spent}
    ${latest_purchase}    Get Text    ${latest_purchase_selector}
    Log To Console    ${latest_purchase}
    ${news}    Get Element Attribute    ${news_selector}     aria-label
    Log To Console    ${news}






