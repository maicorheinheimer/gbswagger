unit GBSwagger.Model.JSON.Header;

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
  GBSwagger.Model.Interfaces;

type TGBSwaggerModelJSONHeader = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSwaggerHeader: IGBSwaggerHeader;

  public
    constructor create(SwaggerHeader: IGBSwaggerHeader);
    class function New(SwaggerHeader: IGBSwaggerHeader): IGBSwaggerModelJSON;

    function ToJSON: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF};
end;

implementation

{ TGBSwaggerModelJSONHeader }

constructor TGBSwaggerModelJSONHeader.create(SwaggerHeader: IGBSwaggerHeader);
begin
  FSwaggerHeader := SwaggerHeader;
end;

class function TGBSwaggerModelJSONHeader.New(SwaggerHeader: IGBSwaggerHeader): IGBSwaggerModelJSON;
begin
  result := Self.create(SwaggerHeader);
end;

function TGBSwaggerModelJSONHeader.ToJSON: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF};
var
  LJSON: TJSONObject;
begin
  LJSON := TJSONObject.Create;
  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('type', FSwaggerHeader.&Type);
  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('format', FSwaggerHeader.Format);
  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('description', FSwaggerHeader.Description);
  Result := LJSON;
end;

end.
