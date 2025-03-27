#ifndef __log_msg_instalacao_
#define __log_msg_instalacao_

[Code]
const
  FATAL_ERROR = 4;
  TAG_MSGINST = 'MSGINST';

procedure ExitProcessNow(exitCode:integer);
  external 'ExitProcess@kernel32.dll stdcall';

function ExecLogCwd(cmd, params, cwd: string): Integer;
begin
  Exec(cmd, params, cwd, SW_HIDE, ewWaitUntilTerminated, Result);
  Log(Format('RESULT CODE =%d "%s %s"', [Result, cmd, params]));
end;

{----------------------------------------------}
{Executa um comando e loga }
{----------------------------------------------}
function ExecLog(cmd, params: string): Integer;
begin
  Result := ExecLogCwd(cmd, params, '');
end;

{----------------------------------------------}
{Executa um comando e loga, alem de capturar o stdout em um arquivo de saida }
{----------------------------------------------}
function ExecLogWithStdout(cmd, params, cwd, stdout: string): Integer;
var
  scmd : string;
begin
  scmd := Format('/c ""%s" %s > "%s""', [cmd, params, stdout]);
  Exec(ExpandConstant('{cmd}'), scmd, cwd, SW_HIDE, ewWaitUntilTerminated, Result);
  Log(Format('RESULT CODE =%d "%s %s"', [Result, cmd, params]));
end;

{----------------------------------------------}
{ Procura uma mensagem de erro de instalacaoo em um arquivo }
{ Util para quando um instalador chama outro ou um programa usado em tempo de instalacao}
{----------------------------------------------}
function ObterMsgErroIntalacao(arquivo: string): string;
var
  MyFile : TStrings;
  MyText, tag: string;
  start, finish: Integer;
begin
  MyFile := TStringList.Create;
  Result := '';
  try
    try
      MyFile.LoadFromFile(arquivo);
      MyText := MyFile.Text;

      tag := Format('<%s>', [TAG_MSGINST]);
      start := Pos(tag, MyText);
      if start = 0 then
        Exit;
      start := start + Length(tag);

      tag := Format('</%s>', [TAG_MSGINST]);
      finish := Pos(tag, MyText);

      if finish < start then
        Exit;

      if finish > start then
        Result := Copy(MyText, start, finish - start);
    except
    end;
  finally
    MyFile.Free;
  end;
end;

{------------------------------------------------------------------------------}
function InstaladorSemInterface(): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i:= 0 to ParamCount do begin
    if (ParamStr(i) = '/SILENT') or (ParamStr(i) = '/VERYSILENT') then
    begin
      Result := True;
      break;
    end;
  end;
end;

{----------------------------------------------}
{ Grava uma mensagem de erro de instalacao para que o Launcher ou Master a exibam }
{ OBS: A mensagem somente sera procurada se a instalacao falhar - retorno diferente de zero }
{----------------------------------------------}
procedure MensagemLogInstalacao(mensagem: string);
begin
  Log(Format('<%s>%s</%s>', [TAG_MSGINST, mensagem, TAG_MSGINST]));
  if not InstaladorSemInterface() then
    MsgBox(mensagem, mbCriticalError, MB_OK);
end;

{----------------------------------------------}
{ Aborta com erro fatal (-4) }
{----------------------------------------------}
procedure AbortarComErroFatal();
begin
  ExitProcessNow(FATAL_ERROR);
end;

{----------------------------------------------}
{ Grava uma mensagem de erro de instalacao para que o Launcher ou Master a exibam e ABORTA }
{----------------------------------------------}
procedure AbortarInstalacao(mensagem: string);
begin
  MensagemLogInstalacao(mensagem);
  AbortarComErroFatal();
end;

function ObterPastaUnicaBackup(caminho: string): string;
begin
  repeat 
    Result := caminho + Format('bak%d', [Random(1000)]);
  until not DirExists(Result);
end;

{
Grava o Log e altera o status da tela de instalacao.
}
procedure LogStatus(msg: string);
begin
  Log(msg);
  WizardForm.StatusLabel.Caption := msg;
end;

const
  MAX_TENTATIVAS = 3;
  TEMPO_TENTATIVA = 5000;
function RenomearPastaComTentativas(pastaOrigem, pastaDestino, mensagem: string): Boolean;
var
  tentativas: Integer;
begin
  tentativas := 1;
  LogStatus(mensagem);
  Sleep(1000);
  repeat
    Result := RenameFile(pastaOrigem, pastaDestino);
    if Result or (tentativas >= MAX_TENTATIVAS) then
      break;
    tentativas := tentativas + 1;
    LogStatus(Format('%s: %d/%d', [mensagem, tentativas, MAX_TENTATIVAS]));
    Sleep(5000);
  until Result;
end;

#endif