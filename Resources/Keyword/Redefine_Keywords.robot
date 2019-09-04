*** Settings ***
Library           Selenium2Library
Library           Collections
Library           String
Library           BuiltIn
Library           DateTime
Library           OperatingSystem

*** Keywords ***
Click Web Element
    [Arguments]    ${Locator}    ${Index}=None    ${Timeout}=${General_TimeOut}
    [Documentation]    Click element identified by locator.
    ...
    ...    Step in keyword
    ...
    ...    Line 1 : Run keyword "Wait Web Until Page Contains Element" and return status in parameter ${Result}
    ...    Line 2 : Run keyword "Wait Until Element Is Visible" If ${Result}=False
    ...    Line 3 :
    ...    Line 4 : Wait Until Keyword "Click Element" Runs the specified keyword and retries 10 time in 1 second if it fails.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Click Web Element | ${Locator} | ${Index}=None | ${Timeout}=${General_TimeOut}
    ####
    ${result}    BuiltIn.Run Keyword And Return Status    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    Comment    Comment    BuiltIn.Run Keyword If    '${result}'=='False'    Wait Web Until Page Contains Element    ${Locator}    ${Timeout}
    Comment    BuiltIn.Run Keyword If    '${result}'=='False'    Selenium2Library.Execute Javascript    scrollBy(0,-200);
    Web Scroll Element Into View    ${Locator}
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${Locator}

Close Firefox Browser
    [Documentation]    Close firefox browser.
    Kill Gecko Driver
    Close All Browsers

Close Web Browser
    [Documentation]    Close browser.
    ...    (Only open browser by robot framework)
    Selenium2Library.Close Browser

Common Input Web Element
    [Arguments]    ${Field}    ${Locator}    ${Text}
    [Documentation]    *"Common Input Web Element"*
    ...
    ...    *Format keyword*
    ...
    ...    *Common Input Web Element* | ${Field} | ${Locator} | ${Text}
    ...
    ...    *Example*
    ...
    ...    | *Common Input Web Element* | ${Field} | ${Xpath} | ${Text} |
    ${UpperCase}    String.Convert To Uppercase    ${Field}
    @{Type}    Get Regexp Matches    ${UpperCase}    ^(LIST|CHKBOX|FIELD|RADIO)
    ${Type}    Set Variable    @{Type}[0]
    ${Flag}    BuiltIn.Run Keyword If    '${Type}' == 'CHKBOX' or '${Type}' == 'RADIO'    Convert To Uppercase    ${Text}
    #Wait Loading not visible
    BuiltIn.Run Keyword If    '${Type}' == 'FIELD'    Input Web Text    ${Locator}    ${Text}
    ...    ELSE IF    ('${Type}' == 'CHKBOX' or '${Type}' == 'RADIO') and '${Flag}' == 'TRUE'    Click Web Element    ${Locator}
    ...    ELSE IF    ('${Type}' == 'CHKBOX' or '${Type}' == 'RADIO') and '${Flag}' == 'FALSE'    Web Unselect CheckBox    ${Locator}
    ...    ELSE IF    '${Type}' == 'LIST'    Select From Web List By Label    ${Locator}    ${Text}
    ...    ELSE    BuiltIn.Fail    Format is wrong.

Common Split Field And Index
    [Arguments]    ${Field}
    [Documentation]    *"Common Split Field And Index"*
    ...
    ...    *Format keyword*
    ...
    ...    *Common Split Field And Index* | ${Field}
    ...
    ...    ${FieldNoIndex} | ${Index} | *Common Split Field And Index* | ${Field}
    ...
    ...    *Example*
    ...
    ...    | ${Field} | ${Index} | *Common Split Field And Index* | ${Field} |
    ${FieldWithIndex} =    BuiltIn.Evaluate    re.search(r"\\[","${Field}")    re
    ${Index}    Run Keyword If    '${FieldWithIndex}' != 'None'    String.Remove String Using Regexp    ${Field}    \\\D
    ${FieldNoIndex}    String.Remove String Using Regexp    ${Field}    \\\[\\\d*]$
    ${FieldNoIndex}    String.Convert To Uppercase    ${FieldNoIndex}
    [Return]    ${FieldNoIndex}    ${Index}

Common Verify Error Message
    [Arguments]    ${Field}    ${Xpath}    ${Key}    ${Visible}=True
    ${Visible}    String.Convert To Uppercase    ${Visible}
    ${Field}    String.Convert To Uppercase    ${Field}
    ${Key}    String.Convert To Uppercase    ${Key}
    BuiltIn.Run Keyword And Return If    '${Visible}' == 'FALSE'    Web Element Should Be Not Visible    ${Xpath}
    ${ActualText}    BuiltIn.Run Keyword If    '${Visible}' == 'TRUE'    Get Web Text    ${Xpath}
    [Return]    ${Field}    ${Key}    ${ActualText}

