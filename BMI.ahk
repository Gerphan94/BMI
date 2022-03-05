;BMI
#NoEnv
#NoTrayIcon

Gui, Font, S20 Bold
Gui, Add, Text, x20 y20 cNavy, % "BMI"
Gui, Add, Text, x90 y20 w100 vrBMI, 0
Gui, Font
Gui, Font, s12 Normal
Gui, Add, Text, x20 y70 h28 +0x200, % "Chiều cao (cm):"
Gui, Add, Edit, x140 y70 w70 +right vheight HWNDhEdit1 gRun,
Gui, Add, Text,x20 y110 h28 +0x200, % "Cân nặng (kg):"
Gui, Add, Edit, x140 y110 w70 +right vweight HWNDhEdit2 gRun,
Gui, Add, StatusBar
OnMessage(0x102,"WM_Char")
Gui, Show, w300, % "BMI"
Return

GuiClose:
GuiEscape:
    ExitApp

Run:
    Gui, Submit, Nohide
    If (height = "") OR (weight = "")
        Return
    resutl := (weight*10000)/(height*height)
    resutl2 := Format("{:.2f}", resutl)
    GuiControl, , rBMI, %resutl2%
    If (resutl < 18.5)
        Gui, Font, s20 c1E90FF
    Else If (resutl < 24.9)
        Gui, Font, s20 c008000
    Else If (resutl < 29.9)
        Gui, Font, s20 cFFA500
    Else If (resutl < 34.9)
        Gui, Font, s20 cFF0000
    Else
        Gui, Font, s20 c800080
    GuiControl, Font, rBMI
    Return

WM_Char(wP) 
{
    Gui, Submit, NoHide
    global weight, height, hEdit1, hEdit2
    GuiControlGet, fCtrl, Focus
    GuiControlGet, hCtrl, HWND, %fCtrl%
    
     ;Luôn luôn cho nhập Backspace
    If (wP = 8)
        Return
    wP := Chr(wP)

    ;Xử lý khi nhập ô Chiều cao (chỉ cho phép nhập sô nguyên)
    If ( hCtrl = hEdit1)
    {
        If (StrLen(height) = 0) AND (wP = 0)
            Return, 0
        If wP is not digit
            Return, 0
        If (StrLen(height) > 2)
            Return, 0
        Return
    }
    ;Xử lý khi nhập ô Cân nặng (Cân nặng cho phép nhập thập phân - 2 số thập phân)
    Else if (hCtrl = hEdit2)
    {
        ; CHặn không cho nhập 0 và dấu "." đầu dòng
        If (StrLen(weight) = 0)
            If (wP = "0") OR (wP = ".")
                Return, 0
        ;Nếu ô đang nhập chưa có dấu .
        If (!InStr(weight, ".")) {
            If wP is not digit ;Kiểm tra nếu wP không phải là số
            {
                If (wP = ".")
                    Return
                Return, 0
            }
            Else {
                If (strLen(weight) >2)
                    Return, 0
            }
        }
        Else {
            If wP is not digit
                Return, 0
            Loop, Parse, weight, `.
            {
                If (A_index = 2) AND (StrLen(A_LoopField) >1)
                    Return, 0
            }
        }
    }
}
