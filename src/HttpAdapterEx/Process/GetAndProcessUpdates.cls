/// Demonstrates a business process that:
/// - shall be started periodically
/// - polls for any updates using a business operation
/// - sends the updates, if any, using an other business operation
/// 
/// ToDo: the timeout-values should be defined as configuration settings
Class HttpAdapterEx.Process.GetAndProcessUpdates Extends Ens.BusinessProcess [ ClassType = persistent, ProcedureBlock ]
{

/// Name of the business host to get updates
Property GetUpdatesConfigName As Ens.DataType.ConfigName [ InitialExpression = "To_HttpServer1" ];

/// Name of the business host to send updates
Property SendUpdatesConfigName As Ens.DataType.ConfigName [ InitialExpression = "To_HttpServer2" ];

Parameter SETTINGS = "GetUpdatesConfigName:Basic,SendUpdatesConfigName:Basic";

Method OnRequest(pRequest As HttpAdapterEx.Message.HttpRequest, Output pResponse As %Persistent) As %Status
{
	#Dim tStatus As %Status = $$$OK
	#Dim tHttpStatus As %Integer

	/* ********************************************************************************
	**	Get updates if any
	*/

	#Dim tRequest1 As HttpAdapterEx.Message.HttpRequest = ##class(HttpAdapterEx.Message.HttpRequest).%New()
	Set tRequest1.Method = "GET"
	Do tRequest1.Headers.SetAt("text/plain", "Content-Type")
	Do tRequest1.Headers.SetAt(tRequest1.Headers.GetAt("Content-Type"), "Accept")

	#Dim tResponse1 As HttpAdapterEx.Message.HttpResponse
	Set tStatus = ..SendRequestSync(..GetUpdatesConfigName, tRequest1, .tResponse1, 2)
	If ($$$ISERR(tStatus)) Return tStatus

	Set tHttpStatus  = +(tResponse1.StatusCode)
	$$$LOGINFO("Received tHttpStatus = " _ tHttpStatus)
	If (tHttpStatus >= 400) {
		Return $$$ERROR($$$GeneralError, "Remote HTTP server returned error: " _ tResponse1.StatusCode)
	}
	ElseIf ((tHttpStatus '= 200) && (tHttpStatus '= 204)) {
		Return $$$ERROR($$$GeneralError, "Remote HTTP server returned unexpected status: " _ tResponse1.StatusCode)
	}

	/* ********************************************************************************
	**	Is there any updates?
	*/

	If ((tHttpStatus '= 200) || (tResponse1.Body = "")) {
		$$$LOGINFO("No updates")
		Return tStatus
	}

	/* ********************************************************************************
	**	Send updates
	*/

	#Dim tRequest2 As HttpAdapterEx.Message.HttpRequest = ##class(HttpAdapterEx.Message.HttpRequest).%New()
	Set tRequest2.Method = "POST"
	Do tRequest2.Headers.SetAt(tRequest1.Headers.GetAt("Content-Type"), "Content-Type")
	Do tRequest2.Headers.SetAt(tRequest2.Headers.GetAt("Content-Type"), "Accept")
	Set tRequest2.Body = tResponse1.Body

	#Dim tResponse2 As HttpAdapterEx.Message.HttpResponse
	Set tStatus = ..SendRequestSync(..SendUpdatesConfigName, tRequest2, .tResponse2, 2)
	If ($$$ISERR(tStatus)) Return tStatus

	Set tHttpStatus  = +(tResponse2.StatusCode)
	$$$LOGINFO("Received tHttpStatus = " _ tHttpStatus)
	If (tHttpStatus >= 400) {
		Return $$$ERROR($$$GeneralError, "Remote HTTP server returned error: " _ tResponse1.StatusCode)
	}
	ElseIf (tHttpStatus '= 201) {
		Return $$$ERROR($$$GeneralError, "Remote HTTP server returned unexpected status: " _ tResponse1.StatusCode)
	}


	Return tStatus
}

Storage Default
{
<Data name="GetAndProcessUpdatesDefaultData">
<Subscript>"GetAndProcessUpdates"</Subscript>
<Value name="1">
<Value>GetUpdatesConfigName</Value>
</Value>
<Value name="2">
<Value>SendUpdatesConfigName</Value>
</Value>
</Data>
<DefaultData>GetAndProcessUpdatesDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
