Class HttpAdapterEx.Message.HttpRequest Extends (%Persistent, Ens.Request)
{

/// Outbound: Overrides the adapter setting if value different from ""
Property Server As %String(MAXLEN = 200);

/// Outbound: Overrides the adapter setting if value different from ""
Property Port As %String;

/// Inbound: the method called
/// Outbound: the method to call
Property Method As %String(VALUELIST = ",GET,POST,PUT,DELETE") [ InitialExpression = "GET" ];

/// Inbound: the URL invoked including the parameters
/// Outbound: Appended to the URL setting of the adapter
Property URL As %String(MAXLEN = 200);

/// Inbound: HTTP Headers received
/// Outbound: HTTP Headers to add/set
Property Headers As array Of %String(MAXLEN = "");

/// Inbound: 
/// Attributes received as Attributes of the incoming stream created by EnsLib.HTTP.InboundAdapter
/// excluding those found in property Headers
Property OtherAttributes As array Of %String(MAXLEN = "");

/// Inbound: HTTP body received
/// Outbound: HTTP body to send
Property Body As %String(MAXLEN = "");

/// Canonicalise header name - e.g. content-TYPE --> Content-Type
ClassMethod HeaderName(pHeaderName As %String) As %String [ CodeMode = expression ]
{
$Translate($ZConvert($Translate(pHeaderName, "-", " "), "W"), " ", "-")
}

Storage Default
{
<Data name="Headers">
<Attribute>Headers</Attribute>
<Structure>subnode</Structure>
<Subscript>"Headers"</Subscript>
</Data>
<Data name="HttpRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Server</Value>
</Value>
<Value name="3">
<Value>Port</Value>
</Value>
<Value name="4">
<Value>Method</Value>
</Value>
<Value name="5">
<Value>URL</Value>
</Value>
<Value name="6">
<Value>Body</Value>
</Value>
</Data>
<Data name="OtherAttributes">
<Attribute>OtherAttributes</Attribute>
<Structure>subnode</Structure>
<Subscript>"OtherAttributes"</Subscript>
</Data>
<DataLocation>^HttpAdapterEx4C69.HttpRequestD</DataLocation>
<DefaultData>HttpRequestDefaultData</DefaultData>
<IdLocation>^HttpAdapterEx4C69.HttpRequestD</IdLocation>
<IndexLocation>^HttpAdapterEx4C69.HttpRequestI</IndexLocation>
<StreamLocation>^HttpAdapterEx4C69.HttpRequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
