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

Open Web Browser
    [Arguments]    ${Url}    ${Browser}=gc    # ${browser} Example ff , gc , ie
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
