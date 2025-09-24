*** Settings ***
Library    SeleniumLibrary
Variables    ../Variables/customerpage.py
Resource    App.resource

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
    ${first_name}    SeleniumLibrary.Get Element Attribute    ${customers_txt_firstname}    value
    Log To Console    ${first_name}
    Should Be Equal As Strings    ${user["name"].split(" ")[0]}       ${first_name}
    Log To Console    First Name Input Is Correct

    ${second_name}    SeleniumLibrary.Get Element Attribute    ${customers_txt_lastname}    value
    Log To Console    ${second_name}
    Should Be Equal As Strings    ${user["name"].split(" ")[1]}   ${second_name}
    Log To Console    Second Name Input Is Correct

    ${email}    SeleniumLibrary.Get Element Attribute    ${customers_txt_email}    value
    Log To Console    ${email}
    Should Be Equal As Strings    ${user["email"]}   ${email}
    Log To Console    Email Input Is Correct

    ${birthday}    SeleniumLibrary.Get Element Attribute    ${customers_txt_birthday}    value
    Log To Console    ${birthday}
    ${birthday}=    Format Birthday    ${birthday}
    Should Be Equal As Strings    ${user["birthday"]}    ${birthday}
    Log To Console    Birthday Input Is Correct

    ${address}    SeleniumLibrary.Get Element Attribute    ${customers_txt_address}    value
    Log To Console    ${address}
    ${city}    SeleniumLibrary.Get Element Attribute    ${customers_txt_city}    value
    Log To Console    ${city}
    ${stateAbbr}    SeleniumLibrary.Get Element Attribute    ${customers_txt_stateAbbr}    value
    Log To Console    ${stateAbbr}
    ${zipcode}    SeleniumLibrary.Get Element Attribute    ${customers_txt_zipcode}    value
    Log To Console    ${zipcode}
    ${password}    SeleniumLibrary.Get Element Attribute    ${customers_txt_password}    value
    Log To Console    ${password}
    ${confirm_password}    SeleniumLibrary.Get Element Attribute    ${customers_txt_confirm_password}    value
    Log To Console    ${confirm_password}

    # Go To Customers Page
    # Refresh Current Page
    # ${fetched_name}    Get Text     ((${table_row})[1]//td)[2]
    # IF    "\\n" in """${fetched_name}"""
    #     ${fetched_name}    Evaluate    """${fetched_name}""".replace("\\n","")[1:]
    # END
    # Should Contain     ${user["name"]}    ${fetched_name}
    # Log To Console    ${fetched_name}
    

