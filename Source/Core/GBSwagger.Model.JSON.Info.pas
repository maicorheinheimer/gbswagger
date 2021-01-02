unit GBSwagger.Model.JSON.Info;

{$IF DEFINED(FPC)}
{$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  {$IF DEFINED(FPC)}
  fpjson,
  SysUtils,
  {$ELSE}
  System.JSON,
  System.SysUtils,
  {$ENDIF}
  GBSwagger.Model.JSON.Interfaces,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types,
  GBSwagger.Model.JSON.Contact;

type TGBSwaggerModelJSONInfo = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSwaggerInfo: IGBSwaggerInfo;

  public
    constructor create(SwaggerInfo: IGBSwaggerInfo);
    class function New(SwaggerInfo: IGBSwaggerInfo): IGBSwaggerModelJSON;

    function ToJSON: {$IF DEFINED(FPC)}TJsonData{$ELSE}TJSONValue{$ENDIF};

end;

implementation

{ TGBSwaggerModelJSONInfo }

constructor TGBSwaggerModelJSONInfo.create(SwaggerInfo: IGBSwaggerInfo);
begin
  FSwaggerInfo := SwaggerInfo;
end;

class function TGBSwaggerModelJSONInfo.New(SwaggerInfo: IGBSwaggerInfo): IGBSwaggerModelJSON;
begin
  Result := Self.create(SwaggerInfo);
end;

function TGBSwaggerModelJSONInfo.ToJSON: {$IF DEFINED(FPC)}TJsonData{$ELSE}TJSONValue{$ENDIF};
var
  title: string;
  ext  : string;
  LJSON: TJSONObject;
begin
  title := FSwaggerInfo.Title;
  if title.IsEmpty then
  begin
    title := ExtractFileName(GetModuleName(HInstance));
    ext   := ExtractFileExt(title);
    title := title.Replace(ext, EmptyStr);
  end;

  LJSON := TJSONObject.Create;

  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('description', FSwaggerInfo.Description);
  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('version', FSwaggerInfo.Version);
  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('title', title);
  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('termsOfService', FSwaggerInfo.TermsOfService);
  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('contact', TGBSwaggerModelJSONContact.New(FSwaggerInfo.Contact).ToJSON);
  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('license', TGBSwaggerModelJSONContact.New(FSwaggerInfo.License).ToJSON);

  result := LJSON;
end;

end.
