*** Settings ***

Library    Selenium2Library
Library    String
Library    BuiltIn
Library    OperatingSystem
Library    Process
Test Teardown     close all browsers

*** Variables ***
# Apresia GS110GT-SS

${dut_ip}    10.3.4.19
${User_value}  adpro
${Password_value}
${loop_times}    30



${url}  https://${dut_ip}
${BROWSER}  Chrome

# XPATH path
${User_xpath}    //input[@id='Login']
${Password_xpath}    //input[@id='Password']
${login_button}    //button[@id='login_ok']
${logout}    //*[@id="logout"]

${systemUP}    //*[@id="content"]/div/div[2]/table/tbody/tr[2]/td[1]/span
${systeminfo_failed_H001}    //*[@id="content"]/div/div[2]/table/tbody/tr[1]/td/b/kv

# Write the message
${PATH}    ${CURDIR}\\result.txt
${message1}    PASSED , Login successed
${message2}    FAILED , Issue1 : Page contained H001_022/Hxxx
${message3}    FAILED , Issue2 : Page only contained "switch information" word and others are blank
${message4}    FAILED , Issue3 : DUT cannot reply Ping , Maybe system crashed or rebooted



*** Keywords ***

create new browser
    Open Browser    ${url}    ${BROWSER}    options=add_argument("--ignore-certificate-errors")
    Set Selenium Implicit Wait    10

login to dut
    Go To    ${url}
    sleep    5
    Wait Until Page Contains    Password    30        
    Input Text      ${User_xpath}   ${User_value}
    sleep    1
    Input Text      ${Password_xpath}   ${Password_value}
    sleep    1
    Click Button    ${login_button}
    sleep    3

    ${alert_message}=    Handle Alert    action=ACCEPT    timeout=10
    ${status}=    Run Keyword And Return Status    Wait Until Element Is Visible    myframe
    [Return]    ${status}    ${alert_message}
        
check login successed
    Select frame    myframe 
    ${IsElementVisible}=  Run Keyword And Return Status    Wait Until Page Contains Element   ${systemUP}
    IF    ${IsElementVisible} == ${True}
        Log to console    ${message1}
        ${value} =    Set Variable    0
        ${message} =    Set Variable   ${message1}          
    ELSE
        ${condition}=     Run keyword And Return Status    Wait Until Page Contains Element   ${systeminfo_failed_H001}
        IF    ${condition} == ${True}
            Log to console    ${message2}
            ${value} =    Set Variable  1
            ${message} =    Set Variable   ${message2}  
        ELSE            
            Log to console    ${message3}
            ${value} =    Set Variable  2
            ${message} =    Set Variable   ${message3} 
        END
    END
    [Return]    ${value}    ${message}
    
close browser
    close browser

write result to file 
    Create File    {PATH}    encoding=UTF-8
    Append To File    result.txt    ${write_result}${\n}    UTF-8

Ping test
    ${result} =     Run Process    ping ${dut_ip} -c 1   shell=True  stdout=stdout.txt    output_encoding=UTF-8
    ${TextFileContent}=    Get File    stdout.txt    encoding=UTF-8    encoding_errors=strict
    Log to console   ${TextFileContent}
    ${status}=    Run Keyword And Return Status    Should Contain Any    ${TextFileContent}    Reply from
    [Return]    ${status}    

*** Test Cases ***

Valid Login
    [Documentation]     Test Login behavior
    create new browser
    # FOR    ${index}    IN RANGE    1    ${loop_times} + 1
    FOR    ${i}    IN RANGE    1    999999
        Log to console    Running for ${i} times
        ${status}=    Ping test
        IF    ${status} == ${True}
            ${counter}    Evaluate    ${i} + 1
            Log to console    Ping ok , Continue the Testing...       
            ${login_status}=    login to dut
            Log to console    ${login_status}
            IF    ${login_status}[0] == ${True}
                ${result} =    check login successed
                Set Suite Variable    ${write_result}    Running for ${i} times : ${result}[1]    
                write result to file
                sleep    3        
            ELSE 
                Log to console    Unable to login to system page , skip the test   
            END
        ELSE
            ${counter}    Evaluate    ${i} + 1
            Log to console    ${message4}
            Log to console    Waiting for DUT rebooting for 60 sec
            sleep    60
            Set Suite Variable    ${write_result}    ${message4}
            write result to file
        END
        Exit For Loop If    ${counter} > ${loop_times}
    END
    Log to console    End the Testing
    

    
    
    

    

    