Common Verify Field
    [Arguments]    ${Xpath}    @{Text}
    [Documentation]    *"Common Verify Field"*
    ...
    ...    *Format keyword*
    ...
    ...    *Common Verify Field* | ${Xpath} | @{Text}
    ...
    ...    *Example*
    ...
    ...    | *Common Verify Field* | ${Locator} | ${AppInfo} |
    ...
    ...    *Key to verify*
    ...    | Text |
    ...    | Length |
    ...    | Placeholder |
    ...    | Enable |
    ...    | AllItem |
    ...    | SelectedList |
    ...    | Visible |
    ...    | Check |
    ...    | Radio |
    ...    | ComboBox |
    @{ListText}    Split String    @{Text}    =    1
    ${Verify}    Set Variable    @{ListText}[0]
    ${Value}    Set Variable    @{ListText}[1]
    ${StringUpperCase}    String.Convert To Uppercase    ${Verify}
    BuiltIn.Run Keyword If    '${StringUpperCase}' == 'TEXT'    Verify Text    ${Xpath}    ${Value}
    ...    ELSE IF    '${StringUpperCase}' == 'LENGTH'    Verify Length    ${Xpath}    ${Value}
    ...    ELSE IF    '${StringUpperCase}' == 'PLACEHOLDER'    Verify Placeholder    ${Xpath}    ${Value}
    ...    ELSE IF    '${StringUpperCase}' == 'ENABLE'    Verify Enable    ${Xpath}    ${Value}
    ...    ELSE IF    '${StringUpperCase}' == 'ALLITEM'    Verify DropdownList    ${Xpath}    ${Value}
    ...    ELSE IF    '${StringUpperCase}' == 'SELECTEDLIST'    List Selection Should Be    ${Xpath}    ${Value}
    ...    ELSE IF    '${StringUpperCase}' == 'VISIBLE'    Verify Visible    ${Xpath}    ${Value}
    ...    ELSE IF    '${StringUpperCase}' == 'CHECK'    Verify CheckBox    ${Xpath}    ${Value}
    ...    ELSE IF    '${StringUpperCase}' == 'RADIO'    Verify Radio    ${Xpath}    ${Value}
    ...    ELSE IF    '${StringUpperCase}' == 'COMBOBOX'    Verify Combobox    ${Xpath}    ${Value}
    ...    ELSE    BuiltIn.Fail    ${Verify} is wrong format.

Get Locator From Position
    [Arguments]    ${Locator}    ${Position}=1
    [Documentation]    The Keyword Require two arg ${Locator} | ${Position}=1
    ...
    ...    and keyword return element from expect position
    ${StringMatch}    Run Keyword And Return Status    Should Match Regexp    ${Locator}    (i?)(x|X)path(|\s)=
    ${RegexpLocator}    Run Keyword If    ${StringMatch} == ${True}    Remove String Using Regexp    ${Locator}    (i?)(x|X)path(|\s)=
    ...    ELSE    Set Variable    ${Locator}
    ${ReturnLocator}    Set Variable    xpath=(${RegexpLocator})[position()='${Position}']
    Log many    ${ReturnLocator}
    [Return]    ${ReturnLocator}

Get Web Text
    [Arguments]    ${Locator}    ${Timeout}=${GENERAL_TIMEOUT}
    [Documentation]    Get text by returns the text value of element.
    ...
    ...    *Format keyword*
    ...
    ...    Get Web Text | ${Locator} | ${Timeout}=${General_TimeOut}
    ${result}    BuiltIn.Run Keyword And Return Status    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    BuiltIn.Run Keyword If    '${result}'=='False'    Wait Web Until Page Contains Element    ${Locator}    ${Timeout}
    Comment    ${Text}    Selenium2Library.Get Text    ${Locator}
    ${Text}    Wait Until Keyword Succeeds    5    1    Selenium2Library.Get Text    ${Locator}
    [Return]    ${Text}

Get Web Value
    [Arguments]    ${Locator}    ${Timeout}=${General_TimeOut}
    [Documentation]    Get value by returns the value of element.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Get Web Value | ${Locator} | ${Timeout}=${General_TimeOut}
    ${result}    BuiltIn.Run Keyword And Return Status    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    BuiltIn.Run Keyword If    '${result}'=='False'    Wait Web Until Page Contains Element    ${Locator}    ${Timeout}
    Run Keywords    Wait Until Keyword Succeeds    5x    1s    Selenium2Library.Wait Until Element Is Visible    ${Locator}
    ...    AND    Wait Web Until Page Contains Element    ${Locator}    ${Timeout}
    ${valueActual}    Selenium2Library.Get Value    ${Locator}
    [Return]    ${valueActual}

Input Web Text
    [Arguments]    ${Locator}    ${Text}    ${Timeout}=${General_TimeOut}
    [Documentation]    input text into text field identified by locator.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Input Web Text | ${Locator} | ${Text} | ${Timeout}=${General_TimeOut}
    ${result}    BuiltIn.Run Keyword And Return Status    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    BuiltIn.Run Keyword If    '${result}'=='False'    Wait Web Until Page Contains Element    ${Locator}    ${Timeout}
    Comment    Selenium2Library.Input Text    ${Locator}    ${Text}
    Wait Until Keyword Succeeds    5x    1s    Selenium2Library.Input Text    ${Locator}    ${Text}

Kill Gecko Driver
    Close All Browsers
    Run Process    taskkill /f /im geckodriver.exe    shell=True

