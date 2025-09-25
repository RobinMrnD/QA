*** Settings ***
Resource    ../Resources/App.resource
Resource    ../Resources/CustomerPage.resource
Suite Setup    Launch Browser

*** Test Cases ***
TEST-000001
    Login User
    # In case of a google password breach warning, include Sleep 5s to allow user to close the popup window
    ${users}=    Get Random Customers    1    5
    Go To Customers Page
    Create And Verify Customers    ${users}
    Verify Customers Data In Table    ${users}

TEST-000002
    ${users}    Get Random Customers    6    5
    Update Customer Table    ${users}

TEST-000003
    Get Table Row Data

TEST-000004
    Get Expense Report
   





