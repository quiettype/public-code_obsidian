#Requires AutoHotkey v2.0
#SingleInstance

; === Open Selected Text as URI ===
; Handles selected Obsidian URLs (obsidian://open|search|graph|daily) 
; and opens them in Obsidian. Only allows read-only actions.
; Usage: Select an Obsidian URI and press Ctrl+Alt+O
^!o:: {
    ClipSaved := ClipboardAll()  ; Save current clipboard
    try {
        A_Clipboard := ""           ; Clear the clipboard
        Send("^c")                  ; Copy selected text
        
        ; More robust clipboard wait
        startTime := A_TickCount
        while (A_Clipboard = "" && A_TickCount - startTime < 1000)
            Sleep(50)
            
        if (A_Clipboard = "") {
            ToolTip("Failed to copy text - nothing selected or copy timed out")
            SetTimer(ToolTip, -2000)
            return
        }
        
        ; Strict validation for read-only Obsidian URIs
        if RegExMatch(Trim(A_Clipboard), "^obsidian://(open|search|graph|daily)(?:\?|$)", &match) {
            ToolTip("Opening Obsidian link...")
            Run(A_Clipboard)
            Sleep(500)
            SetTimer(ToolTip, -1000)
        } else {
            ToolTip("Invalid Obsidian URI: Must start with 'obsidian://' and use a read-only action`nGot: '" . A_Clipboard . "'")
            SetTimer(ToolTip, -3000)
        }
    } finally {
        A_Clipboard := ClipSaved    ; Restore original clipboard
    }
}
