*** Settings ***
Resource          ../Resources/Keyword/Taskworld_Keywords.robot

*** Test Cases ***
QAFlow
    Open Web Browser    https://enterprise.taskworld.com/login
    Login    ${Username}    ${Password}    # User login into system
    Click Web Element    ${HomebtnNewProject}
    Input New Project    fieldName=Sample Project    fieldDescription=This project is created for testing purpose.    radioPrivacySettingsPublic=true    #Create Project
    Choose Template    Blank    #Create Project
    Input Tasklist Title    Sample tasklist    #creates a tasklist
    Input New Task    This is a task    # creates a task
    Select Task    This is a task
    Close Task
    Complete Task    This is a task    #user complete the task
    Select Task    This is a task    #open the completed task to see detail of the task
    Close Task
