unit GBSwagger.Model.JSON.Contact;

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
  GBSwagger.Model.JSON.Interfaces,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types;

type TGBSwaggerModelJSONContact = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSwaggerContact: IGBSwaggerContact;

  public
    constructor create(SwaggerContact: IGBSwaggerContact);
    class function New(SwaggerContact: IGBSwaggerContact): IGBSwaggerModelJSON;

    function ToJSON: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF};
end;

implementation

{ TGBSwaggerModelJSONContact }

constructor TGBSwaggerModelJSONContact.create(SwaggerContact: IGBSwaggerContact);
begin
  FSwaggerContact := SwaggerContact;
end;

class function TGBSwaggerModelJSONContact.New(SwaggerContact: IGBSwaggerContact): IGBSwaggerModelJSON;
begin
  result := Self.create(SwaggerContact);
end;

function TGBSwaggerModelJSONContact.ToJSON: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF};
var
  LJSON: TJSONObject;
begin
  LJSON := TJSONObject.Create;

  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('name', FSwaggerContact.Name);
  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('email', FSwaggerContact.Email);
  LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('url', FSwaggerContact.URL);

  Result := LJSON;
end;

end.
