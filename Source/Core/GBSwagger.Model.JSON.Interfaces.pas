unit GBSwagger.Model.JSON.Interfaces;

{$IF DEFINED(FPC)}
{$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  {$IF DEFINED(FPC)}
  //REST.Json,
  fpjson,
  {$ELSE}
  REST.Json,
  System.JSON,
  {$ENDIF}
  GBSwagger.Model.Interfaces;

type
  IGBSwaggerModelJSON = interface
    function ToJSON: {$IF DEFINED(FPC)}TJsonData{$ELSE}TJSONValue{$ENDIF};
  end;

function SwaggerJSON      (ASwagger: IGBSwagger): {$IF DEFINED(FPC)}TJsonData{$ELSE}TJSONValue{$ENDIF};
function SwaggerJSONString(ASwagger: IGBSwagger): String;

implementation

uses
  GBSwagger.Model.JSON;

function SwaggerJSON(ASwagger: IGBSwagger): {$IF DEFINED(FPC)}TJsonData{$ELSE}TJSONValue{$ENDIF};
begin
  result := TGBSwaggerModelJSON.New(ASwagger)
              .ToJSON;
end;

function SwaggerJSONString(ASwagger: IGBSwagger): String;
var
  json: TJSONValue;
begin
  json := SwaggerJSON(ASwagger);
  try
    {$IF CompilerVersion > 32.0}
    Result := json.Format;
    {$ELSE}
    Result := TJson.Format(json);
    {$ENDIF}
  finally
    json.Free;
  end;
end;


end.
