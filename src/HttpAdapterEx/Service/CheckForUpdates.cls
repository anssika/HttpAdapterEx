/// Demonstrates how to send an interoperability message periodically.
/// This can be used e.g. to start a business process periodically. 
Class HttpAdapterEx.Service.CheckForUpdates Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

/// Name of the business host to send messages to
Property TargetConfigName As Ens.DataType.ConfigName [ InitialExpression = "GetAndProcessUpdates" ];

Parameter SETTINGS = "TargetConfigName:Basic";

Method OnProcessInput(pInput As %Stream.Object, Output pOutput As %Stream.Object) As %Status
{
	#Dim tStatus As %Status = $$$OK

	/* ********************************************************************************
	**	Send a message to start the process for getting and processing updates
	*/

	#Dim tRequest As HttpAdapterEx.Message.HttpRequest = ##class(HttpAdapterEx.Message.HttpRequest).%New()
	Set tRequest.Method = "GET"
	Do tRequest.Headers.SetAt("text/plain", "Content-Type")
	Do tRequest.Headers.SetAt("text/plain", "Accept")
	Set tRequest.Body = "a message to start an instance of the business process"

	#Dim tResponse1 As HttpAdapterEx.Message.HttpResponse
	Set tStatus = ..SendRequestAsync(..TargetConfigName, tRequest)

	Return tStatus
}

}
