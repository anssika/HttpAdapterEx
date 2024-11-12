Class HttpAdapterEx.Message.HttpResponse Extends (%Persistent, Ens.Response)
{

/// HTTP Status Code received (by outbound adapter) or to return (by inbound adapter) = <status code> <(optional) space> <(optional) reason phrase>
/// 
/// See https://www.rfc-editor.org/rfc/rfc9110.html#section-15.1
Property StatusCode As %String;

/// HTTP Headers received (by outbound adapter) or to return (by inbound adapter)
/// 
/// See https://www.rfc-editor.org/rfc/rfc9110.html#name-field-names
/// 
/// Please use: $Translate($ZConvert($Translate(<header name>, "-", " "), "W"), " ", "-") to set the case of a header
/// of use method HeaderName
Property Headers As array Of %String(MAXLEN = "");

/// HTTP body received (by outbound adapter) or to return (by inbound adapter)
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
<Data name="HttpResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StatusCode</Value>
</Value>
<Value name="3">
<Value>Body</Value>
</Value>
</Data>
<DataLocation>^HttpAdapterEx4C69.HttpResponseD</DataLocation>
<DefaultData>HttpResponseDefaultData</DefaultData>
<IdLocation>^HttpAdapterEx4C69.HttpResponseD</IdLocation>
<IndexLocation>^HttpAdapterEx4C69.HttpResponseI</IndexLocation>
<StreamLocation>^HttpAdapterEx4C69.HttpResponseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
