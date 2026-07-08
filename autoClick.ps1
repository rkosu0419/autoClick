#***********************************************#
# yyyy/mm/dd                                    #
#                                               #
# 自動クリックツール                            #
# XXXXXXXXXXXXXXXXXXXXXXXXXX                    #
#***********************************************#

# .NET Frameworkの宣言
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

# Windows APIの宣言
$signature=@'
[DllImport("user32.dll",CharSet=CharSet.Auto,CallingConvention=CallingConvention.StdCall)]
public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru

# 移動とクリックを繰り返す
# coordinate.txt(座標)を読込み、各計量機の座標を設定する
$num = Get-Content .\coordinate.txt -Encoding UTF8

# coordinate.txt(座標)の行数÷2で計量器数を取得
$rMachineNum = $num.Count / 2

# 待機時間
$wait = 2000

# 座標設定の有無を確認
if($num.Length -eq 0){
    # 各計量機の座標設定がされていない場合、警告する
    [System.Windows.Forms.MessageBox]::Show("計量機の座標設定をしてください。", "警告！")
    exit

}else{

    # 各計量機のx座標取得
    # x番号
    $count = 1;
    for($i=0; $i -lt $num.Count; $i = $i + 2){
    # xで始まる連番の変数を作成する
    Set-Variable -Name ("x" + $count) -Value ($num[$i])
    $count++
    }
    
    # 各計量機のy座標取得
    # y番号
    $count = 1;
    for($i=1; $i -lt $num.Count; $i = $i + 2){
    # yで始まる連番の変数を作成する
    Set-Variable -Name ("y" + $count) -Value ($num[$i])
    $count++
    }
}
#--------------------------------------------
# 計量機No.NN 座標：$xi、$yi
#--------------------------------------------

# 各計量機の座標に「移動」→「クリック」を
# 「■」ボタンがクリックされるまで繰り返す

while($True){
        # 計量器数分の移動とクリックを繰り返す
        for($i=1; $i -le $rMachineNum; $i++){
            # x座標
            $xi = Get-Variable -Name "x$i" -ValueOnly
            # y座標
            $yi = Get-Variable -Name "y$i" -ValueOnly
            # 移動
            [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($xi, $yi)
            Start-Sleep -Milliseconds $wait
            
            # クリック
            #$SendMouseClick::mouse_event(0x0002, 0, 0, 0, 0);
            #$SendMouseClick::mouse_event(0x0004, 0, 0, 0, 0);
            Start-Sleep -Milliseconds $wait
        }
}
