Class HttpAdapterEx.Service.Http Extends Ens.BusinessService
{

Parameter ADAPTER = "EnsLib.HTTP.InboundAdapter";

/// Name of the business host to send messages to
Property TargetConfigName As Ens.DataType.ConfigName [ InitialExpression = "HTTPRequestRouter" ];

/// Number of seconds to wait for the response from <property>TargetConfigName</property>
Property Timeout As %Integer [ InitialExpression = 2 ];

Parameter SETTINGS = "TargetConfigName:Basic,Timeout:Basic";

Method OnProcessInput(pInput As %Stream.Object, Output pOutput As %Stream.Object) As %Status
{
	#Dim tStatus As %Status = $$$OK

	// Create the stream to return to the adapter
	// This stream contains the HTTP body and the headers to return
	If (pInput.%IsA("%Library.GlobalBinaryStream")) {
		Set pOutput = ##class(%GlobalBinaryStream).%New()
	}
	Else {
		Set pOutput = ##class(%GlobalCharacterStream).%New()
	}

	// If not configured to call another business host ...
	If (..TargetConfigName = "") {
		Set pOutput("ResponseCode") = "200 OK"
		Return tStatus
	}

	// Create interoperability message based on the HTTP request

	#Dim tRequest As HttpAdapterEx.Message.HttpRequest = ##class(HttpAdapterEx.Message.HttpRequest).%New()
	// method
	Set tRequest.Method = pInput.Attributes("HttpRequest")
	// url
	Set tRequest.URL = pInput.Attributes("URL")
	If (pInput.Attributes("RawParams") '= "") {
		Set tRequest.URL = tRequest.URL _ "?" _ pInput.Attributes("RawParams")
	}
	// headers
	#Dim tKey, tValue As %String = ""
	Set tKey = $Order(pInput.Attributes(""), 1, tValue)
	While (tKey '= "") {
		If ('..IsHTTPHeader(tKey)) {
			Do tRequest.OtherAttributes.SetAt(tValue, tKey)
		}
		Else {
			// The header names are in lower case (HTTP outbound adapter returns them upper case)
			// We normalise them here even though headers are not case sensitive according to HTTP RFC
			Do tRequest.Headers.SetAt(tValue, ##class(HttpAdapterEx.Message.HttpRequest).HeaderName(tKey))
		}

		Set tKey = $Order(pInput.Attributes(tKey), 1, tValue)
	}
	// body
	Set tRequest.Body = pInput.Read()

	#Dim tResponse As HttpAdapterEx.Message.HttpResponse
	Set tStatus = ..SendRequestSync(..TargetConfigName, tRequest, .tResponse, ..Timeout)

	// Error?
	If ($$$ISERR(tStatus)) Return tStatus	// This returns HTTP status 500 Internal Server Error

	// Timeout?
	If ('$IsObject(tResponse)) {
		// This returns HTTP status 500 Internal Server Error
		Return $$$ERROR($$$GeneralError, "Timeout when waiting for response from " _ ..TargetConfigName)
	}

	// Map the response message to the adapter

	// Status code & line
	Set pOutput("ResponseCode") = tResponse.StatusCode
	// headers
	#Dim tHeaderName As %String = ""
	#Dim tHeaderValue As %String = tResponse.Headers.GetNext(.tHeaderName)
	While (tHeaderName '= "") {
		If (((tHeaderName = "Cache-Control") || (tHeaderName = "Pragma")) && (tHeaderValue = "no-cache")) {
			// The inbound adapter seems to add value no-cache to the values of these headers, resulting to value no-cache,no-cache
		}
		Else {
			Set pOutput.Attributes(tHeaderName) = tHeaderValue
		}
		Set tHeaderValue = tResponse.Headers.GetNext(.tHeaderName)
	}
	// body
	Do pOutput.Write(tResponse.Body)

	Return $$$OK
}

ClassMethod IsHTTPHeader(pAttribute As %String) As %Boolean
{
	If (pAttribute = "CharEncoding") Return 0
	If (pAttribute = "EnsConfigName") Return 0
	If (pAttribute = "HTTPVersion") Return 0
	If (pAttribute = "HttpRequest") Return 0
	If (pAttribute = "IParams") Return 0
	If (pAttribute = "Params") Return 0
	If (pAttribute = "RawParams") Return 0
	If (pAttribute = "TranslationTable") Return 0
	If (pAttribute = "URL") Return 0
	//If (pAttribute = "host") Return 0
	//If (pAttribute = "user-agent") Return 0

	Return 1
}

}
