*** Settings ***
Resource    ../Resources/App.resource
Resource    ../Resources/CustomerPage.resource

Suite Setup    Launch Browser
*** Variables ***


*** Test Cases ***
TEST-000001
    Login User

TEST-000002
    ${users}    Get Random Customers
    Go To Customers Page
    
    FOR    ${i}    IN    @{users}
        Create Customer    ${i}
        Verify Customer Input    ${i}
    END

    


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