Open Firefox Profile Browser
    [Arguments]    ${URL}    # ${FirefoxProfilePath}
    [Documentation]    Open Firefox Profile Browser
    ...    Keyword Require profile firefox url
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Open Firefox Profile Browser | ${Url}
    # Kill gecko
    Kill Gecko Driver
    # Open firefox browser
    ${IndexOfFolderList}=    Convert To Integer    2
    ${fileType}=    Create List    "application/msword"    #.doc_Microsoft Word 1997-2003
    Append To List    ${fileType}    "application/vnd.openxmlformats-officedocument.wordprocessingml.document"    #.docx_Microsoft Word 2007
    Append To List    ${fileType}    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"    #.xlsx_Microsoft Excel 2007
    Append To List    ${fileType}    "application/vnd.ms-excel"    #.xls_Microsoft Excel < 2007
    Append To List    ${fileType}    "application/vnd.ms-powerpoint"    #.ppt_Microsoft PowerPoint < 2007
    Append To List    ${fileType}    "application/vnd.openxmlformats-officedocument.presentationml.presentation"    #.pptx_Microsoft PowerPoint 2007
    Append To List    ${fileType}    "application/vnd.visio"    #.vsd_Microsoft Visio
    Append To List    ${fileType}    "application/pdf"    #pdf
    Append To List    ${fileType}    "image/jpeg"    #jpeg JPEG images
    Append To List    ${fileType}    "image/png"    #png Portable Network Graphics
    Append To List    ${fileType}    "text/plain"    #txt
    Append To List    ${fileType}    "application/x-7z-compressed"    #.7zip \    7-zip archive
    Append To List    ${fileType}    "application/zip"    #.zip
    Append To List    ${fileType}    "application/octet-stream"    #.zip,.rar
    Append To List    ${fileType}    "application/json"    # JSON Type
    Append To List    ${fileType}    "application/force-download"
    ${types}=    Evaluate    ', '.join(${fileType})
    log    ${types}
    #
    ${firefoxProfile}=    Evaluate    sys.modules['selenium.webdriver'].FirefoxProfile()    sys
    Call Method    ${firefoxProfile}    set_preference    browser.helperApps.alwaysAsk.force    ${False}
    Call Method    ${firefoxProfile}    set_preference    browser.download.manager.showWhenStarting    ${False}
    Call Method    ${firefoxProfile}    set_preference    browser.download.folderList    ${IndexOfFolderList}
    # Comment For wait download
    Call Method    ${firefoxProfile}    set_preference    browser.download.dir    ${Repository_Path}${Downloads_Folder}    #C:\\CreateProfileByPython
    Call Method    ${firefoxProfile}    set_preference    browser.helperApps.neverAsk.saveToDisk    ${types}
    Call Method    ${firefoxProfile}    set_preference    browser.download.manager.showWhenStarting    ${False}
    Call Method    ${firefoxProfile}    set_preference    pdfjs.disabled    ${True}
    Call Method    ${firefoxProfile}    set_preference    plugin.scan.plid.all    ${False}
    Call Method    ${firefoxProfile}    set_preference    plugin.scan.Acrobat    99.0
    # Set proxy
    Call Method    ${firefoxProfile}    set_preference    network.proxy.type    ${1}
    Call Method    ${firefoxProfile}    set_preference    network.proxy.http    proxya.ais.co.th
    Call Method    ${firefoxProfile}    set_preference    network.proxy.http_port    ${2520}
    Call Method    ${firefoxProfile}    set_preference    network.proxy.socks    proxya.ais.co.th
    Call Method    ${firefoxProfile}    set_preference    network.proxy.socks_port    ${2520}
    Call Method    ${firefoxProfile}    set_preference    network.proxy.ssl    proxya.ais.co.th
    Call Method    ${firefoxProfile}    set_preference    network.proxy.ssl_port    ${2520}
    Call Method    ${firefoxProfile}    set_preference    network.proxy.ftp    proxya.ais.co.th
    Call Method    ${firefoxProfile}    set_preference    network.proxy.ftp_port    ${2520}
    Comment    Call Method    ${firefoxProfile}    set_preference    browser.link.open_newwindow    ${0}
    Call Method    ${firefoxProfile}    set_preference    network.proxy.no_proxies_on    localhost,test-ebill.ais.co.th,test-procurementws.ais.co.th,test-ehrportal.ais.co.th,test-procurement.ais.co.th,10.137.16.41,stg-ikmengine.intra.ais
    Call Method    ${firefoxProfile}    set_preference    layout.css.devPixelsPerPx    1
    ####
    Create Webdriver    Firefox    firefox_profile=${firefoxProfile}
    Go To    ${URL}
    ${SETWINDOWSITE}    BuiltIn.Get Variable Value    ${SETWINDOWSITE}    FALSE
    ${SETWINDOWSITE}    Convert To Uppercase    ${SETWINDOWSITE}
    BuiltIn.Run Keyword If    '${SETWINDOWSITE}' == 'True'    Set Auto Commit    ${WINDOWWIDTH}    ${WINDOWHEIGHT}
    ...    ELSE    Selenium2Library.Maximize Browser Window

