
*** Settings ***
Library    SeleniumLibrary
Library    ../Libraries/CustomLibraries.py
Library    Collections
Library    String
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

Create And Verify Customers
    [Arguments]    ${users}
    ${count} =    Get Length    ${users}
    FOR    ${i}    IN RANGE    ${count}
        ${user} =    Set Variable    ${users}[${i}]
        Create Customer    ${user}
        Verify Customer Input    ${user}
    END

Verify Customers Data In Table
    [Arguments]    ${users}
    ${total} =    Get Length    ${users}
    ${end} =      Evaluate    ${total} + 1
    FOR    ${index}    IN RANGE    1    ${end}
        ${user_index}=    Evaluate    ${total} - ${index}
        ${user}=    Set Variable    ${users}[${user_index}]
        Verify Customer Data    ${user}    ${index}
    END

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

Get Customer Name
    [Arguments]    ${r}
    ${target}=    Set Variable    //table//tbody//tr[${r}]//td[2]//a//*[self::span or self::p][last()]
    ${has}=       Run Keyword And Return Status    Page Should Contain Element    ${target}
    IF    ${has}
        ${raw}=    Get Text    ${target}
    ELSE
        ${raw}=    Get Text    //table//tbody//tr[${r}]//td[2]//a
        ${lines}=  Split To Lines    ${raw}
        ${raw}=    Get From List    ${lines}    -1
    END
    ${name}=    Replace String    ${raw}    \n    ${SPACE}
    ${name}=    Strip String      ${name}
    RETURN    ${name}

Get Table Row Data
   Go To Customers Page
   Wait Until Element Is Visible    ${table_row}

   ${row_count}=    Get Element Count    ${table_row}
   ${end}=          Evaluate    ${row_count} + 1

   FOR    ${r}    IN RANGE    1    ${end}
       ${name}=              Get Customer Name    ${r}
       ${last_seen}=         Get Text    //table//tbody//tr[${r}]//td[3]
       ${orders}=            Get Text    //table//tbody//tr[${r}]//td[4]
       ${total_spent}=       Get Text    //table//tbody//tr[${r}]//td[5]
       ${latest_purchase}=   Get Text    //table//tbody//tr[${r}]//td[6]
       ${news}=              Get Element Attribute    xpath=${news_selector.format(r=${r})}    aria-label
       ${segments}=          Get WebElements    xpath=${segment_selector.format(r=${r})}
       @{segment_texts}=     Create List
       FOR    ${seg}    IN    @{segments}
           ${text}=    Get Text    ${seg}
           Append To List    ${segment_texts}    ${text}
       END
       Log To Console    ====== User ${r} ======
       Log To Console    Name: ${name}
       Log To Console    Last seen: ${last_seen}
       Log To Console    Orders: ${orders}
       Log To Console    Total spent: ${total_spent}
       Log To Console    Latest purchase: ${latest_purchase}
       Log To Console    News: ${news}
       Log To Console    Segment: ${segment_texts}
       Log To Console    --------------------------------------------
   END


Get Expense Report
    ${rows}=    Get Element Count    ${table_row}
    ${counter}=    Set Variable    1
    ${total_spending}=    Set Variable    0

    FOR    ${r}    IN RANGE    1    ${rows+1}
        ${name}=    Get Customer Name    ${r}
        ${total_spent}=    Get Text    xpath=${total_spent_selector.format(r=${r})}
        ${clean}=    Evaluate    float(str("${total_spent}").replace("$","").replace(",","").strip())
        Run Keyword If    ${clean} > 0    Log To Console    ${counter}. ${name}: ${total_spent}
        Run Keyword If    ${clean} > 0    Set Variable    ${counter}=    Evaluate    ${counter} + 1
        ${total_spending}=    Evaluate    ${total_spending} + ${clean}
    END

    ${total_formatted}=    Evaluate    f"{${total_spending}:,.2f}"
    Log To Console    ================================
    Log To Console    Total Customer Spending: $${total_formatted}
    Log To Console    ================================

    ${threshold}=    Set Variable    3500
    ${threshold_fmt}=    Evaluate    "{:,}".format(${threshold})
    ${total_formatted}=    Evaluate    "{:.2f}".format(${total_spending})

    Run Keyword If    ${total_spending} < ${threshold}    Fail    FAIL: Total spending ($${total_formatted}) is below minimum threshold ($${threshold_fmt})
    ...    ELSE    Log To Console    PASS: Total spending ($${total_formatted}) meets minimum threshold ($${threshold_fmt})






