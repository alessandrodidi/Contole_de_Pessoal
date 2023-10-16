program ControlePessoal;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, lazcontrols, runtimetypeinfocontrols, UPrincipal, ULogin, UGFunc,
  UINIFiles, UDBO, UConexao, UUsuarios, UAlterarSenha, URegRefeicoes,
  URefeicoes, UCadPessoas, UVinculosPessoas, UGerencFotos, UPesquisar,
  ExpertTabSheet, URegLogsSistema, uBtnTabSheet, UFiltros, UEditorCadFiltros,
  URestricaoAcesso, UEditorFiltros, UExecutaFiltro, UPerfisUsuarios,
UCopiarPermissoes, UConfiguracoes;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TdmConexao, dmConexao);
  Application.CreateForm(TfrmLogin, frmLogin);
  Launch;
  Application.CreateForm(TfrmConfiguracoes, frmConfiguracoes);
  //Application.CreateForm(TfrmCopiarPermissoes, frmCopiarPermissoes);
  //Application.CreateForm(TfrmPerfisUsuarios, frmPerfisUsuarios);
  //Application.CreateForm(TfrmEditorFiltros, frmEditorFiltros);
  //Application.CreateForm(TfrmExecutaFiltro, frmCriteriosFiltroDin);
  //Application.CreateForm(TfrmRestricaoAcesso, frmRestricaoAcesso);
  //Application.CreateForm(TfrmEditorFiltros, frmEditorFiltros);
  //Application.CreateForm(TfrmRegLogsSistema, frmRegLogsSistema);
  //Application.CreateForm(TfrmFiltros, frmFiltros);
  //Application.CreateForm(TfrmPesquisar, frmPesquisar);
  //Application.CreateForm(TfrmGerencFotos, frmGerencFotos);
  //Application.CreateForm(TfrmVinculos, frmVinculos);
  //Application.CreateForm(TfrmUsuarios, frmUsuarios);
  //Application.CreateForm(TfrmAlterarSenha, frmAlterarSenha);
  //Application.CreateForm(TfrmCadPessoas, frmCadPessoas);
  //Application.CreateForm(TfrmRefeicoes, frmRefeicoes);
  //Application.CreateForm(TfrmRegRefeicoes, frmRegRefeicoes);
  Application.Run;
end.

