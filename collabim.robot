*** Settings ***
Library    BuiltIn     # this will allow us to use keyword "Log", "Evaluate"
Library    Browser     # Fill Text, Click (most basic function needed)
Library    String     

*** Variables ***
${fullname_field}    id=frm-registrationForm-signature
${email_field}    id=frm-registrationForm-email
${password_field}    id=frm-registrationForm-password  
${password_again_field}    id=frm-registrationForm-passwordCheck
${phone_field}    id=frm-registrationForm-phone

*** Test Cases ***
Open Collabim site homepage
    #Open browser and it's site
    New Browser    chromium    headless=false
    New Page    https://www.collabim.cz/
    # on the element below, we narrow down as we encountering strict violation due to playwright, I made smaller search
    # just to look for @class, 'btn --secondary and @href, 'localeCode=cs_CZ
    Wait For Elements State    //header//a[contains(@class, 'btn --secondary') and contains(@href, 'localeCode=cs_CZ')]    visible    10s
    Click    //header//a[contains(@class, 'btn --secondary') and contains(@href, 'localeCode=cs_CZ')]
    
    # -----------------------Placeholder section-----------------------
    # Full Name
    Wait For Elements State    id=frm-registrationForm-signature
    Click    id=frm-registrationForm-signature
    #this will be like majority format of the placeholder and tickbox, If true will proceed to fill the field w/ log other skip with logs 
    ${fill_fullname}=    Evaluate    random.choice([True, False])    random
    IF    ${fill_fullname}
        ${type}=    Evaluate    random.choice(["numbers", "long"])    random
        IF    '${type}' == 'numbers'
            ${fullname}=    Evaluate    str(random.randint(100000, 999999999))    random
        ELSE
            ${fullname}=    Evaluate    ''.join(random.choices(string.ascii_letters, k=100))    random
        END
        Fill Text    ${fullname_field}    ${fullname}
        Log    Filled fullname with: ${fullname}
    ELSE
        Log    Skipping fullname field this time
    END
    # Email
    Wait For Elements State    id=frm-registrationForm-email
    Click    id=frm-registrationForm-email
     ${fill_email}=    Evaluate    random.choice([True, False])    random
    IF    ${fill_email}
        ${type}=    Evaluate    random.choice(["valid", "numbers", "long"])    random
        IF    '${type}' == 'valid'
            ${email}=    Evaluate    f"eadd{random.randint(1,999)}@example.com"    random
        ELSE IF    '${type}' == 'numbers'
            ${email}=    Evaluate    str(random.randint(100000, 999999999))    random
        ELSE
            ${email}=    Evaluate    ''.join(random.choices(string.ascii_letters, k=100))    random
        END
        Fill Text    ${email_field}    ${email}
        Log    Filled email with: ${email}
    ELSE
        Log    Skipping email field this time
    END
    # Password
    Wait For Elements State    id=frm-registrationForm-password
    Click    id=frm-registrationForm-password
     ${fill_password}=    Evaluate    random.choice([True, False])    random
    IF    ${fill_password}
        ${type}=    Evaluate    random.choice(["numbers", "long"])    random
        IF    '${type}' == 'numbers'
            ${password}=    Evaluate    str(random.randint(100000, 999999999))    random
        ELSE
            ${password}=    Evaluate    ''.join(random.choices(string.ascii_letters, k=100))    random
        END
        Fill Text    ${password_field}    ${password}
        Log    Filled password with: ${password}
    ELSE
        Log    Skipping password field this time
    END
    # Password Again
    Wait For Elements State    id=frm-registrationForm-passwordCheck
    Click    id=frm-registrationForm-passwordCheck
    # Password Again
    Wait For Elements State    id=frm-registrationForm-passwordCheck
    Click    id=frm-registrationForm-passwordCheck
    ${fill_password_again}=    Evaluate    random.choice([True, False])    random
    IF    ${fill_password_again} and '${fill_password}' == 'True'
        ${password_again}=    Set Variable    ${password}
        Fill Text    ${password_again_field}    ${password_again}
        Log    Copied password to confirm password: ${password_again}
    ELSE
        Log    Skipped confirm password field or password was not filled
    END
    # Phone
    Wait For Elements State    id=frm-registrationForm-phone
    Click    id=frm-registrationForm-phone
         ${fill_phone}=    Evaluate    random.choice([True, False])    random
    IF    ${fill_phone}
        ${type}=    Evaluate    random.choice(["numbers", "long"])    random
        IF    '${type}' == 'numbers'
            ${phone}=    Evaluate    str(random.randint(100000, 999999999))    random
        ELSE
            ${phone}=    Evaluate    ''.join(random.choices(string.ascii_letters, k=100))    random
        END
        Fill Text    ${phone_field}    ${phone}
        Log    Filled password with: ${phone}
    ELSE
        Log    Skipping phone field this time
    END
    
    # -----------------------Tickbox Section-----------------------
    # Service Condition
    Wait For Elements State    id=frm-registrationForm-approvedTerms
        ${box_service}=    Evaluate    random.choice([True, False])    random
    IF    ${box_service} == 'True'
        Check Checkbox    id=frm-registrationForm-approvedTerms
        Log    The tickbox was ticked for service agreement
    ELSE
        Log    The tickbox was not tick for service agreement
    END
    # Special Promotions and Discounst
    Wait For Elements State    id=frm-registrationForm-otherOffers
        ${box_pad}=    Evaluate    random.choice([True, False])    random
    IF    ${box_pad} == 'True'
        Check Checkbox    id=frm-registrationForm-otherOffers
        Log    The tickbox was ticked for service agreement
    ELSE
        Log    The tickbox was not tick for service agreement
    END
    
    # -----------------------Submit Button-----------------------
    # Submit Button
    Wait For Elements State    id=frm-registrationForm-submit
    Click    id=frm-registrationForm-submit


    #-------------Error assertion and result--------------------------

    #Get how many error able to get
    ${errors}=    Get Elements    css=div.alert.alert-danger
    Should Not Be Empty    ${errors}    No errors found
    # Count error got
    ${error_count}=    Get Length    ${errors}
    Log    Found ${error_count} error/s messages.    console=True 
    # Loop each error to get all the text
    FOR    ${err}    IN    @{errors}
    ${text}=    Get Text    ${err}
    Log To Console    Error message: ${text}
    END
