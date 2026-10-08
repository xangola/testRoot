*** Settings ***
Documentation    Robot Framework automation challenge: upload, download file and compare JSON.
Resource         ../resources/common.resource
Library          JSONLibrary
Suite Setup      Create Directory    ${DOWNLOAD_DIR}
Suite Teardown   Close Browser Safely

*** Variables ***
${CSV_FILE}       ${EXECDIR}${/}test_data${/}upload_data.csv
${JSON1_FILE}     ${EXECDIR}${/}test_data${/}json1.json
${JSON2_FILE}     ${EXECDIR}${/}test_data${/}json2.json

*** Test Cases ***
Upload a CSV file and validate
    [Documentation]    Uploads a CSV file and validates the success message and filename.
    [Setup]   Open Browser For Upload
    Choose File    id=file-upload    ${CSV_FILE}
    Click Button    id=file-submit
    Wait Until Element Is Visible    xpath=//*[contains(text(), "File Uploaded!")]    timeout=${TIMEOUT}    
    Page Should Contain    upload_data.csv
    [Teardown]    Close Browser Safely

Download a file and validate
    [Documentation]    Downloads the first available file and verifies that it exists and is not empty.
    [Setup]    Open Browser For Download
    # Wait for download link to appear
    Wait Until Element Is Visible    css=a[href*="download/"]    timeout=${TIMEOUT}
    Sleep    10s
    ${links}=    Get WebElements    css=a[href*="download/"]
    ${link_count}=    Get Length    ${links}
    Should Be True    ${link_count} > 0    No downloadable files were found on the page.
    ${download_link}=    Get From List    ${links}    0
    ${filename}=    Get Text    ${download_link}
    Should Not Be Empty    ${filename}
    Click Element    ${download_link}
    Wait Until File Is Downloaded    ${filename}
    File Should Exist    ${DOWNLOAD_DIR}${/}${filename}
    ${file_size}=    Get File Size    ${DOWNLOAD_DIR}${/}${filename}
    Should Be True    ${file_size} > 0    Downloaded file is empty: ${filename}   
    [Teardown]    Run Keywords    Close Browser Safely    AND    Remove downloaded file   ${DOWNLOAD_DIR}${/}${filename}

Compare two JSON
    [Documentation]    Loads two JSON files and performs a full key/value comparison.
    ${json1}=    Load Json From File    ${JSON1_FILE}
    ${json2}=    Load Json From File    ${JSON2_FILE}

    Should Be Equal    ${json1}    ${json2}
