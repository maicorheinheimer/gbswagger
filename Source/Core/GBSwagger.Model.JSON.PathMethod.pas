unit GBSwagger.Model.JSON.PathMethod;

{$IF DEFINED(FPC)}
{$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  {$IF DEFINED(FPC)}
  SysUtils,
  StrUtils,
  fpjson,
  {$ELSe}
  System.SysUtils,
  System.StrUtils,
  System.JSON,
  {$ENDIF}
  GBSwagger.Model.JSON.Interfaces,
  GBSwagger.Model.JSON.Utils,
  GBSwagger.Model.JSON.PathResponse,
  GBSwagger.Model.JSON.Parameter,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types;

type TGBSwaggerModelJSONPathMethod = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSwaggerPathMethod: IGBSwaggerPathMethod;

    function JSONSecurity  : TJSONArray;
    function JSONMethod    : TJSONObject;
    function JSONResponses : TJSONObject;
    function JSONParameters: TJSONArray;
    function JSONTags      : TJSONArray;
  public
    constructor create(SwaggerPathMethod: IGBSwaggerPathMethod);
    class function New(SwaggerPathMethod: IGBSwaggerPathMethod): IGBSwaggerModelJSON;

    function ToJSON: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF};
end;

implementation

{ TGBSwaggerModelJSONPathMethod }

constructor TGBSwaggerModelJSONPathMethod.create(SwaggerPathMethod: IGBSwaggerPathMethod);
begin
  FSwaggerPathMethod := SwaggerPathMethod;
end;

function TGBSwaggerModelJSONPathMethod.JSONMethod: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('tags', JSONTags);
  Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('summary', FSwaggerPathMethod.Summary);
  Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('description', FSwaggerPathMethod.Description);
  Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('consumes', TGBSwaggerModelJSONUtils.JSONContentTypes(FSwaggerPathMethod.Consumes));
  Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('produces', TGBSwaggerModelJSONUtils.JSONContentTypes(FSwaggerPathMethod.Produces));
  Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('parameters', JSONParameters);
  Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('responses', JSONResponses);
  Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('security', JSONSecurity);
end;

function TGBSwaggerModelJSONPathMethod.JSONParameters: TJSONArray;
var
  i: Integer;
begin
  result := TJSONArray.Create;
  for i := 0 to Pred(Length(FSwaggerPathMethod.Parameters)) do
    Result.{$IF DEFINED(FPC)}Add{$ELSE}AddElement{$ENDIF}(TGBSwaggerModelJSONParameter.New(FSwaggerPathMethod.Parameters[i]).ToJSON);
end;

function TGBSwaggerModelJSONPathMethod.JSONResponses: TJSONObject;
var
  i: Integer;
begin
  result := TJSONObject.Create;

  for i := 0 to Pred(Length(FSwaggerPathMethod.Responses)) do
    Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(FSwaggerPathMethod.Responses[i].HttpCode.ToString,
                   TGBSwaggerModelJSONPathResponse
                      .New(FSwaggerPathMethod.Responses[i])
                        .ToJSON);
end;

function TGBSwaggerModelJSONPathMethod.JSONSecurity: TJSONArray;
var
  i          : Integer;
  swagger    : IGBSwagger;
  securities : TArray<IGBSwaggerSecurity>;
begin
  result  := TJSONArray.Create;
  swagger := FSwaggerPathMethod.&End.&End;

  if (not FSwaggerPathMethod.IsPublic) and (Length(FSwaggerPathMethod.Securities) = 0)  then
  begin
    securities := swagger.Securities;
    for i := 0 to Pred(Length(securities)) do
    Result.Add(TJSONObject.Create.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(securities[i].Description, TJSONArray.Create));
  end
  else
  begin
    for i := 0 to Pred(Length(FSwaggerPathMethod.Securities)) do
      Result.Add(TJSONObject.Create.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(FSwaggerPathMethod.Securities[i], TJSONArray.Create));
  end;
end;

function TGBSwaggerModelJSONPathMethod.JSONTags: TJSONArray;
var
  i: Integer;
begin
  result := TJSONArray.Create;
  for i := 0 to Pred(Length(FSwaggerPathMethod.Tags)) do
    Result.Add(FSwaggerPathMethod.Tags[i]);
end;

class function TGBSwaggerModelJSONPathMethod.New(SwaggerPathMethod: IGBSwaggerPathMethod): IGBSwaggerModelJSON;
begin
  result := Self.create(SwaggerPathMethod);
end;

function TGBSwaggerModelJSONPathMethod.ToJSON: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF};
begin
  result := JSONMethod;

end;

end.
