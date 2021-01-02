unit GBSwagger.Model.JSON.Path;

{$IF DEFINED(FPC)}
{$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  {$IF DEFINED(FPC)}
  SysUtils,
  StrUtils,
  fpjson,
  {$ELSE}
  System.SysUtils,
  System.StrUtils,
  System.JSON,
  {$ENDIF}
  GBSwagger.Model.JSON.Interfaces,
  GBSwagger.Model.JSON.Utils,
  GBSwagger.Model.JSON.PathMethod,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types;

type TGBSwaggerModelJSONPath = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSwaggerPath: IGBSwaggerPath;

  public
    constructor create(SwaggerPath: IGBSwaggerPath);
    class function New(SwaggerPath: IGBSwaggerPath): IGBSwaggerModelJSON;

    function ToJSON: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF};
end;

implementation

{ TGBSwaggerModelJSONPath }

constructor TGBSwaggerModelJSONPath.create(SwaggerPath: IGBSwaggerPath);
begin
  FSwaggerPath := SwaggerPath;
end;

class function TGBSwaggerModelJSONPath.New(SwaggerPath: IGBSwaggerPath): IGBSwaggerModelJSON;
begin
  result := Self.create(SwaggerPath);
end;

function TGBSwaggerModelJSONPath.ToJSON: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF};
var
  jsonObject: TJSONObject;
  i         : Integer;
begin
  jsonObject := TJSONObject.Create;

  for i := 0 to Pred(Length(FSwaggerPath.Methods)) do
    jsonObject.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(
        FSwaggerPath.Methods[i].MethodType.toString,
        TGBSwaggerModelJSONPathMethod.New(FSwaggerPath.Methods[i]).ToJSON
    );

  Result := jsonObject;
end;

end.
