unit GBSwagger.Model.JSON.Utils;

{$IF DEFINED(FPC)}
{$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  {$IF DEFINED(FPC)}
  fpjson,
  {$ELSE}
  System.JSON,
  {$ENDIF}
  GBSwagger.Model.Types;

type TGBSwaggerModelJSONUtils = class

  public
    class function JSONContentTypes(Value: TArray<TGBSwaggerContentType>): TJSONArray;
    class function JSONProtocols   (Value: TArray<TGBSwaggerProtocol>)   : TJSONArray;

    class function JSONSchemaArray (SchemaName: string): TJSONObject;
    class function JSONSchemaObject(SchemaName: string): TJSONObject;

end;

implementation

{ TGBSwaggerModelJSONUtils }

class function TGBSwaggerModelJSONUtils.JSONContentTypes(Value: TArray<TGBSwaggerContentType>): TJSONArray;
var
  i: Integer;
begin
  result := TJSONArray.Create;
  for i := 0 to Pred(Length(Value)) do
    Result.Add(Value[i].toString);
end;

class function TGBSwaggerModelJSONUtils.JSONProtocols(Value: TArray<TGBSwaggerProtocol>): TJSONArray;
var
  i: Integer;
begin
  result := TJSONArray.Create;
  for i := 0 to Pred(Length(Value)) do
    Result.Add(Value[i].toString);
end;

class function TGBSwaggerModelJSONUtils.JSONSchemaArray(SchemaName: string): TJSONObject;
begin
  result := TJSONObject.Create;
  result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('type', 'array');
  result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('items',
      TJSONObject.Create.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('$ref', '#/definitions/' + SchemaName));
end;

class function TGBSwaggerModelJSONUtils.JSONSchemaObject(SchemaName: string): TJSONObject;
begin
  result := TJSONObject.Create;

  result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('$ref', '#/definitions/' + SchemaName);
end;

end.
