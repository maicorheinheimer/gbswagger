unit GBSwagger.Model.JSON;

{$IF DEFINED(FPC)}
{$MODE DELPHI}{$H+}
{$MODESWITCH TypeHelpers}
{$ENDIF}

interface

uses
  {$IF DEFINED(FPC)}
  SysUtils,
  Generics.Collections,
  //Generics.Defaults,
  fpjson,
  {$ELSE}
  System.SysUtils,
  System.Generics.Collections,
  System.Generics.Defaults,
  System.JSON,
  {$ENDIF}
  GBSwagger.Model.JSON.Interfaces,
  GBSwagger.Model.JSON.Info,
  GBSwagger.Model.JSON.Schema,
  GBSwagger.Model.JSON.Path,
  GBSwagger.Model.JSON.Security,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types,
  GBSwagger.Model,
  GBSwagger.RTTI;

type TGBSwaggerModelJSON = class(TGBSwaggerModel, IGBSwaggerModelJSON)

  private
    [Weak]
    FSwagger: IGBSwagger;

    procedure ProcessOptions(AJsonObject: TJSOnObject);

    function JSONSecurity: TJSONObject;
    function JSONPath: TJSONObject;
    function JSONSchemes: TJSONArray;
    function JSONDefinitions: TJSONObject;
    function JSONContentTypes(Value: TArray<TGBSwaggerContentType>): TJSONArray;
  public
    constructor create(Swagger: IGBSwagger);
    destructor Destroy; override;
    class function New(Swagger: IGBSwagger): IGBSwaggerModelJSON;

    function ToJSON: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF};

end;

implementation

{ TGBSwaggerModelJSON }

constructor TGBSwaggerModelJSON.create(Swagger: IGBSwagger);
begin
  FSwagger := Swagger;
end;

destructor TGBSwaggerModelJSON.Destroy;
begin

  inherited;
end;

function TGBSwaggerModelJSON.JSONContentTypes(Value: TArray<TGBSwaggerContentType>): TJSONArray;
var
  i: Integer;
begin
  result := TJSONArray.Create;
  for i := 0 to Pred(Length(Value)) do
    Result.Add(Value[i].toString);
end;

function TGBSwaggerModelJSON.JSONDefinitions: TJSONObject;
var
  i: Integer;
  swaggerSchema: TArray<IGBSwaggerSchema>;
begin
  result := TJSONObject.Create;
  swaggerSchema := FSwagger.Schemas;


  //TArray
  //.Sort<IGBSwaggerSchema>(swaggerSchema,
  //  TComparer<IGBSwaggerSchema>.Construct(
  //    function (const Left, Right: IGBSwaggerSchema): Integer
  //    begin
  //      result := Left.Name.CompareTo(Right.Name);
  //    end));

  for i := 0 to Pred(Length(swaggerSchema)) do
  begin
    result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(
      swaggerSchema[i].Name,
      TGBSwaggerModelJSONSchema.New(swaggerSchema[i]).ToJSON
    );
  end;
end;

function TGBSwaggerModelJSON.JSONPath: TJSONObject;
var
  i: Integer;
  path: string;
  swaggerPaths: TArray<IGBSwaggerPath>;
begin
  result := TJSONObject.create;
  swaggerPaths := FSwagger.Paths;

  //TArray.Sort<IGBSwaggerPath>(swaggerPaths,
  //  TComparer<IGBSwaggerPath>.construct( function(const Left, Right: IGBSwaggerPath): Integer
  //  begin
  //    result := Left.Tags[0].CompareTo(Right.Tags[0]);
  //  end));

  for i := 0 to Pred(Length(swaggerPaths)) do
  begin
    path := swaggerPaths[i].Name;
    if not path.StartsWith('/') then
      path := '/' + path;

    Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(path, TGBSwaggerModelJSONPath.New(swaggerPaths[i]).ToJSON);
  end;
end;

function TGBSwaggerModelJSON.JSONSchemes: TJSONArray;
var
  i        : Integer;
  protocols: TArray<TGBSwaggerProtocol>;
begin
  result    := TJSONArray.Create;
  protocols := FSwagger.Protocols;

  for i := 0 to Pred(Length(protocols)) do
    Result.Add(protocols[i].toString);
end;

function TGBSwaggerModelJSON.JSONSecurity: TJSONObject;
var
  i: Integer;
  securities: TArray<IGBSwaggerSecurity>;
begin
  result     := TJSONObject.Create;
  securities := FSwagger.Securities;

  for i := 0 to Pred(Length(securities)) do
    Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(securities[i].Description, TGBSwaggerModelJSONSecurity.New(securities[i]).ToJSON);
end;

class function TGBSwaggerModelJSON.New(Swagger: IGBSwagger): IGBSwaggerModelJSON;
begin
  result := SElf.create(Swagger);
end;

procedure TGBSwaggerModelJSON.ProcessOptions(AJsonObject: TJSOnObject);
var
  LPair: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONPair{$ENDIF};
  LItem: TObject;
  i: Integer;

begin
  if not assigned(AJsonObject) then
    Exit;

  for i := AJsonObject.Count -1 downto 0  do
  begin
    LPair := {$IF DEFINED(FPC)}AJsonObject.Extract(i){$ELSE}TJSONPair(AJsonObject.Pairs[i]){$ENDIF};
    if LPair.{$IF DEFINED(FPC)}JSONType = jtObject{$ELSE}JsonValue is TJSOnObject{$ENDIF}then
    begin
      ProcessOptions(TJSONObject(LPair{$IF DEFINED(FPC)}{$ELSE}.JsonValue{$ENDIF}));
      if LPair.{$IF DEFINED(FPC)}{$ELSE}JsonValue.{$ENDIF}ToString.Equals('{}') then
      begin
        AJsonObject.RemovePair(LPair.JsonString.Value).DisposeOf;
        Continue;
      end;
    end
    else if LPair.JsonValue is TJSONArray then
    begin
//      if (TJSONArray(LPair.JsonValue).Count = 0) then
//      begin
//        AJsonObject.RemovePair(LPair.JsonString.Value).DisposeOf;
//      end
//      else
        for LItem in TJSONArray(LPair.JsonValue) do
        begin
          if LItem is TJSOnObject then
            ProcessOptions(TJSOnObject(LItem));
        end;
    end
    else
    begin
      if (LPair.JsonValue.value = '') or (LPair.JsonValue.ToJSON = '0') then
      begin
        AJsonObject.RemovePair(LPair.JsonString.Value).DisposeOf;
      end;
    end;
  end;
end;

function TGBSwaggerModelJSON.ToJSON: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF};
var
  LJSON: TJSONObject;
begin
  LJSON := TJSONObject.Create;
  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('swagger', FSwagger.Version);
  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('info', TGBSwaggerModelJSONInfo.New(FSwagger.Info).ToJSON);
  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('host', FSwagger.Host);
  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('basePath', FSwagger.BasePath);
  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('schemes', JSONSchemes);
  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('consumes', JSONContentTypes(FSwagger.Consumes));
  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('produces', JSONContentTypes(FSwagger.Produces));
  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('securityDefinitions', JSONSecurity);
  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('paths', JSONPath);
  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('definitions', JSONDefinitions);

  Result := LJSON;
  ProcessOptions(TJSONObject(result));
end;

end.
