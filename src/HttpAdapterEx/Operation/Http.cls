Class HttpAdapterEx.Operation.Http Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Property Adapter As EnsLib.HTTP.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method OnHTTPRequest(pRequest As HttpAdapterEx.Message.HttpRequest, Output pResponse As HttpAdapterEx.Message.HttpResponse) As %Status
{
	#Dim tStatus As %Status = $$$OK

	#Dim tHTTPRequest As %Net.HttpRequest = ##class(%Net.HttpRequest).%New()

	// Host and/or port specified in pRequest?
	If ((pRequest.Server '= "") && (pRequest.Server '= "notSet")) {
		Set ..Adapter.HTTPServer = pRequest.Server
	}
	If (pRequest.Port > 0) {
		Set ..Adapter.HTTPPort = pRequest.Port
	}

	// HTTP Body to send
	Do tHTTPRequest.EntityBody.Write(pRequest.Body)

	// Request method
	#Dim pMethod As %String = $Translate(pRequest.Method, "U")

	// URL
	#Dim tURL As %String = ..Adapter.URL _ pRequest.URL
	
	// HTTP Headers to send
	#Dim tHeaderInfo As %String = ""
	#Dim tHeaderName As %String = ""
	// First header (if any)
	#Dim tHeaderValue As %String = pRequest.Headers.GetNext(.tHeaderName)
	While (tHeaderName '= "") {
		Set tHeaderName = pRequest.HeaderName(tHeaderName)
		If (tHeaderName = "Content-Type") {
			Set tHTTPRequest.ContentType = tHeaderValue
		}
		Else {
			Do tHTTPRequest.SetHeader(tHeaderName, tHeaderValue)
		}

		// Next header if any
		Set tHeaderValue = pRequest.Headers.GetNext(.tHeaderName)
	}

	// Invoke HTTP using outbound adapter
	#Dim tHTTPResponse As %Net.HttpResponse = $$$NULLOREF
	If ((pRequest.Method = "GET") || (pRequest.Method = "POST") ||
		(pRequest.Method = "PUT") || (pRequest.Method = "DELETE")) {
		Set tStatus = ..Adapter.SendFormDataArray(.tHTTPResponse, pRequest.Method, tHTTPRequest,,,tURL)
	}
	Else {
		Return $$$ERROR($$$GeneralError, "Unexpected HTTPMethod " _ pRequest.Method)
	}

	/// If error AND not http error
	If ($$$ISERR(tStatus)) {
		If ('$IsObject(tHTTPResponse)) Return tStatus
		If (tHTTPResponse.StatusLine = "") Return tStatus
	}

	// Create return message (no matter if the adapter returned an error or not)
	Set pResponse = ##class(HttpAdapterEx.Message.HttpResponse).%New()
	Set pResponse.StatusCode = $Piece(tHTTPResponse.StatusLine, " ", 2, *)
	If ($IsObject(tHTTPResponse.Data)) {
		While ('tHTTPResponse.Data.AtEnd) {
			Set pResponse.Body = pResponse.Body _ tHTTPResponse.Data.Read()
		}
	}
	Else {
		Set pResponse.Body = tHTTPResponse.Data
	}

	Set tHeaderValue = ""
	Set tHeaderName = $Order(tHTTPResponse.Headers(""), 1, tHeaderValue)
	While (tHeaderName '= "") {
		// The header names are in uppercase (HTTP inbound adapter returns them lower case)
		// We normalise them here even though headers are not case sensitive according to HTTP RFC
		Do pResponse.Headers.SetAt(tHeaderValue, ##class(HttpAdapterEx.Message.HttpRequest).HeaderName(tHeaderName))
		Set tHeaderName = $Order(tHTTPResponse.Headers(tHeaderName), 1, tHeaderValue)
	}

	Return $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="HttpAdapterEx.Message.HttpRequest"> 
		<Method>OnHTTPRequest</Method>
	</MapItem>
</MapItems>
}

}
