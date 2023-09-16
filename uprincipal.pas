unit UPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, Forms, Controls, Graphics, Dialogs, ExtCtrls, Menus,
  ComCtrls, LCLType, StdCtrls, Translations, Buttons;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    mniRestricaoAcesso: TMenuItem;
    mniLogsSistema: TMenuItem;
    mniAuditoria: TMenuItem;
    mniPerfisAcesso: TMenuItem;
    mniRelatorios: TMenuItem;
    mniGerenFotos: TMenuItem;
    mniRegRefeicoesManual: TMenuItem;
    mniRegRefeicoesTerminal: TMenuItem;
    N9: TMenuItem;
    mniExportadorTemplates: TMenuItem;
    mniExportador: TMenuItem;
    N8: TMenuItem;
    mniCrachaTemplates: TMenuItem;
    mniCracha: TMenuItem;
    MenuItem2: TMenuItem;
    mniExpRegRefeicoes: TMenuItem;
    N7: TMenuItem;
    mniFuncoes: TMenuItem;
    mniSobre: TMenuItem;
    N6: TMenuItem;
    mniAjuda: TMenuItem;
    mniAjuda2: TMenuItem;
    N5: TMenuItem;
    mniImportadorTemplates: TMenuItem;
    mniImportador: TMenuItem;
    mniFerramentas: TMenuItem;
    mniTiposLogradouro: TMenuItem;
    mniCEP: TMenuItem;
    mniMunicipios: TMenuItem;
    mniEstados: TMenuItem;
    N4: TMenuItem;
    mniVinculos: TMenuItem;
    N3: TMenuItem;
    mniCadPessoas: TMenuItem;
    mniMotivosVisita: TMenuItem;
    mniCentrosCusto: TMenuItem;
    mniSetores: TMenuItem;
    mniEmpresas: TMenuItem;
    mniHorariosRefeicoes: TMenuItem;
    mniPessoas: TMenuItem;
    mniCadastros: TMenuItem;
    mniLibRefeitorio: TMenuItem;
    mniAlterarSenha: TMenuItem;
    mniUsuarios: TMenuItem;
    N2: TMenuItem;
    mniRegRefeicoes: TMenuItem;
    mniControleAcesso: TMenuItem;
    mniRefeitorio: TMenuItem;
    mniPortaria: TMenuItem;
    mniSair: TMenuItem;
    mniLogoff: TMenuItem;
    mniSeguranca: TMenuItem;
    N1: TMenuItem;
    mniConfiguracoes: TMenuItem;
    mniSistema: TMenuItem;
    mmnMenu: TMainMenu;
    PageControl: TPageControl;
    pnlComandos: TPanel;
    StatusBar: TStatusBar;
    tsInicio: TTabSheet;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mniAjuda2Click(Sender: TObject);
    procedure mniAlterarSenhaClick(Sender: TObject);
    procedure mniCadPessoasClick(Sender: TObject);
    procedure mniGerenFotosClick(Sender: TObject);
    procedure mniLogsSistemaClick(Sender: TObject);
    procedure mniPerfisAcessoClick(Sender: TObject);
    procedure mniRestricaoAcessoClick(Sender: TObject);
    procedure mniVinculosClick(Sender: TObject);
    procedure mniHorariosRefeicoesClick(Sender: TObject);
    procedure mniLibRefeitorioClick(Sender: TObject);
    procedure mniLogoffClick(Sender: TObject);
    procedure mniRegRefeicoesTerminalClick(Sender: TObject);
    procedure mniSairClick(Sender: TObject);
    procedure mniSobreClick(Sender: TObject);
    procedure mniTerceirosClick(Sender: TObject);
    procedure mniUsuariosClick(Sender: TObject);
    procedure mniVisitantesClick(Sender: TObject);
    procedure PageControlDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure PageControlDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure PageControlMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PageControlMouseLeave(Sender: TObject);
    procedure PageControlMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PageControlMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private

  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
UGFunc, UConexao, UDBO, ULogin, UUsuarios, UAlterarSenha, URegRefeicoes, URefeicoes,
UCadHorariosRefeicoes, UCadPessoas, UVinculosPessoas, UGerencFotos, ExpertTabSheet,
URegLogsSistema, uBtnTabSheet, URestricaoAcesso, UPerfisUsuarios;

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.mniLogoffClick(Sender: TObject);
begin
  Logoff(frmLogin,dmConexao.ConexaoDB, dmConexao.SQLDBLibraryLoader);
