*** Variables ***
${PopupNewProjectfieldName}    //input[@name='project-name']
${PopupNewProjectfieldDescription}    //input[@name='description']
${PopupNewProjectradioPrivacySettingsPrivate}    (//div[@class='tw-choice__radio-button'])[1]
${PopupNewProjectradioPrivacySettingsPublic}    (//div[@class='tw-choice__radio-button'])[2]
${PopupNewProjectbtnChooseATemplate}    //button[@class='tw-button --size-42px --padding-wide ax-new-project-choose-workflow-button'][@type='button']    # //div[@class='tw-button__main-container']//span[@xpath='3']
