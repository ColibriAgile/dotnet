[Code]
procedure InstalarDotnet(app: string);
var
  ResultCode: integer;
  msg: string;
  logfile: string;
begin
  logfile := ExpandConstant('{log}');
  
  if Length(logfile) = 0 then
    logfile := ExpandConstant(Format('{tmp}\setup-%s.log', [app]))
  else
    logfile := ExtractFilePath(logfile) + Format('{tmp}\setup-%s.log', [app]);

  Exec
  (
    ExpandConstant('{tmp}\'+app), 
    Format('/q /norestart /log "%s"', [logfile]), 
    '', 
    SW_HIDE, 
    ewWaitUntilTerminated, 
    ResultCode
  );

  if ResultCode = 0 then
    Log(Format('%s instalado com sucesso', [app]))

  else if (ResultCode in [1603, 1638]) then 
    Log(Format('A instalação de %s não foi necessária pois uma versão superior do componente já está instalada. (%d)', [app, ResultCode]))

  else begin
    case ResultCode of
      1602: msg := Format('Instalação de %s cancelada pelo usuário. (1602)', [app]);
      1641, 
      3010: msg := Format('É necessário reiniciar o computador para completar a instalação de %s. (%d)', [app, ResultCode]);
      5100: msg := Format('O computador não possui os requisitos necessários para a instalação de %s. (5100)', [app]);
    else
      msg := Format('A instalação de %s falhou com o erro %d. Procure este erro no Google para mais informações.', [app, ResultCode]);
    end;
    
    AbortarInstalacao(msg);
  end;
end;
