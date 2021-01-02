unit GBSwagger.Model.JSON.PathResponse;

{$IF DEFINED(FPC)}
{$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  {$IF DEFINED(FPC)}
  SysUtils,
  fpjson,
  {$ELSE}
  System.SysUtils,
  System.StrUtils,
  System.JSON,
  {$ENDIF}
  GBSwagger.RTTI,
  GBSwagger.Model.JSON.Utils,
  GBSwagger.Model.JSON.Interfaces,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.JSON.Header,
  GBSwagger.Model.Types;

type TGBSwaggerModelJSONPathResponse = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSwaggerPathResponse: IGBSwaggerPathResponse;

    function JSONSchema   : TJSONObject;
    function JSONHeaders  : TJSONObject;
  public
    constructor create(SwaggerPathResponse: IGBSwaggerPathResponse);
    class function New(SwaggerPathResponse: IGBSwaggerPathResponse): IGBSwaggerModelJSON;

    function ToJSON: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF};
end;

implementation

{ TGBSwaggerModelJSONPathResponse }

constructor TGBSwaggerModelJSONPathResponse.create(SwaggerPathResponse: IGBSwaggerPathResponse);
begin
  FSwaggerPathResponse := SwaggerPathResponse;
end;

function TGBSwaggerModelJSONPathResponse.JSONHeaders: TJSONObject;
var
  header  : IGBSwaggerHeader;
  headers : TArray<IGBSwaggerHeader>;
begin
  result  := TJSONObject.Create;
  headers := FSwaggerPathResponse.Headers;

  if Length(headers) > 0 then
  begin
    for header in headers do
      result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(header.Name, TGBSwaggerModelJSONHeader.New(header).ToJSON);
  end;
end;

function TGBSwaggerModelJSONPathResponse.JSONSchema: TJSONObject;
var
  schemaName: String;
begin
  schemaName := FSwaggerPathResponse.&End.&End.&End.SchemaName(FSwaggerPathResponse.Schema);
  if FSwaggerPathResponse.IsArray then
    result := TGBSwaggerModelJSONUtils.JSONSchemaArray(schemaName)
  else
    result := TGBSwaggerModelJSONUtils.JSONSchemaObject(schemaName);
end;

class function TGBSwaggerModelJSONPathResponse.New(SwaggerPathResponse: IGBSwaggerPathResponse): IGBSwaggerModelJSON;
begin
  result := Self.create(SwaggerPathResponse);
end;

function TGBSwaggerModelJSONPathResponse.ToJSON: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF};
var
  json: TJSONObject;
begin
  json := TJSONObject.Create;
  json.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('description', FSwaggerPathResponse.Description);

  if Assigned(FSwaggerPathResponse.Schema) then
    json.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('schema', JSONSchema)
  else
    json.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('schema', TJSONObject.Create
                            .{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('type', FSwaggerPathResponse.&Type));

  json.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('headers', JSONHeaders);
  result := json;
end;

end.
