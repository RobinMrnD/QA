*** Settings ***
Resource    ../Resources/App.resource
Resource    ../Resources/CustomerPage.resource

Suite Setup    Launch Browser
*** Variables ***


*** Test Cases ***
TEST-000001
    Login User
    ${users}    Get Random Customers    1    5
    Go To Customers Page

    FOR    ${i}    IN RANGE    0    5
        ${user}=    Set Variable    ${users}[${i}]
        Create Customer    ${user}
        Verify Customer Input    ${user}
    END


    ${total}=    Get Length    ${users}
    ${end}=      Evaluate      ${total} + 1
    FOR    ${index}    IN RANGE    1    ${end}
        ${user_index}=    Evaluate    ${total} - ${index}
        ${user}=          Set Variable    ${users}[${user_index}]
        Verify Customer Data    ${user}    ${index}
    END

TEST-000002
    ${users}    Get Random Customers    6    5
    Update Customer Table    ${users}

TEST-000003
    Get Table Row Data
   

*** Keywords ***
Launch Browser    
    [Arguments]    ${url}=${URL}    ${element_to_wait}=${login_txt_username}
    Open Browser    ${url}    chrome    options=add_argument("--start-maximized")

Login User
    [Arguments]    ${username}=${USERNAME}    ${password}=${PASSWORD}
    Wait Until Element Is Visible    ${login_avatar}
    Input Text    ${login_txt_username}    ${username}
    Input Text    ${login_txt_password}    ${password}
    Click Button    ${login_btn_submit}
    Wait Until Element Is Visible    ${logged_in_verif} 



