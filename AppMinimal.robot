*** Settings ***
Library    AppiumLibrary
Library    String
Library    DateTime

Suite Setup       Open Minimal Todo App
Suite Teardown    Close Application

*** Variables ***
${REMOTE_URL}         http://127.0.0.1:4723
${PLATFORM_NAME}      Android
${DEVICE_NAME}        Android Emulator
${AUTOMATION_NAME}    UiAutomator2
${APP_PACKAGE}        com.avjindersinghsekhon.minimaltodo
${APP_ACTIVITY}       com.example.avjindersinghsekhon.toodle.MainActivity

# Main Page
${ADD_TODO_BUTTON}    id=com.avjindersinghsekhon.minimaltodo:id/addToDoItemFAB
${TODO_LIST}          id=com.avjindersinghsekhon.minimaltodo:id/toDoRecyclerView

# Add Todo Page
${TODO_INPUT}         id=com.avjindersinghsekhon.minimaltodo:id/userToDoEditText
${SAVE_TODO_BUTTON}   id=com.avjindersinghsekhon.minimaltodo:id/makeToDoFloatingActionButton

# Reminder
${REMIND_SWITCH}      id=com.avjindersinghsekhon.minimaltodo:id/toDoHasDateSwitchCompat
${REMIND_TEXT}        id=com.avjindersinghsekhon.minimaltodo:id/userToDoRemindMeTextView
${REMIND_ICON}        id=com.avjindersinghsekhon.minimaltodo:id/userToDoReminderIconImageButton

# Date / Time Picker
${SELECT_DATE}        id=com.avjindersinghsekhon.minimaltodo:id/newTodoDateEditText
${SELECT_TIME}        id=com.avjindersinghsekhon.minimaltodo:id/newTodoTimeEditText
${SELECT_OK}          id=com.avjindersinghsekhon.minimaltodo:id/ok

# Test Data
${TODO_TEXT}          TTB QA Automate Reminder1
${TODO_TEXT2}         TTB QA Automate Reminder2
${TODO_TEXT3}         TTB QA Automate Reminder3

*** Test Cases ***
TC001 Add Todo With Reminder Date And Time Successfully
    [Documentation]     TC001 Add Todo With Reminder Date And Time Successfully
    Wait Until Page Contains Element    ${ADD_TODO_BUTTON}    20s
    Click Element    ${ADD_TODO_BUTTON}

    Wait Until Page Contains Element    ${TODO_INPUT}    20s
    Input Text    ${TODO_INPUT}    ${TODO_TEXT}

    Open Reminder Date Picker
    Select Reminder Date
    Select Reminder Time

    Wait Until Page Contains Element    ${SAVE_TODO_BUTTON}    20s
    Click Element    ${SAVE_TODO_BUTTON}

    Wait Until Page Contains    ${TODO_TEXT}    20s
    Page Should Contain Text    ${TODO_TEXT}
    Capture Page Screenshot

TC002 Add Todo With Reminder Date Successfully
    [Documentation]     TC002 Add Todo With Reminder Date Successfully
    Wait Until Page Contains Element    ${ADD_TODO_BUTTON}    20s
    Click Element    ${ADD_TODO_BUTTON}

    Wait Until Page Contains Element    ${TODO_INPUT}    20s
    Input Text    ${TODO_INPUT}    ${TODO_TEXT2}

    Open Reminder Date Picker
    Select Reminder Date

    Wait Until Page Contains Element    ${SAVE_TODO_BUTTON}    20s
    Click Element    ${SAVE_TODO_BUTTON}

    Wait Until Page Contains    ${TODO_TEXT2}    20s
    Page Should Contain Text    ${TODO_TEXT2}
    Capture Page Screenshot

TC003 Select Current Day Show Text : The date you entered is in the past
    [Documentation]     TC003 Select Current Day Show Text : The date you entered is in the past
    Wait Until Page Contains Element    ${ADD_TODO_BUTTON}    20s
    Click Element    ${ADD_TODO_BUTTON}

    Wait Until Page Contains Element    ${TODO_INPUT}    20s
    Input Text    ${TODO_INPUT}    ${TODO_TEXT3}

    Open Reminder Date Picker
    Select Current Date

    Sleep    2s
    Page Should Contain Text    The date you entered is in the past.    20s
    Click Element    ${SAVE_TODO_BUTTON}
    Sleep    2s
    Capture Page Screenshot

*** Keywords ***
Open Minimal Todo App
    Open Application    ${REMOTE_URL}
    ...    platformName=${PLATFORM_NAME}
    ...    deviceName=${DEVICE_NAME}
    ...    automationName=${AUTOMATION_NAME}
    ...    appPackage=${APP_PACKAGE}
    ...    appActivity=${APP_ACTIVITY}
    ...    noReset=false

Open Reminder Date Picker
    Wait Until Page Contains Element    ${REMIND_SWITCH}    20s
    Click Element    ${REMIND_SWITCH}
    Sleep    1s
    Capture Page Screenshot

Select Reminder Date
    Click Element    ${SELECT_DATE}
    # หา date ที่ selected อยู่ เช่น content-desc="17 May 2026 selected"
    ${selected_date_locator}=    Set Variable    xpath=//android.view.View[contains(@content-desc, "selected")]

    Wait Until Page Contains Element    ${selected_date_locator}    20s

    ${selected_desc}=    Get Element Attribute    ${selected_date_locator}    content-desc
    Log    Selected date from picker: ${selected_desc}

    # ตัดคำว่า selected ออก
    ${current_date}=    Replace String    ${selected_desc}    selected    ${EMPTY}
    ${current_date}=    Strip String    ${current_date}
    Log    Current date: ${current_date}

    # บวกไป 1 วัน
    ${next_date}=    Add Time To Date
    ...    ${current_date}
    ...    1 day
    ...    date_format=%d %B %Y
    ...    result_format=%d %B %Y

    Log    Next date: ${next_date}

    # Click วันที่ใหม่ เช่น content-desc="18 May 2026"
    ${next_date_locator}=    Set Variable    xpath=//android.view.View[@content-desc="${next_date}"]

    Wait Until Page Contains Element    ${next_date_locator}    20s
    Click Element    ${next_date_locator}
    Click Element    ${SELECT_OK}

Select Current Date
    Click Element    ${SELECT_DATE}
    Click Element    ${SELECT_OK} 

Select Reminder Time
    Click Element    ${SELECT_TIME}
    Click Element    ${SELECT_OK} 
    Sleep    1s