Open Web Browser
    [Arguments]    ${Url}    ${Browser}    # ${browser} Example ff , gc , ie
    [Documentation]    Open browser to URL
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Open Web Browser | ${Url} | ${Browser}
    Run Keyword If    '${Browser}' == 'ff'    Selenium2Library.Open Browser    ${Url}    ${Browser}
    ...    ELSE IF    '${Browser}' == 'ie'    Selenium2Library.Open Browser    ${Url}    ${Browser}
    ...    ELSE IF    '${Browser}' == 'gc'    Selenium2Library.Open Browser    ${Url}    ${Browser}
    ${SETWINDOWSITE}    BuiltIn.Get Variable Value    ${SETWINDOWSITE}    FALSE
    ${SETWINDOWSITE}    Convert To Uppercase    ${SETWINDOWSITE}
    BuiltIn.Run Keyword If    '${SETWINDOWSITE}' == 'TRUE'    Selenium2Library.Set Window Size    ${WINDOWWIDTH}    ${WINDOWHEIGHT}
    ...    ELSE    Selenium2Library.Maximize Browser Window

Select From Web List
    [Arguments]    ${Locator}    ${Text}    ${Timeout}=${General_TimeOut}
    [Documentation]    Select items from dropdownlist identified by locator.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Select From Web List | ${Locator} | ${Text} | ${Timeout}=${General_TimeOut}
    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    Selenium2Library.Select From List    ${Locator}    ${Text}

Select From Web List By Label
    [Arguments]    ${Locator}    ${Label}    ${Timeout}=${General_TimeOut}
    [Documentation]    Select item by using label from dropdownlist identified by locator.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Select From Web List By Label | ${Locator} | ${Label} | ${Timeout}=${General_TimeOut}
    Web Element Should Be Visible    ${Locator}    ${Timeout}
    Wait Until Keyword Succeeds    5    1    Selenium2Library.Select From List By Label    ${Locator}    ${Label}

Select From Web List By Value
    [Arguments]    ${Locator}    ${Value}    ${Timeout}=${General_TimeOut}
    [Documentation]    Select item by using value from dropdownlist identified by locator.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Select From Web List By Value | ${Locator} | ${Value} | ${Timeout}=${General_TimeOut}
    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    Selenium2Library.Select From List By Value    ${Locator}    ${Value}

Verify CheckBox
    [Arguments]    ${Locator}    ${Flag}
    [Documentation]    Verify CheckBox identified by locator is selected or checked.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Verify CheckBox | ${Locator} | ${Flag}
    ...
    ...    ${Flag} = True
    ...    ${Flag} = False
    Comment    ${Flag}    Convert To Uppercase    ${Flag}
    Comment    BuiltIn.Run Keyword If    '${Flag}' != 'TRUE' and '${Flag}' != 'FALSE'    BuiltIn.Fail    Variable flag must be only either True(true) or False(false).
    Comment    BuiltIn.Run Keyword If    '${Flag}' == 'TRUE'    Selenium2Library.Checkbox Should Be Selected    ${Locator}
    ...    ELSE    Checkbox Should Not Be Selected    ${Locator}
    ${Flag}    Convert To Uppercase    ${Flag}
    ${SearchNot}    Evaluate    re.search(r"NOT","${Flag}")    re
    ${Flag}    Remove String    ${Flag}    NOT${Space}
    BuiltIn.Run Keyword If    '${Flag}' != 'TRUE' and '${Flag}' != 'FALSE'    BuiltIn.Fail    Flag is wrong format.
    ${Flag}    Convert To Boolean    ${Flag}
    ${Boolean}    Set Variable If    '${SearchNOT}' != 'None'    not ${Flag}    '${SearchNOT}' == 'None'    ${Flag}
    ${Flag}    Evaluate    bool(${Boolean})
    BuiltIn.Run Keyword If    '${Flag}' == 'True'    Selenium2Library.Checkbox Should Be Selected    ${Locator}
    ...    ELSE    Checkbox Should Not Be Selected    ${Locator}

Verify DropdownList
    [Arguments]    ${Locator}    ${ExpectedAllItem}
    [Documentation]    Verify DropdownList Compare value in Dropdown List of actual with expect
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Verify DropdownList | ${Locator} | ${ExpectedAllItem}
    @{ExpectedListAllItem}    String.Split String    ${ExpectedAllItem}    ,    max_split=-1
    ${LengthExpected}    Get Length    ${ExpectedListAllItem}
    @{AllItem}    Get List Items    ${Locator}
    ${LengthActual}    Get Length    ${AllItem}
    Should Be Equal    ${LengthExpected}    ${LengthActual}    msg=Items in expected have ${LengthExpected} but Actual have ${LengthActual}.
    ${count}    Set Variable    0
    : FOR    ${ListValue}    IN    @{AllItem}
    \    @{ExpectedListAllItem}    String.Split String    ${ExpectedAllItem}    ,
    \    log    ${ListValue}
    \    log    @{ExpectedListAllItem}[${count}]
    \    Should Be Equal As Strings    @{ExpectedListAllItem}[${count}]    ${ListValue}
    \    ${count}    Evaluate    ${count}+1

