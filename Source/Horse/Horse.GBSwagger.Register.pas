unit Horse.GBSwagger.Register;

{$IF DEFINED(FPC)}
{$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  {$IF DEFINED(FPC)}
  Rtti,
  StrUtils,
  SysUtils,
  Classes,
  {$ELSE}
  System.Rtti,
  System.StrUtils,
  System.SysUtils,
  System.Classes,
  {$ENDIF}
  Horse,
  GBSwagger.Model.Interfaces,
  GBSwagger.Path.Attributes,
  GBSwagger.Path.Register,
  GBSwagger.RTTI;

type THorseGBSwaggerRegister = class(TGBSwaggerPathRegister)

  private
    class procedure RegisterMethods(AClass: TClass; APath: SwagPath);
    class procedure RegisterMethod (AClass: TClass; AMethod: TRttiMethod);

  public
    class procedure RegisterPath(AClass: TClass); override;

end;

function HorseCallback(AClass: TClass; AMethod: TRttiMethod): THorseCallback;

implementation

function HorseCallback(AClass: TClass; AMethod: TRttiMethod): THorseCallback;
begin
  //result :=
    //procedure (Req: THorseRequest; Res: THorseResponse; Next: TProc)
    //var
    //  constructMethod : TRttiMethod;
    //  instance        : TObject;
    //  args            : array of TValue;
    //
      //procedure raiseConstructorException;
      //begin
      //  raise EMethodNotFound.CreateFmt('You must implemented constructor method ' +
      //                                  'create(Req: THorseRequest; Res: THorseResponse) ' +
      //                                  'in %s class', [AClass.ClassName]);
      //end;

    //begin
    //  constructMethod := TGBSwaggerRTTI.GetInstance.GetType(AClass)
    //                        .GetMethod('create');
    //
    //  if Assigned(constructMethod) then
    //  begin
    //    if Length( constructMethod.GetParameters ) <> 2 then
    //      raiseConstructorException;
    //
    //    if not constructMethod.GetParameters[0]
    //          .ParamType.TypeName.ToLower.Equals('thorserequest')
    //    then
    //      raiseConstructorException;
    //
    //    if not constructMethod.GetParameters[1]
    //          .ParamType.TypeName.ToLower.Equals('thorseresponse')
    //    then
    //      raiseConstructorException;
    //
    //    setLength(args, 2);
    //    args[0] := TValue.From<THorseRequest>(Req);
    //    args[1] := TValue.From<THorseResponse>(Res);
    //
    //    instance := constructMethod.Invoke(AClass, args).AsObject;
    //    try
    //      AMethod.Invoke(instance, []);
    //    finally
    //      if not instance.InheritsFrom(TInterfacedObject) then
    //        instance.Free;
    //    end;
    //  end
    //end;


end;

{ THorseGBSwaggerRegister }

class procedure THorseGBSwaggerRegister.RegisterMethod(AClass: TClass; AMethod: TRttiMethod);
var
  pathAttr   : SwagPath;
  endpoint   : SwagEndPoint;
  path       : string;
  pathName   : string;
  basePath   : string;
begin
  pathAttr := AClass.GetSwagPath;
  endpoint := AMethod.GetSwagEndPoint;
  pathName := IfThen(pathAttr.name.IsEmpty, AClass.ClassName, pathAttr.name);
  basePath := Swagger.BasePath.Replace(Swagger.Config.ModuleName, EmptyStr);
  if (not basePath.IsEmpty) and (not basePath.EndsWith('/')) then
    basePath := basePath + '/';

  path := (basePath + pathName + '/' + endpoint.path);
  path := path.Replace('//', '/');
  path := path.Replace('{', ':');
  path := path.Replace('}', '');

  if endpoint is SwagGET then
    THorse.GetInstance.Get(path, HorseCallback(AClass, AMethod))
  else
  if endpoint is SwagPOST then
    THorse.GetInstance.Post(path, HorseCallback(AClass, AMethod))
  else
  if endpoint is SwagPUT then
    THorse.GetInstance.Put(path, HorseCallback(AClass, AMethod))
  else
  if endpoint is SwagDELETE then
    THorse.GetInstance.Delete(path, HorseCallback(AClass, AMethod))
  else
    raise ENotImplemented.CreateFmt('Verbo http n�o implementado.', []);
end;

class procedure THorseGBSwaggerRegister.RegisterMethods(AClass: TClass; APath: SwagPath);
var
  i, j    : Integer;
  methods : TArray<TRttiMethod>;
begin
  methods := AClass.GetMethods;
  for i := 0 to Pred(Length(methods)) do
  begin
    for j := 0 to Pred(Length(methods[i].GetAttributes)) do
    begin
      if methods[i].GetAttributes[j].InheritsFrom(SwagEndPoint) then
        RegisterMethod(AClass, methods[i]);
    end;
  end;
end;

class procedure THorseGBSwaggerRegister.RegisterPath(AClass: TClass);
var
  path : SwagPath;
begin
  inherited;
  path := AClass.GetSwagPath;

  if Assigned(path) then
    RegisterMethods(AClass, path);
end;

end.