end;

procedure TfrmPrincipal.mniRegRefeicoesTerminalClick(Sender: TObject);
begin
  OpenForm(TfrmRegRefeicoes, 'FullScreen');
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  AppTerminate;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  //RegisterClasses([TfrmVinculos]);
end;

procedure TfrmPrincipal.FormPaint(Sender: TObject);
begin
  if CheckPermission(UserPermissions,'SEGURANCA','SEGUSCAD') then
    mniUsuarios.Enabled := True
  else
    mniUsuarios.Enabled := False;

  if CheckPermission(UserPermissions,'SEGURANCA','SEGPUCAD') then
    mniPerfisAcesso.Enabled := True
  else
    mniPerfisAcesso.Enabled := False;

  if CheckPermission(UserPermissions,'AUDITORIA','ADTLSACS') then
    mniLogsSistema.Enabled := True
  else
    mniLogsSistema.Enabled := False;

  if CheckPermission(UserPermissions,'CONFIGS','CONFACES') then
    mniConfiguracoes.Enabled := True
  else
    mniConfiguracoes.Enabled := False;

  if CheckPermission(UserPermissions,'PORTARIA','PORTACES') then
    mniPortaria.Enabled := True
  else
    mniPortaria.Enabled := False;

  if CheckPermission(UserPermissions,'PORTARIA','PRTCTACS') then
    mniControleAcesso.Enabled := True
  else
    mniControleAcesso.Enabled := False;

  if CheckPermission(UserPermissions,'REFEITORIO','REFACES') then
    mniRefeitorio.Enabled := True
  else
    mniRefeitorio.Enabled := False;

  if CheckPermission(UserPermissions,'REFEITORIO','REFRGACS') then
    mniRegRefeicoes.Enabled := True
  else
    mniRegRefeicoes.Enabled := False;

  if CheckPermission(UserPermissions,'REFEITORIO','REFRGTER') then
    mniRegRefeicoesTerminal.Enabled := True
  else
    mniRegRefeicoesTerminal.Enabled := False;

  if CheckPermission(UserPermissions,'REFEITORIO','REFRGMAN') then
    mniRegRefeicoesManual.Enabled := True
  else
    mniRegRefeicoesManual.Enabled := False;

  if CheckPermission(UserPermissions,'CADASTROS','CADHRCAD') then
    mniHorariosRefeicoes.Enabled := True
  else
    mniHorariosRefeicoes.Enabled := False;

  if CheckPermission(UserPermissions,'REFEITORIO','REFPRACS') then
    mniLibRefeitorio.Enabled := True
  else
    mniLibRefeitorio.Enabled := False;

  if CheckPermission(UserPermissions,'REFEITORIO','REFRGEXP') then
    mniExpRegRefeicoes.Enabled := True
  else
    mniExpRegRefeicoes.Enabled := False;

  if CheckPermission(UserPermissions,'CADASTROS','CADACES') then
    mniCadastros.Enabled := True
  else
    mniCadastros.Enabled := False;

  if CheckPermission(UserPermissions,'CADASTROS','CADPSCAD') then
    mniPessoas.Enabled := True
  else
    mniPessoas.Enabled := False;

  if CheckPermission(UserPermissions,'CADASTROS','CADPSCAD') then
    mniCadPessoas.Enabled := True
  else
    mniCadPessoas.Enabled := False;

  if CheckPermission(UserPermissions,'CADASTROS','CADFTCAD') then
    mniGerenFotos.Enabled := True
  else
    mniGerenFotos.Enabled := False;

  if (CheckPermission(UserPermissions,'CADASTROS','CADFUCAD')
    or CheckPermission(UserPermissions,'CADASTROS','CADTCCAD')
    or CheckPermission(UserPermissions,'CADASTROS','CADVSCAD'))  then
    mniVinculos.Enabled := True
  else
    mniVinculos.Enabled := False;

 if CheckPermission(UserPermissions,'CADASTROS','CADHRCAD') then
    mniHorariosRefeicoes.Enabled := True
  else
    mniHorariosRefeicoes.Enabled := False;

 if CheckPermission(UserPermissions,'CADASTROS','CADEMCAD') then
    mniEmpresas.Enabled := True
  else
    mniEmpresas.Enabled := False;

 if CheckPermission(UserPermissions,'CADASTROS','CADSTCAD') then
    mniSetores.Enabled := True
  else
    mniSetores.Enabled := False;

 if CheckPermission(UserPermissions,'CADASTROS','CADFNCAD') then
    mniFuncoes.Enabled := True
  else
    mniFuncoes.Enabled := False;

 if CheckPermission(UserPermissions,'CADASTROS','CADCCCAD') then
    mniCentrosCusto.Enabled := True
  else
    mniCentrosCusto.Enabled := False;

 if CheckPermission(UserPermissions,'CADASTROS','CADMVCAD') then
    mniMotivosVisita.Enabled := True
  else
    mniMotivosVisita.Enabled := False;

 if CheckPermission(UserPermissions,'CADASTROS','CADETCAD') then
    mniEstados.Enabled := True
  else
    mniEstados.Enabled := False;

 if CheckPermission(UserPermissions,'CADASTROS','CADMNCAD') then
    mniMunicipios.Enabled := True
  else
    mniMunicipios.Enabled := False;

 if CheckPermission(UserPermissions,'CADASTROS','CADCPCAD') then
    mniCEP.Enabled := True
  else
    mniCEP.Enabled := False;

 if CheckPermission(UserPermissions,'CADASTROS','CADTLCAD') then
    mniTiposLogradouro.Enabled := True
  else
    mniTiposLogradouro.Enabled := False;

 if CheckPermission(UserPermissions,'FERRAMENTAS','FERACES') then
    mniFerramentas.Enabled := True
  else
    mniFerramentas.Enabled := False;

 if CheckPermission(UserPermissions,'FERRAMENTAS','FERIPACS') then
    mniImportador.Enabled := True
  else
    mniImportador.Enabled := False;

 if CheckPermission(UserPermissions,'FERRAMENTAS','FERIPTPT') then
    mniImportadorTemplates.Enabled := True
  else
    mniImportadorTemplates.Enabled := False;

 if CheckPermission(UserPermissions,'FERRAMENTAS','FEREPACS') then
    mniExportador.Enabled := True
  else
    mniExportador.Enabled := False;

 if CheckPermission(UserPermissions,'FERRAMENTAS','FEREPTPT') then
    mniExportadorTemplates.Enabled := True
  else
    mniExportadorTemplates.Enabled := False;

 if CheckPermission(UserPermissions,'FERRAMENTAS','FERCHACS') then
    mniCracha.Enabled := True
  else
    mniCracha.Enabled := False;

 if CheckPermission(UserPermissions,'FERRAMENTAS','FERCHTPT') then
    mniCrachaTemplates.Enabled := True
  else
    mniCrachaTemplates.Enabled := False;

 StatusBar.Panels[0].Text := UpperCase(dmConexao.ConexaoDB.DatabaseName);
 StatusBar.Panels[1].Text := UpperCase(gUsuario_Logado);
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  FixPageControlColor(PageControl);
end;