Verify Enable
    [Arguments]    ${Locator}    ${Flag}
    [Documentation]    Verify element enable identified by locator
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Verify Enable | ${Locator} | ${Flag}
    ...
    ...    ${Flag} = True
    ...    ${Flag} = False
    ${Flag}    Convert To Uppercase    ${Flag}
    BuiltIn.Run Keyword If    '${Flag}' != 'TRUE' and '${Flag}' != 'FALSE'    BuiltIn.Fail    Variable flag must be only either True(true) or False(false).
    BuiltIn.Run Keyword If    '${Flag}' == 'TRUE'    Element Should Be Enabled    ${Locator}
    ...    ELSE    Element Should Be Disabled    ${Locator}

Verify File Name In Directory
    [Arguments]    ${FileName}    ${Path}=${PathDownloadFile}
    [Documentation]    Verify FileName in Directory keyword if get file name from directory compare filename expect
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Verify FileName In Directory | ${FileName} | ${Path}=${PathDownloadFile}
    BuiltIn.Wait Until Keyword Succeeds    5x    1s    OperatingSystem.File Should Exist    ${Path}\\${FileName}
    @{ListFile}    OperatingSystem.List Files In Directory    ${Path}    ${FileName}
    BuiltIn.Should Be Equal    @{ListFile}[0]    ${FileName}
    [Teardown]    # Delete File In Directory    ${FileName}

Verify Length
    [Arguments]    ${Locator}    ${LengthExpect}    ${Timeout}=${General_TimeOut}
    [Documentation]    Verify length by return length value of element and compare value of actual with expect
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Verify length | ${Locator} | ${LengthExpect} | ${Timeout}=${General_TimeOut}
    Comment    ${textActual} =    Selenium2Library.Get Text    ${Locator}
    ${Text}    Get Web Value    ${Locator}
    ${Count}    BuiltIn.Get Length    ${Text}
    ${Count}    BuiltIn.Convert To Integer    ${Count}
    ${lengthExpect}    BuiltIn.Convert To Integer    ${LengthExpect}
    BuiltIn.Should Be Equal    ${lengthExpect}    ${Count}

Verify Placeholder
    [Arguments]    ${Locator}    ${Expect}    ${Timeout}=${General_TimeOut}
    [Documentation]    Get placeholder of element and verify by compare between actual value and expected value.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Verify Placeholder | ${Locator} | ${Expect} | ${Timeout}=${General_TimeOut}
    ${result}    BuiltIn.Run Keyword And Return Status    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    BuiltIn.Run Keyword If    '${result}'=='False'    Wait Web Until Page Contains Element    ${Locator}    ${Timeout}
    ${valueActual}    Selenium2Library.Get Element Attribute    ${Locator}@placeholder
    BuiltIn.Should Be Equal    ${valueActual}    ${Expect}

Verify Radio
    [Arguments]    ${Locator}    ${Flag}
    [Documentation]    Verifies Radio that element identified with `locator` is select or isn't select.
    ...
    ...    *Format keyword*
    ...
    ...    Verify Radio | ${Locator} | ${Flag}
    ...
    ...    *flag* can be as follows:
    ...    - True (means that locator is selected.)
    ...    - False (means that locator is not selected.)
    ...    - Not True (means that locator is not selected.)
    ...    - Not False (means that locator is selected.)
    ${Flag}    Convert To Uppercase    ${Flag}
    ${SearchNot}    Evaluate    re.search(r"NOT","${Flag}")    re
    ${Flag}    Remove String    ${Flag}    NOT${Space}
    BuiltIn.Run Keyword If    '${Flag}' != 'TRUE' and '${Flag}' != 'FALSE'    BuiltIn.Fail    Flag is wrong format.
    ${Flag}    Convert To Boolean    ${Flag}
    ${Boolean}    Set Variable If    '${SearchNOT}' != 'None'    not ${Flag}    '${SearchNOT}' == 'None'    ${Flag}
    ${Flag}    Evaluate    bool(${Boolean})
    BuiltIn.Run Keyword If    '${Flag}' == 'True'    Selenium2Library.Checkbox Should Be Selected    ${Locator}
    ...    ELSE    Checkbox Should Not Be Selected    ${Locator}

Verify Text
    [Arguments]    ${Locator}    ${Text}
    [Documentation]    Keyword will Get Text if text not found will keyword try get value com pare expect
    ...    Because Element have some one text or value
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Verify Text | ${Locator} | ${Text}
    Web Element Should Be Visible    ${Locator}
    ${TextActual}    Selenium2Library.Get Text    ${Locator}
    ${Temp}    Remove String    ${TextActual}    ${SPACE}
    ${Temp}    Get Length    ${Temp}    #count length because if not support special charector
    ${TextActual}    Run Keyword If    '${Temp}' == '0'    Selenium2Library.Get Value    ${Locator}
    ...    ELSE    Set Variable    ${TextActual}
    Should Be Equal    ${TextActual}    ${Text}
    Log    ${TextActual} == ${Text}

