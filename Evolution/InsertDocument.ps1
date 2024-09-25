# api key
$apiKey = 'REPLACE-ME'

# urls
$evolutionServiceUriBase	= 'https://REPLACE-ME.se/EService.svc'
$evolutionServiceUriApiKey	= -join ($evolutionServiceUriBase, '?apikey=', $apiKey)

# source file
$filePath = 'C:\REPLACE-ME.txt'

# convert
$base64 = [convert]::ToBase64String((Get-Content -Path $filePath -Encoding byte))

# body
$evolutionInsertDocumentBody = @"
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:tem="http://tempuri.org/" xmlns:evol="http://schemas.datacontract.org/2004/07/Evolution.EService.DataContracts" xmlns:evol1="http://schemas.datacontract.org/2004/07/Evolution.EService.DataAccess" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
		<soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
			<wsa:Action>http://tempuri.org/IEService/InsertDocument</wsa:Action>
			<wsa:To>$evolutionServiceUriBase</wsa:To>
		</soap:Header>
		<soap:Body>
			<tem:InsertDocument>
				<tem:request>
					<!-- klassificering -->
					<evol:ActivityProcessId>e9b20d99-dff1-4d32-8605-34217eb14e8d</evol:ActivityProcessId>
					<!-- avsändare/mottagare -->
					<evol:CustomerDetails>
						<!-- förnamn -->
						<evol1:FirstName>REPLACE-ME</evol1:FirstName>
						<!-- efternamn -->
						<evol1:LastName>REPLACE-ME</evol1:LastName>
					</evol:CustomerDetails>
					<!-- rubrik -->
					<evol:Description>REPLACE-ME</evol:Description>
					<!-- ärendenummer -->
					<evol:DiaryNumber>REPLACE-ME</evol:DiaryNumber>
					<!-- status (Preliminary, In, Out)-->
					<evol:DirectionStatus>REPLACE-ME</evol:DirectionStatus>
					<!-- handlingstyp -->
					<evol:DocumentTypeCode>REPLACE-ME</evol:DocumentTypeCode>
					<!-- fil -->
					<evol:FileDetails>
						<!-- base64 string -->
						<evol1:Buffer>$base64</evol1:Buffer>
						<!-- filtyp (t.ex. .txt) -->
						<evol1:Extension>REPLACE-ME</evol1:Extension>
						<!-- filnamn -->
						<evol1:FileName>REPLACE-ME</evol1:FileName>
					</evol:FileDetails>
					<!-- notering -->
					<evol:Note>REPLACE-ME</evol:Note>
					<!-- handläggare -->
					<evol:ResponsibleLoginName>REPLACE-ME</evol:ResponsibleLoginName>
					<!-- namn på tjänst kopplat till API-nyckeln -->
					<evol:ServiceName>OpenE</evol:ServiceName>
				</tem:request>
			</tem:InsertDocument>
		</soap:Body>
	</soap:Envelope>
"@

# iwr params
$evolutionInsertDocumentInvokeParams = @{
	Method		= 'POST'
	ContentType	= 'application/soap+xml; charset=utf-8'
	URI			= $evolutionServiceUriApiKey
	Body		= $evolutionInsertDocumentBody
}

# invoke
try{
	$evolutionInsertDocumentInvoke = Invoke-RestMethod @evolutionInsertDocumentInvokeParams
}
catch{
	$_ | Out-Default
	return
}

# document id
$evolutionInsertDocumentInvoke.Envelope.Body.InsertDocumentResponse.InsertDocumentResult.Id
