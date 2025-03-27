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
    Log(Format('A instala��o de %s n�o foi necess�ria pois uma vers�o superior do componente j� est� instalada. (%d)', [app, ResultCode]))

  else begin
    case ResultCode of
      1602: msg := Format('Instala��o de %s cancelada pelo usu�rio. (1602)', [app]);
      1641, 
      3010: msg := Format('� necess�rio reiniciar o computador para completar a instala��o de %s. (%d)', [app, ResultCode]);
      5100: msg := Format('O computador n�o possui os requisitos necess�rios para a instala��o de %s. (5100)', [app]);
    else
      msg := Format('A instala��o de %s falhou com o erro %d. Procure este erro no Google para mais informa��es.', [app, ResultCode]);
    end;
    
    AbortarInstalacao(msg);
  end;
end;
