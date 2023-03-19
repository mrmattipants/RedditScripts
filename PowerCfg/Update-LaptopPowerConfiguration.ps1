$ActiveScheme = (powercfg.exe /getactivescheme)
$ActiveSchemeGUID = $ActiveScheme.split(" ")
$ActiveSchemeGUID = $ActiveSchemeGUID[3]

$PowerSaver = (powercfg.exe /List | FIND "Power saver")
$PowerSaverGUID = $PowerSaver.split(" ")
$PowerSaverGUID = $PowerSaverGUID[3]

$HighPerformance = (powercfg.exe /List | FIND "High performance")
$HighPerformanceGUID = $HighPerformance.split(" ")
$HighPerformanceGUID = $HighPerformanceGUID[3]

$BatteryStatus = (Get-CimInstance Win32_Battery).BatteryStatus

If ($BatteryStatus -eq 1) {
    If ($ActiveSchemeGUID -ne $PowerSaverGUID) {
        powercfg.exe /setactive "$($PowerSaverGUID)"
    }
} Else {
    If ($ActiveSchemeGUID -ne $HighPerformanceGUID) {
        powercfg.exe /setactive "$($HighPerformanceGUID)"
    }
}
