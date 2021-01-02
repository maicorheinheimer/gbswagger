unit GBSwagger.Model.JSON.Security;

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
  System.JSON,
  {$ENDIF}
  GBSwagger.Model.JSON.Interfaces,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types;

type TGBSwaggerModelJSONSecurity = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSwaggerSecurity: IGBSwaggerSecurity;

    function JSONBasicAuth: TJSONObject;
    function JSONAPIKey   : TJSONObject;
    function JSONOAuth    : TJSONObject;
  public
    constructor create(SwaggerSecurity: IGBSwaggerSecurity);
    class function New(SwaggerSecurity: IGBSwaggerSecurity): IGBSwaggerModelJSON;

    function ToJSON: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF};

end;

implementation

{ TGBSwaggerModelJSONSecurity }

constructor TGBSwaggerModelJSONSecurity.create(SwaggerSecurity: IGBSwaggerSecurity);
begin
  FSwaggerSecurity := SwaggerSecurity;
end;

function TGBSwaggerModelJSONSecurity.JSONAPIKey: TJSONObject;
begin
  result := TJSONObject.Create;
  result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('type', FSwaggerSecurity.&Type.toString);
  result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('name', FSwaggerSecurity.Name);
  result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('in', FSwaggerSecurity.&In.toString);
end;

function TGBSwaggerModelJSONSecurity.JSONBasicAuth: TJSONObject;
begin
  result := TJSONObject.Create;
  result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('type', FSwaggerSecurity.&Type.toString);
  result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('name', FSwaggerSecurity.Name);
end;

function TGBSwaggerModelJSONSecurity.JSONOAuth: TJSONObject;
begin
  Result := TJSONObject.Create;
  result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('type', FSwaggerSecurity.&Type.toString);
  result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('authorizationUrl', FSwaggerSecurity.AuthorizationURL);
  result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('flow', FSwaggerSecurity.Flow.toString);
end;

class function TGBSwaggerModelJSONSecurity.New(SwaggerSecurity: IGBSwaggerSecurity): IGBSwaggerModelJSON;
begin
  result := Self.create(SwaggerSecurity);
end;

function TGBSwaggerModelJSONSecurity.ToJSON: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF};
begin
  case FSwaggerSecurity.&Type of
    gbBasic : result := JSONBasicAuth;
    gbApiKey: result := JSONAPIKey;
    gbOAuth2: result := JSONOAuth;
  else
    raise Exception.CreateFmt('Invalid Security Type', []);
  end;
end;

end.
