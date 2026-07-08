#***********************************************#
# yyyy/mm/dd                                    #
#                                               #
# 座標取得ツール                                #
# XXXXXXXXXXXXXXXXXXXXXXXXXX                    #
#***********************************************#

# アセンブリのロード
Add-Type -AssemblyName System.Windows.Forms

# .NET Frameworkの宣言
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

# Windows APIの宣言
$signature=@'
[DllImport("user32.dll",CharSet=CharSet.Auto,CallingConvention=CallingConvention.StdCall)]
public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
 
#************************************************
# オブジェクト
#************************************************

# フォームの作成・ボタンの作成
$form = New-Object System.Windows.Forms.Form
$form.Size = "230,230"
$form.StartPosition = "CenterScreen"
$form.Opacity = 0.4 # 半透明

$Button = New-Object System.Windows.Forms.Button
$Button.Location = "85,70"
$Button.Size = "13,13"
$Button.BackColor = "red"

#************************************************
# マウスクリックによる座標取得
#************************************************

# coordinate.txtを初期化
Clear-Content .\coordinate.txt

# 各計量機の座標をクリックし取得する
$click = {
    $x = [System.Windows.Forms.Cursor]::Position.X # マウスのX座標
    $y = [System.Windows.Forms.Cursor]::Position.Y # マウスのY座標

    # x座標、y座標をcoordinate.txtへ追記
    $x | Out-File -FilePath .\coordinate.txt -Append -Encoding UTF8
    $y | Out-File -FilePath .\coordinate.txt -Append -Encoding UTF8
    }

 $Button.Add_Click($click)
#************************************************
# オブジェクトの設置
#************************************************

$form.Controls.Add($Button)
$Form.Showdialog()

