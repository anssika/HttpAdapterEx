/// This is process is for simple testing purposes
Class HttpAdapterEx.Process.Server Extends Ens.BusinessProcess [ ClassType = persistent, ProcedureBlock ]
{

/// Http status to return, e.g.: 200 OK, 201 Created, 204 No Content, ... See https://www.rfc-editor.org/rfc/rfc9110.html#name-status-codes.
Property HttpStatusCode As %String [ InitialExpression = "200 OK" ];

/// Http body to return
Property HttpBody As %String(MAXLEN = "") [ InitialExpression = "{ ""status"": ""ok""}" ];

Parameter SETTINGS = "HttpStatusCode:Basic,HttpBody:Basic";

Method OnRequest(pRequest As HttpAdapterEx.Message.HttpRequest, Output pResponse As HttpAdapterEx.Message.HttpResponse) As %Status
{
	#Dim tStatus As %Status = $$$OK

	/* ********************************************************************************
	**	Create return message
	*/

	Set pResponse = ##class(HttpAdapterEx.Message.HttpResponse).%New()
	Set pResponse.Body = ..HttpBody
	Set pResponse.StatusCode = ..HttpStatusCode

	/* ********************************************************************************
	**	Set Content-Type
	*/

	$$$LOGINFO("Inspecting the HTTP headers received in order set Content-Type of the response")
	#Dim tContentType As %String = "application/json"
	If (pRequest.Headers.GetAt("Accept") '= "") {
		$$$LOGINFO("Found HTTP header Accept - Using its value '" _ pRequest.Headers.GetAt("Accept") _ "' as Content-Type of the response")
		Set tContentType = pRequest.Headers.GetAt("Accept")
	}
	Else {
		$$$LOGINFO("Did not find HTTP header Accept ...")
		If (pRequest.Headers.GetAt("Content-Type") '= "") {
		$$$LOGINFO("Found HTTP header Content-Type - Using its value '" _ pRequest.Headers.GetAt("Content-Type") _ "' as Content-Type of the response")
			Set tContentType = pRequest.Headers.GetAt("Content-Type")
		}
		Else {
			$$$LOGINFO("Did not find HTTP header Content-Type ...")
			$$$LOGINFO("Using default Content-Type '" _ tContentType _ "' as Content-Type of the response")
		}
	}
	Do pResponse.Headers.SetAt(tContentType, "Content-Type")

	Return tStatus
}

Storage Default
{
<Data name="ServerDefaultData">
<Subscript>"Server"</Subscript>
<Value name="1">
<Value>HttpStatus</Value>
</Value>
<Value name="2">
<Value>HttpBody</Value>
</Value>
<Value name="3">
<Value>HttpStatusCode</Value>
</Value>
</Data>
<DefaultData>ServerDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
