# api key
$apiKey = 'REPLACE-ME'

# urls
$evolutionServiceUriBase	= 'https://REPLACE-ME.se/EService.svc'
$evolutionServiceUriApiKey	= -join ($evolutionServiceUriBase, '?apikey=', $apiKey)

# body
$evolutionGetNextDiaryNumberBody = @"
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:tem="http://tempuri.org/" xmlns:evol="http://schemas.datacontract.org/2004/07/Evolution.EService.DataContracts">
		<soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
			<wsa:Action>http://tempuri.org/IEService/GetNextDiarynumber</wsa:Action>
			<wsa:To>$evolutionServiceUriBase</wsa:To>
		</soap:Header>
		<soap:Body>
			<tem:GetNextDiarynumber>
				<tem:request>
					<!-- diariekod -->
					<evol:UnitCode>TEST</evol:UnitCode>
				</tem:request>
			</tem:GetNextDiarynumber>
		</soap:Body>
	</soap:Envelope>
"@

# iwr params
$evolutionGetNextDiaryNumberInvokeParams = @{
	Method		= 'POST'
	ContentType	= 'application/soap+xml; charset=utf-8'
	URI			= $evolutionServiceUriApiKey
	Body		= $evolutionGetNextDiaryNumberBody
}

# invoke
try{
	$evolutionGetNextDiaryNumberInvoke = Invoke-RestMethod @evolutionGetNextDiaryNumberInvokeParams
}
catch{
	$_ | Out-Default
	return
}

# next diarynumber
$evolutionGetNextDiaryNumberInvoke.Envelope.Body.GetNextDiarynumberResponse.GetNextDiarynumberResult.DiaryNumber