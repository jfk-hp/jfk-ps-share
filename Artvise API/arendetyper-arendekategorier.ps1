# --------------------------------------------------------------------------------------------
# diaryplanitem & casecategory
# --------------------------------------------------------------------------------------------

## input

# prep

$serviceUri	= ''	# artvise .svc uri, f.x. https://artvise.kommun.se/MercuryAPI/service.svc
$apikey		= ''	# artvise service account api key, artvise admin -> specific user -> integrationer (button)

# request when running

$inboxguid = Read-Host Inbox GUID

## var null or whitespace check

if([string]::IsNullOrWhiteSpace($serviceUri) -or [string]::IsNullOrWhiteSpace($apikey) -or [string]::IsNullOrWhiteSpace($inboxguid)){

	Write-Warning -Message 'All required input variables not supplied, aborting...'
	
	break

}

## get content

$invokeUri = -join ($serviceUri, '/xml/GetCaseTypes?inboxGuid=', $inboxguid, '&apiKey=', $apikey)

try{

	$invoke = Invoke-WebRequest -Uri $invokeUri
	
}
catch{

	$_
	
	break

}

$content = [xml]$invoke.Content

## generate list

$genericList = New-Object System.Collections.Generic.List[pscustomobject]

$itemDtoArray = $content.ArrayOfDiaryPlanItemDto.DiaryPlanItemDto

foreach($itemDto in $itemDtoArray){
	
	$categoryDtoArray = $itemDto.CaseCategories.CaseCategoryDto
	
    foreach($categoryDto in $categoryDtoArray){
		
		$genericList.Add(
		
			[pscustomobject]@{
			
				'Ärendetyp'				= $itemDto.Fullname
				'Ärendetyp GUID'		= $itemDto.DiaryPlanItemGuid
				'Ärendekategori'		= $categoryDto.Name
				'Ärendekategori GUID'	= $categoryDto.CaseCategoryGuid
			
			}
		
		)
		
    }
	
}

## export

Add-Type -AssemblyName System.Windows.Forms

$openFileDialog						= New-Object System.Windows.Forms.SaveFileDialog
$openFileDialog.initialDirectory	= [Environment]::GetFolderPath("Desktop")
$openFileDialog.filter				= "CSV (MS-DOS)|*.csv"
$openFileDialog.FileName			= "$(Get-Date -f yyMMdd) Artvise ärendekategorier ärendetyper"

$odfResult = $openFileDialog.ShowDialog()

if($odfResult -eq 'OK'){

	$outputPath = $openFileDialog.FileName

	$genericList | Export-CSV -Path $outputPath -NoTypeInformation -Encoding UTF8

}
else{

	Write-Warning -Message 'File dialog canceled, aborting...'

}