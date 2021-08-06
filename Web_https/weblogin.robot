*** Settings ***

Library           Selenium2Library
Library           String
Library           BuiltIn
Test Teardown     close all browsers

*** Variables *** 
${HOST}  https://192.168.1.1
${BROWSER}  chrome
${User_value}  manager
${Password_value}  friend

# XPATH path
${User_xpath}    //*[@id="Login"]
${Password_xpath}    //*[@id="Password"]
${login_button}    //*[@id="BodyBox"]/tbody/tr[4]/td/input[1]     
${get_system}    //*[@id="main"]/div[1]

*** Test Cases ***

Valid Login
    [Documentation]     Test sample
    Input password and wait page accessed

*** Keywords ***
    
Input password and wait page accessed
    FOR    ${index}    IN RANGE    1    1000
        Log to console    Running for ${index} times
        Open Browser    ${HOST}    ${BROWSER}    options=add_argument("--ignore-certificate-errors")
        Wait Until Page Contains    Password    30        
        Input Text      ${User_xpath}   ${User_value}
        Input Text      ${Password_xpath}   ${Password_value}
        Click Button    ${login_button}        
        Wait Until Page Contains    WebSmart Switch
        Log    PASSED
        close browser
        sleep    10
    END
    

    

