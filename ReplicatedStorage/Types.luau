--!nonstrict

--[[
     █████  ██      ██     ██ ██  ██████  ███    ██ 
    ██   ██ ██      ██     ██ ██ ██    ██ ████   ██ 
    ███████ ██      ██  █  ██ ██ ██    ██ ██ ██  ██ 
    ██   ██ ██      ██ ███ ██ ██ ██    ██ ██  ██ ██ 
    ██   ██ ███████  ███ ███  ██  ██████  ██   ████ 

                    ALWION STUDIOS  
                  ALL RIGHTS RESERVED
                        ©️ 2024
]]

-- Types
export type dropDownOption = {
    name: string,
    description: string,
    callback: () -> (),
}

export type Window = {
    title: string,
    UI: Frame,
}

export type DropDown = {
    TriggerInstance: Instance,
    UI: Frame,
}

export type UICreationOptions = {
    title: string
}

return nil