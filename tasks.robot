*** Settings ***
Resource          rpachallenge.resource

*** Tasks ***
Start the challenge
    Open Available Browser    http://rpachallenge.com/
    Download    http://rpachallenge.com/assets/downloadFiles/challenge.xlsx    overwrite=True
    Click Button    Start

Fill the forms
    ${people}=    Get the list of people from the Excel file
    FOR    ${person}    IN    @{people}
        Fill and submit the form    ${person}
    END

Collect the results
    Capture Element Screenshot    css:div.congratulations
    Close All Browsers

Complete the Challenge
    Open Available Browser    http://rpachallenge.com/
    Download    http://rpachallenge.com/assets/downloadFiles/challenge.xlsx    overwrite=True
    Click Button    Start
    ${people}=    Get the list of people from the Excel file
    FOR    ${person}    IN    @{people}
        Fill and submit the form    ${person}
    END
    Capture Element Screenshot    css:div.congratulations
    Close All Browsers
