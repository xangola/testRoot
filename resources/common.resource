*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections

*** Variables ***
${BASE_URL}             https://the-internet.herokuapp.com
${UPLOAD_URL}           ${BASE_URL}/upload
${DOWNLOAD_URL}         ${BASE_URL}/download
${DOWNLOAD_DIR}         ${EXECDIR}${/}downloads
${TIMEOUT}       60s

*** Keywords ***
Open Browser For Upload
    [Documentation]    Opens Chrome for the upload test.
    Open Browser    ${UPLOAD_URL}    Chrome
    Set Selenium Timeout    ${TIMEOUT}
    Maximize Browser Window

*** Keywords ***
Open Browser For Download
    [Documentation]    Opens Chrome with automatic downloads enabled.
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${prefs}=    Create Dictionary    download.default_directory=C:\\testRoot\\downloads    download.prompt_for_download=${FALSE}    download.directory_upgrade=${TRUE}    safebrowsing.enabled=${FALSE}
    Call Method    ${options}    add_experimental_option    prefs    ${prefs}
    ${arg}=    Set Variable    --disable-features=InsecureDownloadWarnings
    Call Method    ${options}    add_argument    ${arg}
    Create Webdriver    Chrome    options=${options}
    ${lib}=    Get Library Instance    SeleniumLibrary
    ${driver}=    Set Variable    ${lib.driver}
    ${params}=    Create Dictionary    behavior=allow    downloadPath=C:\\testRoot\\downloads
    Call Method    ${driver}    execute_cdp_cmd    Page.setDownloadBehavior    ${params}
    Go To    ${DOWNLOAD_URL}
    Set Selenium Timeout    ${TIMEOUT}
    Maximize Browser Window    

Wait Until File Is Downloaded
    [Arguments]    ${filename}    ${timeout}=15s
    Wait Until Keyword Succeeds    ${timeout}    500ms    File Should Exist    ${DOWNLOAD_DIR}${/}${filename}

Close Browser Safely
    [Documentation]    Closes the current browser.
    Close All Browsers

Remove downloaded file 
     [Arguments]     ${fileToRemove}
     File Should Exist    ${fileToRemove}
     Remove File    ${fileToRemove}
