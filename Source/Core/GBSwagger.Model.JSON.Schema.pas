unit GBSwagger.Model.JSON.Schema;

{$IF DEFINED(FPC)}
{$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  {$IF DEFINED(FPC)}
  Rtti,
  fpjson,
  SysUtils,
  TypInfo,
  StrUtils,
  {$ELSE}
  System.Rtti,
  System.JSON,
  System.SysUtils,
  System.TypInfo,
  System.StrUtils,
  {$ENDIF}
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.JSON.Interfaces,
  GBSwagger.RTTI,
  GBSwagger.Model.Attributes;

type TGBSwaggerModelJSONSchema = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSchema: IGBSwaggerSchema;

    function JSONSchema: TJSONObject;
    function JSONRequired: TJSONArray;
    function JSONProperties: TJSONObject;

    function JSONProperty             (AProperty: TRttiProperty): TJSONObject;
    function JSONPropertyPairArray    (AProperty: TRttiProperty): {$IF DEFINED(FPC)}TJSONObject{$ELSE}TJSONPair{$ENDIF};
    function JSONPropertyPairList     (AProperty: TRttiProperty): {$IF DEFINED(FPC)}TJSONObject{$ELSE}TJSONPair{$ENDIF};
    function JSONPropertyPairEnum     (AProperty: TRttiProperty): {$IF DEFINED(FPC)}TJSONObject{$ELSE}TJSONPair{$ENDIF};
    function JSONPropertyPairObject   (AProperty: TRttiProperty): {$IF DEFINED(FPC)}TJsonObject{$ELSE}TJSONPair{$ENDIF};

    function PropertyDateTimeFormat(AProperty: TRttiProperty): string;
  public
    function ToJSON: {$IF DEFINED(FPC)}TJsonData{$ELSE}TJSONValue{$ENDIF};

    constructor create(Schema: IGBSwaggerSchema);
    class function New(Schema: IGBSwaggerSchema): IGBSwaggerModelJSON;
    destructor  Destroy; override;
end;

implementation

{ TGBSwaggerModelJSONSchema }

constructor TGBSwaggerModelJSONSchema.create(Schema: IGBSwaggerSchema);
begin
  FSchema := Schema;
end;

destructor TGBSwaggerModelJSONSchema.Destroy;
begin

  inherited;
end;

function TGBSwaggerModelJSONSchema.JSONProperties: TJSONObject;
var
  rttiProperty: TRttiProperty;
begin
  result := TJSONObject.Create;
  for rttiProperty in FSchema.ClassType.GetProperties do
  begin
    if not rttiProperty.IsSwaggerIgnore(FSchema.ClassType) then
      Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(rttiProperty.SwagName, JSONProperty(rttiProperty))
  end;
end;

function TGBSwaggerModelJSONSchema.JSONProperty(AProperty: TRttiProperty): TJSONObject;
var
  attSwagNumber: SwagNumber;
  LArray: TJSONArray;
begin
  result := TJSONObject.Create;
  Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('type', AProperty.SwagType);
  Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('description', AProperty.SwagDescription);
  Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('minLength', {$IF DEFINED(FPC)}AProperty.SwagMinLength{$ELSE}TJSONNumber.Create(AProperty.SwagMinLength){$ENDIF});
  Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('maxLength', {$IF DEFINED(FPC)}AProperty.SwagMaxLength{$ELSE}TJSONNumber.Create(AProperty.SwagMaxLength){$ENDIF});

  if (AProperty.IsInteger) or (AProperty.IsFloat) then
  begin
    attSwagNumber := AProperty.GetSwagNumber;
    if Assigned(attSwagNumber) then
    begin
      Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('minimum', {$IF DEFINED(FPC)}attSwagNumber.minimum{$ELSE}TJSONNumber.Create(attSwagNumber.minimum){$ENDIF});
      Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('maximum', {$IF DEFINED(FPC)}attSwagNumber.maximum{$ELSE}TJSONNumber.Create(attSwagNumber.maximum){$ENDIF});
    end;
  end;

  if AProperty.IsDateTime then
  begin
    result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('format', PropertyDateTimeFormat(AProperty));
    Exit;
  end;

  if AProperty.IsArray then
  begin
    Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(JSONPropertyPairArray(AProperty){$IF DEFINED(FPC)}.AsJSON{$ENDIF});
    Exit;
  end;

  if AProperty.IsList then
  begin
    Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(JSONPropertyPairList(AProperty){$IF DEFINED(FPC)}.AsJSON{$ENDIF});
    Exit;
  end;

  if AProperty.IsEnum then
  begin
    Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(JSONPropertyPairEnum(AProperty){$IF DEFINED(FPC)}.AsJSON{$ENDIF});
    exit;
  end;

  if AProperty.IsObject then
  begin
    Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(JSONPropertyPairObject(AProperty){$IF DEFINED(FPC)}.AsJSON{$ENDIF});
    Result.{$IF DEFINED(FPC)}Remove(JSONPropertyPairObject(AProperty)){$ELSE}RemovePair('type').DisposeOf{$ENDIF};
    Exit;
  end;
end;

function TGBSwaggerModelJSONSchema.JSONPropertyPairArray(AProperty: TRttiProperty): {$IF DEFINED(FPC)}TJSONObject{$ELSE}TJSONPair{$ENDIF};
begin
  Result := {$IF DEFINED(FPC)}TJSONObject{$ELSE}TJSONPair{$ENDIF}.Create;
  Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(
        'items', TJSONObject.Create.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('type', AProperty.ArrayType)
    );
end;

function TGBSwaggerModelJSONSchema.JSONPropertyPairEnum(AProperty: TRttiProperty): {$IF DEFINED(FPC)}TJSONObject{$ELSE}TJSONPair{$ENDIF};
var
  enumNames: TArray<String>;
  jsonArray: TJSONArray;
  i: Integer;
begin
  enumNames := AProperty.GetEnumNames;
  jsonArray := TJSONArray.Create;

  for i := 0 to Length(enumNames) - 1 do
    jsonArray.Add(enumNames[i]);

  result := {$IF DEFINED(FPC)}TJsonObject{$ELSE}TJSONPair{$ENDIF}.Create;
  result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('enum', jsonArray);
end;

function TGBSwaggerModelJSONSchema.JSONPropertyPairList(AProperty: TRttiProperty): {$IF DEFINED(FPC)}TJSONObject{$ELSE}TJSONPair{$ENDIF};
var
  classType: TClass;
  className: string;
begin
  classType := AProperty.ListTypeClass;
  className := FSchema.&End.SchemaName(classType);
  Result    := {$IF DEFINED(FPC)}TJsonObject{$ELSE}TJSONPair{$ENDIF}.Create;
  Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(
        'items', TJSONObject.Create
                   .{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('$ref', '#/definitions/' + className)
  );
end;

function TGBSwaggerModelJSONSchema.JSONPropertyPairObject(AProperty: TRttiProperty): {$IF DEFINED(FPC)}TJsonObject{$ELSE}TJSONPair{$ENDIF};
var
  classType: TClass;
  className: string;
begin
  classType := AProperty.GetClassType;
  className := FSchema.&End.SchemaName(classType);

  Result := {$IF DEFINED(FPC)}TJsonObject{$ELSE}TJSONPair{$ENDIF}.Create;
  Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('$ref', '#/definitions/' + className);
end;

function TGBSwaggerModelJSONSchema.JSONRequired: TJSONArray;
var
  i : Integer;
  requiredFields: TArray<String>;
begin
  requiredFields := FSchema.ClassType.SwaggerRequiredFields;

  result := TJSONArray.Create;
  for i := 0 to Pred(Length(requiredFields)) do
    result.Add(requiredFields[i]);
end;

function TGBSwaggerModelJSONSchema.JSONSchema: TJSONObject;
begin
  result := TJSONObject.Create;
  result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('type', 'object');
  result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('description', FSchema.ClassType.SwagDescription(FSchema.&End));

  if Length(FSchema.ClassType.SwaggerRequiredFields) > 0 then
    result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('required', JSONRequired);

  result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('properties', JSONProperties);
end;

class function TGBSwaggerModelJSONSchema.New(Schema: IGBSwaggerSchema): IGBSwaggerModelJSON;
begin
  result := Self.create(Schema);
end;

function TGBSwaggerModelJSONSchema.PropertyDateTimeFormat(AProperty: TRttiProperty): string;
var
  swDate: SwagDate;
begin
  result := EmptyStr;

  swDate := AProperty.GetAttribute<SwagDate>;
  if Assigned(swDate) then
    result := swDate.dateFormat;

  if result.IsEmpty then
    result := FSchema.&End.Config.DateFormat;

  if result.IsEmpty then
    result := 'date-time';
end;

function TGBSwaggerModelJSONSchema.ToJSON: {$IF DEFINED(FPC)}TJsonData{$ELSE}TJSONValue{$ENDIF};
begin
  Result := JSONSchema;
end;

end.
