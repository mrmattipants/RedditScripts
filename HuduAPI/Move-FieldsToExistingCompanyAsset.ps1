# See Usage Examples at https://github.com/lwhitelock/HuduAPI#Usage

# Import HuduApi Module
Import-Module HuduApi

# Set Hudu Base URL
New-HuduBaseURL -BaseURL https://subdomain.huducloud.com/

# Set Hudu API Key
New-HuduAPIKey -ApiKey sQfYjDqQC2YTHUsopRGPwx34

# Set Company A & B Names
$CompanyNameA = "Company A"
$CompanyNameB = "Company B"

# Get Company A & B Id Numbers
$CompanyIdA = (Get-HuduCompanies -name $CompanyNameA).id
$CompanyIdB = (Get-HuduCompanies -name $CompanyNameB).id

# Get All Assets from Company A & B by Asset Type
$ApsCompanyA = Get-HuduAssets -CompanyId $CompanyIdA | Where-Object {$_.asset_type -eq "Wireless aps"}
$ApsCompanyB = Get-HuduAssets -CompanyId $CompanyIdB | Where-Object {$_.asset_type -eq "Wireless aps"}

# Get Company A & B Assets by Asset Name
$ApCompanyA = $ApsCompanyA | Where-Object {$_.name -eq "COA-AP-01"}
$ApCompanyB = $ApsCompanyB | Where-Object {$_.name -eq "COB-AP-01"}

# Get Asset Field Data
$SiteField = $ApCompanyA.fields | where-object {$_.label -eq "Site"}
$ModelField = $ApCompanyA.fields | where-object {$_.label -eq "Model"}
$DeviceIpField = $ApCompanyA.fields | where-object {$_.label -eq "Device IP"}
$ManagementField = $ApCompanyA.fields | where-object {$_.label -eq "Management IP Address/URL"}
$ManufacturerField = $ApCompanyA.fields | where-object {$_.label -eq "Manufacturer"}
$SerialNumberField = $ApCompanyA.fields | where-object {$_.label -eq "Serial Number"}
$MacAddressField = $ApCompanyA.fields | where-object {$_.label -eq "MAC Address"}
$DescriptionField = $ApCompanyA.fields | where-object {$_.label -eq "Description/Notes"}

# Format Asset Field Data as JSON
$ApFields = @(
    @{
          "$($SiteField.label)" = "$($SiteField.value)"
          "$($ModelField.label)" = "$($ModelField.value)"
          "$($DeviceIpField.label)" = "$($DeviceIpField.value)"
          "$($ManagementField.label)" = "$($ManagementField.value)"
          "$($ManufacturerField.label)" = "$($ManufacturerField.value)"
          "$($SerialNumberField.label)" = "$($SerialNumberField.value)"
          "$($MacAddressField.label)" = "$($MacAddressField.value)"
          "$($DescriptionField.label)" = "$($DescriptionField.value)"
    }
)

# Update Existing Company B Asset with Company A Asset Data
Set-HuduAsset -name $ApCompanyB.name -company_id $CompanyIdB -asset_layout_id $ApCompanyB.asset_layout_id -fields $ApFields -asset_id $ApCompanyB.id

# Delete Company A Asset
Remove-HuduAsset -Id $ApCompanyA.id -company_id $CompanyIdA