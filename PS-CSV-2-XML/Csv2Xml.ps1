# Folder containing source CSV files
$folderPath     = 'C:\Path\To\Source\Folder\Containing\CSV\File'
# Destination folder for the new files
$folderPathDest = 'C:\Path\To\Destination\Folder\For\XML\File'

$xmlTemplate = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<ns1:Items xmlns:ns1="testing" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    @@ITEMNODES@@
</ns1:Items>
"@

# and also a template for the individual <item> nodes
# inside are placeholders '{0}' we will fill in later
$itemTemplate = @"
    <ns1:Item>
		<ns1:Action>{0}</ns1:Action>
		<ns1:Active>{1}</ns1:Active>
		<ns1:Company>{2}</ns1:Company>
		<ns1:Desc>{3}</ns1:Desc>
		<ns1:Item>{4}</ns1:Item>
		<ns1:ItemCategories>
			<ns1:Action>{5}</ns1:Action>
			<ns1:Category1>{6}</ns1:Category1>
			<ns1:Category2>{7}</ns1:Category2>
			<ns1:Category3>{8}</ns1:Category3>
			<ns1:Category4>{9}</ns1:Category4>
			<ns1:Category5>{10}</ns1:Category5>
			<ns1:Category6>{11}</ns1:Category6>
		</ns1:ItemCategories>
		<ns1:InventoryTracking>{12}</ns1:InventoryTracking>
		<ns1:LotControlled>{13}</ns1:LotControlled>
		<ns1:StorageTemplate>
			<ns1:Active>{14}</ns1:Active>
			<ns1:Template>{15}</ns1:Template>
		</ns1:StorageTemplate>
		<ns1:UOMS>
			<ns1:UOM>
			<ns1:Action>{16}</ns1:Action>
			<ns1:ConvQty>{17}</ns1:ConvQty>
			<ns1:DimensionUm>{18}</ns1:DimensionUm>
			<ns1:Height>{19}</ns1:Height>
			<ns1:Length>{20}</ns1:Length>
			<ns1:QtyUm>{21}</ns1:QtyUm>
			<ns1:Sequence>{22}</ns1:Sequence>
			<ns1:TreatAsLoose>{24}</ns1:TreatAsLoose>
			<ns1:Weight>{25}</ns1:Weight>
			<ns1:WeightUm>{26}</ns1:WeightUm>
			<ns1:Width>{27}</ns1:Width>
			</ns1:UOM>
		</ns1:UOMS>
		<ns1:UOMS>
			<ns1:UOM>
			<ns1:Action>{28}</ns1:Action>
			<ns1:ConvQty>{29}</ns1:ConvQty>
			<ns1:DimensionUm>{30}</ns1:DimensionUm>
			<ns1:Height>{31}</ns1:Height>
			<ns1:Length>{32}</ns1:Length>
			<ns1:QtyUm>{33}</ns1:QtyUm>
			<ns1:Sequence>{34}</ns1:Sequence>
			<ns1:TreatAsLoose>{35}</ns1:TreatAsLoose>
			<ns1:Weight>{36}</ns1:Weight>
			<ns1:WeightUm>{37}</ns1:WeightUm>
			<ns1:Width>{38}</ns1:Width>
			</ns1:UOM>
		</ns1:UOMS>
		<ns1:UOMS>
			<ns1:UOM>
			<ns1:Action>{39}</ns1:Action>
			<ns1:ConvQty>{40}</ns1:ConvQty>
			<ns1:DimensionUm>{41}</ns1:DimensionUm>
			<ns1:Height>{42}</ns1:Height>
			<ns1:Length>{43}</ns1:Length>
			<ns1:QtyUm>{44}</ns1:QtyUm>
			<ns1:Sequence>{45}</ns1:Sequence>
			<ns1:TreatAsLoose>{46}</ns1:TreatAsLoose>
			<ns1:Weight>{47}</ns1:Weight>
			<ns1:WeightUm>{48}</ns1:WeightUm>
			<ns1:Width>{49}</ns1:Width>
			</ns1:UOM>
		</ns1:UOMS>
	</ns1:Item>
"@

Get-ChildItem -Path $folderPath -Filter '*.csv' -File | ForEach-Object { 
    # Combines destination path and file name with extension .xml
    $filePathdest = Join-Path -Path $folderPathDest -ChildPath ('{0}.xml' -f $_.BaseName)
    # Import the CSV file
    $rows = Import-Csv -Path $_.FullName -Header COLO0,COLO1,COLO2,COLO3,COLO4,COLO5,COLO6,COLO7,COLO8,COLO9,COL10,COL11,COL12,COL13,COL14,COL15,COL16,COL17,COL18,COL19,COL20,COL21,COL22,COL23,COL24,COL25,COL26,COL27,COL28,COL29,COL30,COL31,COL32,COL33,COL34,COL35,COL36,COL37,COL38,COL39,COL40,COL41,COL42,COL43,COL44,COL45,COL46,COL47,COL48,COL49
    $items = foreach ($item in $rows) {
        # output a <book> section with placeholders filled in
        $itemTemplate -f $item.COL00,$item.COL01,$item.COL02,$item.COL03,$item.COL04,$item.COL05,$item.COL06,$item.COL07,$item.COL08,$item.COL09,$item.COL10,$item.COL11,$item.COL12,$item.COL13,$item.COL14,$item.COL15,$item.COL16,$item.COL17,$item.COL18,$item.COL19,$item.COL20,$item.COL21,$item.COL22,$item.COL23,$item.COL24,$item.COL25,$item.COL26,$item.COL27,$item.COL28,$item.COL29,$item.COL30,$item.COL31,$item.COL32,$item.COL33,$item.COL34,$item.COL35,$item.COL36,$item.COL37,$item.COL38,$item.COL39,$item.COL40,$item.COL41,$item.COL42,$item.COL43,$item.COL44,$item.COL45,$item.COL46,$item.COL47,$item.COL48,$item.COL49
    }
    # create the completed XML and write this to file
    $xmlTemplate -replace '@@ITEMNODES@@', ($items -join [environment]::NewLine) | Set-Content -Path $filePathdest -Encoding utf8
}