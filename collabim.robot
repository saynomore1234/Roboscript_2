*** Settings ***
Library    BuiltIn     # this will allow us to use keyword "Log", "Evaluate"
Library    Browser     # Fill Text, Click (most basic function needed)
Library    String     

*** Variables ***
${fullname_field}    id=frm-registrationForm-signature
${email_field}    id=frm-registrationForm-signature
${password_field}    id=frm-registrationForm-signature   
${password_again_field}    id=frm-registrationForm-signature   #this will be a true or false if to get the same password from the password_field or do random input that won't match
${phone_field}    id=frm-registrationForm-signature       

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
        ${type}=    Evaluate    random.choice(["valid", "numbers", "long"])    random
    # there will be like set of choices if set to true, this part "valid=format email address", "numbers= only numbers", last choice set of full strings. 
        IF    '${type}' == 'valid'
            ${fullname}=    Evaluate    f"eadd{random.randint(1,999)}@example.com"    random
        ELSE IF    '${type}' == 'numbers'
            ${fullname}=    Evaluate    str(random.randint(100000, 999999999))    random
        ELSE
            ${fullname}=    Evaluate    ''.join(random.choices(string.ascii_letters, k=100))    random
        END
        Fill Text    ${fullname_field}    ${fullname}
        Log    Filled fullname with: ${fullname}
    ELSE
        Log    Skipping fullname field this time
    Sleep    5s
    END
    # Email
    Wait For Elements State    id=frm-registrationForm-email
    Click    id=frm-registrationForm-email
    # Password
    Wait For Elements State    id=frm-registrationForm-password
    Click    id=frm-registrationForm-password
    # Password Again
    Wait For Elements State    id=frm-registrationForm-passwordCheck
    Click    id=frm-registrationForm-passwordCheck
    # Phone
    Wait For Elements State    id=frm-registrationForm-phone
    Click    id=frm-registrationForm-phone
    
    # -----------------------Tickbox Section-----------------------
    # Service Condition
    Wait For Elements State    id=frm-registrationForm-approvedTerms
    Click    id=frm-registrationForm-approvedTerms
    # Special Promotions and Discounst
    Wait For Elements State    id=frm-registrationForm-otherOffers
    Click    id=frm-registrationForm-otherOffers
    

    # -----------------------Submit Button-----------------------
    # Submit Button
    Wait For Elements State    id=frm-registrationForm-submit
    Click    id=frm-registrationForm-submit


    #-------------Error assertion--------------------------

    #Get how many error able to get
    # ${errors}=    Get Elements    css=alert.alert-danger
    # Should Not Be Empty    ${errors}    No errors found
    # Count error got
    # ${error_count}=    Get Length    ${errors}
    # Log    Found $(error_count) error/s messages.    consolte=True 
    # Loop each error to get all the text
    # For ${err}    IN    @{errors}
    #     ${text}=     Get Text    ${err}
    #     Log    Error message: ${text}    console=True  
