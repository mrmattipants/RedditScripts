$Print3d = (winget list --query "Print3D" | findstr "Print3D")

If ($Print3d) {

    $P3dInfo = $Print3d.split(" ")
    $P3dName = $P3dInfo[0]
    $P3dId = $P3dInfo[1]
    $P3dVersion = $P3dInfo[2]

    winget uninstall --name $P3dName --id $P3dId --version $P3dVersion

}