Verify Text Is Not Equal
    [Arguments]    ${Locator}    ${Text}
    [Documentation]    Keyword will Get Text if text not found will keyword try get value com pare expect is not equal
    ...    Because Element have some one text or value
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Verify Text Is Not Equal | ${Locator} | ${Text}
    Web Element Should Be Visible    ${Locator}
    ${TextActual}    Selenium2Library.Get Text    ${Locator}
    ${Temp}    Remove String    ${TextActual}    ${SPACE}
    ${Temp}    Get Length    ${Temp}    #count length because if not support special charector
    ${TextActual}    Run Keyword If    '${Temp}' == '0'    Selenium2Library.Get Value    ${Locator}
    ...    ELSE    Set Variable    ${TextActual}
    Should Not Be Equal    ${TextActual}    ${Text}
    Log    ${TextActual} != ${Text}

Verify Visible
    [Arguments]    ${Locator}    ${Flag}
    [Documentation]    Verifies Visible that element identified with `locator` is visible or isn't visible.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Verify Visible | ${Locator} | ${Flag}
    ...
    ...    *flag* can be as follows:
    ...    - True (means that locator is visible.)
    ...    - False (means that locator is not visible.)
    ${Flag}    Convert To Uppercase    ${Flag}
    BuiltIn.Run Keyword If    '${Flag}' != 'TRUE' and '${Flag}' != 'FALSE'    BuiltIn.Fail    Variable flag must be only either True(true) or False(false).
    BuiltIn.Run Keyword If    '${Flag}' == 'TRUE'    Web Element Should Be Visible    ${Locator}
    ...    ELSE    Web Element Should Be Not Visible    ${Locator}
    [Teardown]    Selenium2Library.Capture Page Screenshot

Wait Web Until Page Contains Element
    [Arguments]    ${Locator}    ${Timeout}=${General_TimeOut}
    [Documentation]    Wait until element appears on current page.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Wait Web Until Page Contains Element | ${Locator} | ${Timeout}=${General_TimeOut}
    Selenium2Library.Wait Until Page Contains Element    ${Locator}    ${Timeout}

Web Element Get Matching Xpath Count
    [Arguments]    ${Locator}    ${Timeout}=${General_TimeOut}
    [Documentation]    Returns number of elements matching by xpath
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Web Element Get Matching Xpath Count | ${Locator} | ${Timeout}=${General_TimeOut}
    Web Element Should Be Visible    ${Locator}    ${Timeout}
    ${Count}    Selenium2Library.Get Matching Xpath Count    ${Locator}
    [Return]    ${Count}

Web Element Mouse Over
    [Arguments]    ${Locator}    ${Timeout}=${General_TimeOut}
    [Documentation]    Simulates hovering mouse over to the element
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Web Element Mouse Over | ${Locator} | ${Timeout}=${General_TimeOut}
    ${Result}    BuiltIn.Run Keyword And Return Status    Wait Web Until Page Contains Element    ${Locator}    ${Timeout}
    BuiltIn.Run Keyword If    '${result}'=='False'    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    Web Scroll Element Into View    ${Locator}
    Selenium2Library.Mouse Over    ${Locator}

Web Element Should Be Disabled
    [Arguments]    ${Locator}    ${Timeout}=${General_TimeOut}
    [Documentation]    Verify that element is disabled.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Web Element Should Be Disabled | ${Locator} | ${Timeout}=${General_TimeOut}
    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    Selenium2Library.Element Should Be Disabled    ${Locator}

Web Element Should Be Enabled
    [Arguments]    ${Locator}    ${Timeout}=${General_TimeOut}
    [Documentation]    Verify that element is enabled.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Web Element Should Be Enabled | ${Locator} | ${Timeout}=${General_TimeOut}
    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    Selenium2Library.Element Should Be Enabled    ${Locator}

Web Element Should Be Not Visible
    [Arguments]    ${Locator}    ${Timeout}=${General_TimeOut}
    [Documentation]    Verify that element is not visible.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Web Element Should Be Not Visible | ${Locator} | ${Timeout}=${General_TimeOut}
    ${result}    Run Keyword And Return Status    Element Should Not Be Visible    ${Locator}
    Run Keyword If    ${result} == ${False}    Wait Until Element Is Not Visible    ${Locator}    ${Timeout}

Web Element Should Be Visible
    [Arguments]    ${Locator}    ${Timeout}=${General_TimeOut}
    [Documentation]    Verify that the element is visible.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Web Element Should Be Visible | ${Locator} | ${Timeout}=${General_TimeOut}
    ${result}    Run Keyword And Return Status    Wait Until Page Contains Element    ${Locator}    ${Timeout}
    ${result}    Run Keyword And Return Status    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    Selenium2Library.Element Should Be Visible    ${Locator}

Web Element Text Should Be
    [Arguments]    ${Locator}    ${Text}    ${Timeout}=${General_TimeOut}
    [Documentation]    Verify element exactly contains text is expected.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Web Element Text Should Be | ${Locator} | ${Text} | ${Timeout}=${General_TimeOut}
    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    Selenium2Library.Wait Until Element Contains    ${Locator}    ${Text}    ${Timeout}
    Selenium2Library.Element Text Should Be    ${Locator}    ${Text}
    Capture Page Screenshot