procedure TfrmPrincipal.mniAjuda2Click(Sender: TObject);
begin
  Application.MessageBox(PChar('Em desenvolvimento'+#13#13+'Em breve você poderá acessar esta funcionalidade'),'Aviso', MB_ICONINFORMATION + MB_OK);
end;

procedure TfrmPrincipal.mniAlterarSenhaClick(Sender: TObject);
begin
  gModAltSenha := 'ALTSENHALAYOUT1';
  OpenForm(TfrmAlterarSenha,'Modal');
end;

procedure TfrmPrincipal.mniCadPessoasClick(Sender: TObject);
begin
  //OpenForm(TfrmCadPessoas,'Modal');
  frmCadPessoas := TfrmCadPessoas.Create(Self);
  OpenWindowTab(PageControl,frmCadPessoas,[]);
end;

procedure TfrmPrincipal.mniGerenFotosClick(Sender: TObject);
begin
  frmGerencFotos := TfrmGerencFotos.Create(Self);
  OpenWindowTab(PageControl,frmGerencFotos,[]);
end;

procedure TfrmPrincipal.mniLogsSistemaClick(Sender: TObject);
begin
  frmRegLogsSistema := TfrmRegLogsSistema.Create(Self);
  OpenWindowTab(PageControl,frmRegLogsSistema,['MultiTab: True','TabTitle: Logs','Title: Registros de Logs do sistema']);
end;

procedure TfrmPrincipal.mniPerfisAcessoClick(Sender: TObject);
begin
  frmPerfisUsuarios := TfrmPerfisUsuarios.Create(Self);
  OpenWindowTab(PageControl,frmPerfisUsuarios,['MultiTab: False','TabTitle: Perfis de usuários','Title: Perfis de usuários']);
end;

procedure TfrmPrincipal.mniRestricaoAcessoClick(Sender: TObject);
begin
  frmRestricaoAcesso := TfrmRestricaoAcesso.Create(Self);
  OpenWindowTab(PageControl,frmRestricaoAcesso,['MultiTab: True','TabTitle: Restrições','Title: Gerenciar restrições de acesso de pessoas']);
end;

procedure TfrmPrincipal.mniVinculosClick(Sender: TObject);
begin
 gID_Pessoa := EmptyStr;
 //OpenForm(TfrmVinculos,'Modal');
 frmVinculos := TfrmVinculos.Create(Self);
 //frmVinculos.ShowModal;
 OpenWindowTab(PageControl,frmVinculos,[]);
end;

procedure TfrmPrincipal.mniHorariosRefeicoesClick(Sender: TObject);
begin
  //OpenForm(TfrmCadHorariosRefeicoes,'Modal');
 frmCadHorariosRefeicoes := TfrmCadHorariosRefeicoes.Create(Self);
 OpenWindowTab(PageControl,frmCadHorariosRefeicoes,[]);
end;

procedure TfrmPrincipal.mniLibRefeitorioClick(Sender: TObject);
begin
 //OpenForm(TfrmRefeicoes,'Modal');
 frmRefeicoes := TfrmRefeicoes.Create(Self);
 OpenWindowTab(PageControl,frmRefeicoes,[]);
end;


procedure TfrmPrincipal.mniSairClick(Sender: TObject);
begin
  AppTerminate;
end;

procedure TfrmPrincipal.mniSobreClick(Sender: TObject);
begin
  Application.MessageBox(PChar('Em desenvolvimento'+#13#13+'Em breve você poderá acessar esta funcionalidade'),'Aviso', MB_ICONINFORMATION + MB_OK);
end;

procedure TfrmPrincipal.mniTerceirosClick(Sender: TObject);
begin
  gID_Pessoa := EmptyStr;
  gTipo_Vinculo := 'T';
 //OpenForm(TfrmVinculos,'Modal');
 //frmVinculos := TfrmVinculos.Create(Self);
 //frmVinculos.ShowModal;
 //OpenWindowTab(PageControl,frmVinculos,False);
end;

procedure TfrmPrincipal.mniUsuariosClick(Sender: TObject);
begin
  //OpenForm(TfrmUsuarios, 'Modal');
  frmUsuarios := TfrmUsuarios.Create(Self);
  OpenWindowTab(PageControl, frmUsuarios, []);
end;

procedure TfrmPrincipal.mniVisitantesClick(Sender: TObject);
begin
  gID_Pessoa := EmptyStr;
 gTipo_Vinculo := 'V';
 //OpenForm(TfrmVinculos,'Modal');
 frmVinculos := TfrmVinculos.Create(Self);
 frmVinculos.ShowModal;
end;

procedure TfrmPrincipal.PageControlDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  {Incluir este código - não precisa ajustar nada}
  //TabDragDrop(Sender, X, Y);
end;

procedure TfrmPrincipal.PageControlDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  {Incluir este código - não precisa ajustar nada}
  //TabDragOver(Sender, Accept);
end;

procedure TfrmPrincipal.PageControlMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {Incluir este código - não precisa ajustar nada}
  //BtnCloseTabMouseDown(Sender, Button, X, Y);
end;

procedure TfrmPrincipal.PageControlMouseLeave(Sender: TObject);
begin
   {Incluir este código - não precisa ajustar nada}
  //BtnCloseTabMouseLeave(Sender, FCloseButtonShowPushed);
end;

procedure TfrmPrincipal.PageControlMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  {Incluir este código - não precisa ajustar nada}
  //BtnCloseTabMouseMove(Sender, Shift, X, Y, FCloseButtonMouseDownTab, FCloseButtonShowPushed)
end;

procedure TfrmPrincipal.PageControlMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {Incluir este código - não precisa ajustar nada}
  //BtnCloseTabMouseUp(Sender, Button, X, Y, FCloseButtonMouseDownTab);
end;

end.

