Class HttpAdapterEx.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="HttpAdapterEx.Production" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="HttpServer1" Category="Server1" ClassName="HttpAdapterEx.Process.Server" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HttpServer2" Category="Server2" ClassName="HttpAdapterEx.Process.Server" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HttpService1" Category="Server1" ClassName="HttpAdapterEx.Service.Http" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Port">58161</Setting>
    <Setting Target="Host" Name="TargetConfigName">HttpServer1</Setting>
  </Item>
  <Item Name="HttpService2" Category="Server2" ClassName="HttpAdapterEx.Service.Http" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Port">58162</Setting>
    <Setting Target="Host" Name="TargetConfigName">HttpServer2</Setting>
  </Item>
  <Item Name="To_HttpServer1" Category="Client" ClassName="HttpAdapterEx.Operation.Http" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="HTTPPort">58161</Setting>
    <Setting Target="Adapter" Name="HTTPServer">localhost</Setting>
  </Item>
  <Item Name="To_HttpServer2" Category="Client" ClassName="HttpAdapterEx.Operation.Http" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="HTTPPort">58162</Setting>
    <Setting Target="Adapter" Name="HTTPServer">localhost</Setting>
  </Item>
  <Item Name="GetAndProcessUpdates" Category="Client" ClassName="HttpAdapterEx.Process.GetAndProcessUpdates" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
