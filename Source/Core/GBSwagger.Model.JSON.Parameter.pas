unit GBSwagger.Model.JSON.Parameter;

{$IF DEFINED(FPC)}
{$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  {$IF DEFINED(FPC)}
  SysUtils,
  StrUtils,
  Variants,
  fpjson,
  {$ELSE}
  System.SysUtils,
  System.StrUtils,
  System.Variants,
  System.JSON,
  {$ENDIF}
  GBSwagger.Model.JSON.Interfaces,
  GBSwagger.Model.JSON.Utils,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types;

type TGBSwaggerModelJSONParameter = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSwaggerParameter: IGBSwaggerParameter;

    procedure ParamEnum(AJsonObject: TJSONObject);
  public
    constructor create(SwaggerParameter: IGBSwaggerParameter);
    class function New(SwaggerParameter: IGBSwaggerParameter): IGBSwaggerModelJSON;

    function ToJSON: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF};
end;

implementation

{ TGBSwaggerModelJSONParameter }

constructor TGBSwaggerModelJSONParameter.create(SwaggerParameter: IGBSwaggerParameter);
begin
  FSwaggerParameter := SwaggerParameter;
end;

class function TGBSwaggerModelJSONParameter.New(SwaggerParameter: IGBSwaggerParameter): IGBSwaggerModelJSON;
begin
  result := Self.create(SwaggerParameter);
end;

procedure TGBSwaggerModelJSONParameter.ParamEnum(AJsonObject: TJSONObject);
var
  jsonArray: TJSONArray;
  LJSON: TJSONObject;
  i        : Integer;
begin
  jsonArray := TJSONArray.Create;
  for i := 0 to Pred(Length(FSwaggerParameter.EnumValues)) do
    jsonArray.Add(VarToStr( FSwaggerParameter.EnumValues[i]));

  LJSON := TJSONObject.Create;
  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('type', 'string');
  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('enum', jsonArray);
  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('default', VarToStr(FSwaggerParameter.EnumValues[0]));

  AJsonObject.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('type', 'array');
  AJsonObject.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('items', LJSON);
end;

function TGBSwaggerModelJSONParameter.ToJSON: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF};
var
  jsonObject: TJSONObject;
  jsonSchema: TJSONObject;
  schemaName: string;
begin
  jsonObject := TJSONObject.Create;
  jsonObject.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('in', FSwaggerParameter.ParamType.toString);
  jsonObject.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('name', FSwaggerParameter.Name);
  jsonObject.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('description', FSwaggerParameter.Description);
  jsonObject.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('required', {$IF DEFINED(FPC)}FSwaggerParameter.Required{$ELSE}TJSONBool.Create(FSwaggerParameter.Required){$ENDIF});

  schemaName := FSwaggerParameter.SchemaType;

  if not schemaName.IsEmpty then
    if FSwaggerParameter.IsArray then
    begin
      if FSwaggerParameter.SchemaType.IsEmpty then
        jsonObject.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('schema', TGBSwaggerModelJSONUtils.JSONSchemaArray(schemaName))
      else
      begin
        if FSwaggerParameter.Schema <> nil then
        begin
          jsonSchema := TJSONObject.Create;
          jsonSchema.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('type', 'array');
          jsonSchema.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('items', TJSONObject.Create
              .{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('$ref', '#/definitions/' + schemaName));

          jsonObject.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('schema', jsonSchema);
        end
        else
        begin
          jsonObject.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('type', 'array');
          jsonObject.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('items', TJSONObject.Create.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('type', FSwaggerParameter.SchemaType));
        end;
      end;
    end
    else
    if FSwaggerParameter.IsObject then
      jsonObject.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('schema', TGBSwaggerModelJSONUtils.JSONSchemaObject(schemaName))
    else
    if FSwaggerParameter.IsEnum then
      ParamEnum(jsonObject)
    else
      jsonObject.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('type', schemaName);

  result := jsonObject;
end;

end.
