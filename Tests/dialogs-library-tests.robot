*** Settings ***
Documentation    test suite whose test cases utilizing the dialogs library keywords
Library          Dialogs
Library          SeleniumLibrary
Test Setup       No Operation
Test Teardown    Close All Browsers

# To Run:
# robot  --pythonpath Resources --noncritical failure-expected -d Results/ -v browser:'firefox' Tests/dialogs-library-tests.robot

*** Keywords ***
Open Browser Instance If None Or Open A Window In Existing Browser
    @{browser_ids} =     Get Browser Ids
    ${number_of_browsers} =     Get Length      ${browser_ids}
    # if/else structure
    Run Keyword If      $number_of_browsers==0      Open Browser    browser=chrome              # open a browser if none exists
    Run Keyword Unless  $number_of_browsers==0      Execute Javascript      window.open()       # open a new window in the existing browser

Switch To The Latest Window
    @{window_handles} =     Get Window Handles      browser=CURRENT
    ${number_of_window_handles} =     Get Length      ${window_handles}
    # if/else structure
    Run Keyword If      $number_of_window_handles==1          Switch Window       locator=CURRENT   # current window handle
    Run Keyword If      $number_of_window_handles>1           Switch Window       locator=NEW       # the latest opened window is selected

*** Variables ***
@{URLs} =       http://robotframework.org/      http://www.pyregex.com/     http://github.com/      https://www.amazon.com/

*** Test Cases ***
Use "Execute Manual Step"
    Execute Manual Step     message=Pass or Fail this step?     default_error=Default error message (can be overridden)
    Log     This log will print only if Execute Manual Step keyword passes

Use "Get Selection From User"
    ${selected_browser} =       Get Selection From User      Which browser?      chrome      firefox
    ${selected_url} =   Get Selection From User     Which url?      @{URLs}
    Open Browser  url=${selected_url}          browser=${selected_browser}
    Sleep   3s

Use "Get Selections From User"
    @{selected_urls} =   Get Selections From User     Which urls?      @{URLs}
    FOR     ${url}  IN    @{selected_urls}
        Open Browser Instance If None Or Open A Window In Existing Browser
        Switch To The Latest Window
        Go To    ${url}     # uses the latest window
    END

Use "Get Value From User"
    ${value} =      Get Value From User     Enter a string      default_value=Hakan
    Log     ${value}