Web Get Elements
    [Arguments]    ${Locator}    ${Timeout}=${General_TimeOut}
    [Documentation]    Return list of web element objects.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Web Get Elements | ${Locator} | ${Timeout}=${General_TimeOut}
    ${result}    BuiltIn.Run Keyword And Return Status    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    BuiltIn.Run Keyword If    '${result}'=='False'    Wait Web Until Page Contains Element    ${Locator}    ${Timeout}
    ${elements}    Selenium2Library.Get Webelements    ${Locator}
    [Return]    ${elements}

Web Scroll Element Into View
    [Arguments]    ${Locator}
    [Documentation]    The Keyword Support Click web Element
    ...
    ...    doing work scroll element if element is missing or hide in the tab
    #calculate element before focus
    ${windowPosition}    Selenium2Library.Execute Javascript    return window.scrollY;
    ${windowWidth}    ${windowHeight}    Get Window Size
    #Calculate Center Height Element
    ${X}    ${Y}    Get Element Size    ${Locator}
    ${HeightCenterElement}    Evaluate    ${Y}/2
    ${heightElement}    Get Vertical Position    ${Locator}
    ${heightElement}    Evaluate    ${heightElement}+${HeightCenterElement}
    #Calculate Current Position Element
    ${CalPosition}    Evaluate    ${heightElement}-${windowPosition}
    Comment    ${tmpCalPosition}    Set Variable    ${CalPosition}
    #Calculate Window Position and delete position Taskbar
    ${CalWindowPosition}    Evaluate    ${windowHeight}-110
    ${StringMatch}    Run Keyword And Return Status    Should Match Regexp    ${Locator}    (i?)(x|X)path(|\s)=
    ${RegexpLocator}    Run Keyword If    ${StringMatch} == ${True}    Remove String Using Regexp    ${Locator}    (i?)(x|X)path(|\s)=
    ...    ELSE    Set Variable    ${Locator}
    comment    ${RegexpLocator}    Remove String Using Regexp    ${Locator}    (i?)xpath=
    #Check focus element
    BuiltIn.Run Keyword If    ${CalPosition} < 140 or ${CalPosition} > ${CalWindowPosition}    Selenium2Library.Execute Javascript    window.document.evaluate("${RegexpLocator}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.scrollIntoView(true);
    #calculate element after focus
    ${windowPosition}    Selenium2Library.Execute Javascript    return window.scrollY;
    ${CalPosition}    Evaluate    ${heightElement}-${windowPosition}
    : FOR    ${i}    IN RANGE    0    99
    \    ${windowPosition}    Selenium2Library.Execute Javascript    return window.scrollY;
    \    ${beforeCalPosition}    Evaluate    ${heightElement}-${windowPosition}
    \    Exit For Loop If    ${beforeCalPosition} > 140
    \    Selenium2Library.Execute Javascript    scrollBy(0,-100);
    \    Comment    ${windowPosition}    Selenium2Library.Execute Javascript    return $(window).scrollTop();
    \    ${windowPosition}    Selenium2Library.Execute Javascript    return window.scrollY;
    \    ${afterCalPosition}    Evaluate    ${heightElement}-${windowPosition}
    \    Exit For Loop If    ${beforeCalPosition} == ${afterCalPosition}

Web Select Checkbox
    [Arguments]    ${Locator}    ${Timeout}=${General_TimeOut}
    [Documentation]    Selects checkbox identified by locator
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Web Select Checkbox | ${Locator} | ${Timeout}=${General_TimeOut}
    : FOR    ${i}    IN RANGE    0    4
    \    ${Status}    Run Keyword And Return Status    Selenium2Library.Select Checkbox    ${Locator}
    \    ${ChkStatus}    Run Keyword And Return Status    Selenium2Library.Checkbox Should Be Selected    ${Locator}
    \    BuiltIn.Run Keyword If    ${ChkStatus} == ${False}    Scroll Element Into View    ${Locator}
    \    Exit For Loop If    ${ChkStatus} == ${True}

Web Unselect CheckBox
    [Arguments]    ${Locator}    ${Timeout}=${General_TimeOut}
    [Documentation]    Removes selection of checkbox identified by locator
    ...
    ...
    ...    *Format keyword*
    ...
    ...    Web Unselect Checkbox | ${Locator} | ${Timeout}=${General_TimeOut}
    : FOR    ${i}    IN RANGE    0    4
    \    ${Status}    Run Keyword And Return Status    Selenium2Library.Unselect Checkbox    ${Locator}
    \    ${ChkStatus}    Run Keyword And Return Status    Selenium2Library.Checkbox Should Not Be Selected    ${Locator}
    \    BuiltIn.Run Keyword If    ${ChkStatus} == ${False}    Web Scroll Element Into View    ${Locator}
    \    Exit For Loop If    ${ChkStatus} == ${True}

Web Input Value Execute Javascript
    [Arguments]    ${Locator}    ${id}    ${value}    ${Timeout}=${General_TimeOut}
    [Documentation]    input value into text field identified by Execute JavaScript.
    ...
    ...
    ...    *Format keyword*
    ...
    ...    ${Locator} | ${id} | ${value} | ${Timeout}=${General_TimeOut}
    ${result}    BuiltIn.Run Keyword And Return Status    Selenium2Library.Wait Until Element Is Visible    ${Locator}    ${Timeout}
    BuiltIn.Run Keyword If    '${result}'=='False'    Wait Web Until Page Contains Element    ${Locator}    ${Timeout}
    Wait Until Keyword Succeeds    5x    1s    Selenium2Library.Execute Javascript    document.getElementById("${id}").value = ${value};

Group List By NameField
    [Arguments]    ${Test_Data}    ${NameField}
    [Documentation]    Group List And Dupicat
    ...
    ...    *Format keyword*
    ...
    ...    ${Test_Data} | ${NameField}
    ${List}    Create List
    : FOR    ${row}    IN    @{Test_Data}
    \    Append To List    ${List}    ${row['${NameField}']}
    ${Group_Duplicates}    Remove Duplicates    ${List}
    [Return]    ${Group_Duplicates}

Refresh
    Execute Javascript    window.location.reload(true);
    Sleep    15s
    Wait Web Until Page Contains Element    //img[@class='logo-ais']
    Capture Page Screenshot

Click Web Element By Javascript
    [Arguments]    ${Locator}
    Wait Until Keyword Succeeds    5x    3s    Selenium2Library.Execute Javascript    ${Locator}
    Wait Until Element Is Not Visible    ${Locator}

Scroll Web To Element
    [Arguments]    ${locator}
    ${status}    BuiltIn.Run Keyword And Return Status    Scroll Element Into View    ${locator}
    ${x}    Get Horizontal Position    ${locator}
    ${y}    Get Vertical Position    ${locator}
    Selenium2Library.Execute Javascript    window.scrollTo(arguments[0], arguments[1]); return arguments[0];    ARGUMENTS    ${x}    ${y}

Verify Combobox
    [Arguments]    ${Locator}    ${ExpectedAllItem}
    @{ExpectedListAllItem}    String.Split String    ${ExpectedAllItem}    ,    max_split=-1
    ${LengthExpected}    Get Length    ${ExpectedListAllItem}
    ####
    ${x}    Selenium2Library.Get Element Count    ${Locator}
    @{List}    Create List
    : FOR    ${i}    IN RANGE    1    ${x} +1
    \    ${value}    Selenium2Library.Get Element Attribute    xpath=(${Locator})[${i}]    title
    \    Log Many    @{List}
    \    Insert Into List    ${List}    ${i}    ${value}
    ${LengthActual}    Get Length    ${List}
    Should Be Equal    ${LengthExpected}    ${LengthActual}    msg=Items in expected have ${LengthExpected} but Actual have ${LengthActual}.
    ${count}    Set Variable    0
    : FOR    ${ListValue}    IN    @{List}
    \    @{ExpectedListAllItem}    String.Split String    ${ExpectedAllItem}    ,
    \    log    ${ListValue}
    \    log    @{ExpectedListAllItem}[${count}]
    \    Should Be Equal As Strings    @{ExpectedListAllItem}[${count}]    ${ListValue}
    \    ${count}    Evaluate    ${count}+1

Upload Using Autoit
    [Arguments]    ${FileName}
    [Documentation]    The Keyword Support *Upload Using Autoit*
    ...
    ...    *Format keyword*
    ...
    ...    | Upload Using Autoit | ${FileName} |
    AutoItLibrary.Control Command    strTitle=    strText=    strControl=ComboBox2    strCommand=SelectString    strExtra=ALL Files
    AutoItLibrary.Win Active    strTitle=File Upload    strText=
    ${PathUploadFile}    Set Variable    ${CURDIR}\\..\\PageFile\\${FileName}
    AutoItLibrary.Control Set Text    strTitle=File Upload    strText=    strControl=Edit1    strControlText=${PathUploadFile}
    : FOR    ${i}    IN RANGE    1    5
    \    ${AcctualPathUpload}    AutoItLibrary.Control Get Text    strTitle=File Upload    strText=    strControl=Edit1
    \    BuiltIn.Exit For Loop If    '${PathUploadFile} == ${AcctualPathUpload}'
    sleep    1
    AutoItLibrary.Control Click    strTitle=File Upload    strText=    strControl=Button1    strButton=LEFT    nNumClicks=1
    AutoItLibrary.Win Wait Close    strTitle=File Upload    strText=

Upload Using Pyautogui
    [Arguments]    ${FileName}
    [Documentation]    The Keyword Support *Upload Using Pyautogui*
    ...
    ...    *Format keyword*
    ...
    ...    | Upload Using Pyautogui| ${FileName} |
    ${FileName}    Set Variable    ${CURDIR}\\..\\PageFile\\${FileName}
    sleep    2s
    pyautogui.Typewrite    ${FileName}
    sleep    1s
    pyautogui.hotkey    enter
    [Teardown]

Upload Using Choose File
    [Arguments]    ${Locator}    ${FileName}    ${Path}=${CURDIR}\\..\\PageFile\\
    Click Web Element    ${Locator}
