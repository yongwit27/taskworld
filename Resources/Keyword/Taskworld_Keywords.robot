*** Settings ***
Resource          Redefine_Keywords.robot
Resource          ../Variables/Variables.robot
Resource          ../Repository/MasterRepository.robot

*** Keywords ***
Login
    [Arguments]    ${Username}    ${Password}
    Input Web Text    ${LoginfieldEmail}    ${Username}
    Input Web Text    ${LoginfieldPassword}    ${Password}
    Click Web Element    ${LoginbtnSubmit}

Input New Project
    [Arguments]    @{Parameters}
    Comment    Click Web Element    ${HomebtnNewProject}
    : FOR    ${inList}    IN    @{Parameters}
    \    ${field}    ${Text}    Split String    ${inList}    =
    \    ${Field}    ${Index}    Common Split Field And Index    ${field}
    \    Comment    BuiltIn.Exit For Loop If    ('${Field}' != 'FIELDNAME' or '${Field}' != 'FIELDDESCRIPTION')
    \    ${Locator}    BuiltIn.Set Variable    ${PopupNewProject${Field}}
    \    ${Xpath}    Run Keyword If    '${Index}' != 'None'    Get Locator From Position    ${Locator}    ${Index}
    \    ...    ELSE    Set Variable    ${Locator}
    \    Common Input Web Element    ${Field}    ${Xpath}    ${Text}
    Click Web Element    ${PopupNewProjectbtnChooseATemplate}

Choose Template
    [Arguments]    ${Template}
    ${Field}    ${Index}    Common Split Field And Index    ${Template}
    ${Locator}    BuiltIn.Set Variable    ${PopupProjectTemplatebtnTemplate${Template}}
    ${Xpath}    Run Keyword If    '${Index}' != 'None'    Get Locator From Position    ${Locator}    ${Index}
    ...    ELSE    Set Variable    ${Locator}
    Click Web Element    ${Xpath}
    Click Web Element    ${PopupProjectTemplatebtnCreateProject}

Input Tasklist Title
    [Arguments]    ${inputTitle}
    ${Locator}    BuiltIn.Set Variable    ${TaskfieldTaskListTitle}
    Input Web Text    ${Locator}    ${inputTitle}
    Press Keys    ${Locator}    RETURN

Input New Task
    [Arguments]    ${Task}
    Click Web Element    //div[@class='tw-kanban-columns']
    Click Web Element    ${TaskbtnAddTask}
    ${Locator}    BuiltIn.Set Variable    ${TaskfieldCreateNewTask}
    Input Web Text    ${Locator}    ${Task}
    Click Web Element    ${TaskbtnCreate}

Select Task
    [Arguments]    ${Task}
    ${locator}    BuiltIn.Set Variable    //section[@data-task-title='${Task}']
    Click Web Element    ${locator}

Close Task
    Click Web Element    (//i[@class='tw-icon tw-icon-close --name_close'])[1]

Complete Task
    [Arguments]    ${Task}
    ${locator}    BuiltIn.Set Variable    //section[@data-task-title='${Task}']//..//div[@role='button']
    Click Web Element    ${locator}
