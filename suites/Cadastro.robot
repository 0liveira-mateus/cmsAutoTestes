*** Settings ***
Library    SeleniumLibrary
Library    Collections

*** Variables ***
&{cadastro}
...    url=https://manual.biobots.com.br/login
...    cardLogin=//div[@class="card col-md-6 my-login-card"]
...    campoemail=//input[@type="text"]
...    camposenha=//input[@type="password"]
...    btnEntrar=//button[@id="btn-login"]
...    validacaoLogin=//div[@class="jconfirm-box jconfirm-hilight-shake jconfirm-type-red jconfirm-type-animated"]
...    menuUsuario=(//a[@class="nav-link "])[1]
...    btnNovoUsuario=//a[@class="btn btn-sm btn-success"]


*** Keywords ***

Dado um usuário realizando login no sistema 
    Open Browser    ${cadastro.url}    firefox

    ${visivel}    Run Keyword And Return Status    Wait Until Element Is Visible    ${cadastro.cardLogin}    2

    IF    ${visivel}
        Log To Console    1º Passo: Ok 
    ELSE
        Fail    1º Passo: Falhou - Página de Login não encontrada
    END

    &{fields}=    Create Dictionary
    ...    Campo de Email=${cadastro.campoemail}
    ...    Campo de Senha=${cadastro.camposenha}
    ...    Botão de Entrar=${cadastro.btnEntrar}
    
    
    @{Campos_Nao_Encontrados}=    Create List
    Sleep    2
    FOR    ${field}    IN    @{fields.keys()}
        ${Visible}    Run Keyword And Return Status    Element Should Be Visible   ${fields["${field}"]}
        IF    '${Visible}' == 'False'
            Append To List     ${Campos_Nao_Encontrados}    ${field}
        END
    END
    IF    ${Campos_Nao_Encontrados} != []
        Fail    1ºPasso: Falhou - O campos ${Campos_Nao_Encontrados} não foram encontrados
    ELSE
        Sleep    2
    END

    ${email}    Set Variable    admin@site.com    
    Input Text    ${cadastro.campoemail}    ${email}
    ${senha}    Set Variable    TBmerT6Sqc  
    Input Password    ${cadastro.camposenha}    ${senha}

    ${valorEmail}    Get Value    ${cadastro.campoemail}
    
    IF    $valorEmail == $email
        ${valorSenha}    Get Value    ${cadastro.camposenha}
        IF    $valorSenha == $senha
            Log To Console    2ºPasso: Ok 
        ELSE
            Fail    2ºPasso: Falhou - O campo de senha não foi preenchido corretamente e sim com o valor: ${valorSenha}  
        END
    ELSE
        Fail    2ºPasso: Falhou - O campo de email não foi preenchido corretamente e sim com o valor: ${valorEmail}  
    END

    Click Element    ${cadastro.btnEntrar}
    Log To Console    3ºPasso: Ok 

    ${tempoEspera}    Set Variable    6
    ${visivel}    Run Keyword And Return Status    Wait Until Element Is Not Visible    ${cadastro.cardLogin}    ${tempoEspera}

    IF    ${visivel}    
        Log To Console    4º Passo: Ok - Página inicial oculta como esperado.

    ELSE    
        Fail    4º Passo: Falhou - A página inicial de configuração do CMS ainda está visível após ${tempoEspera} segundos.
    END

E acessando o menu usuários
    ${Visible}    Run Keyword And Return Status    Element Should Be Visible    ${cadastro.menuUsuario}

    IF    $Visible
        Click Element    ${cadastro.menuUsuario}
    ELSE
        Fail    5º Passo: Menu usuários não foi visto 
    END

    ${visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${cadastro.btnNovoUsuario}    10

    IF    $visible
        Log To Console    5ºPasso: Ok 
        Close Browser
    ELSE
        Fail    5ºPasso: Falhou - O botão de cadastro de usuários não foi visto em tela 
    END
*** Test Cases ***
Cadastrar um usuário 
    Dado um usuário realizando login no sistema 
    E acessando o menu usuários 
## Cadastrar um usuário sem Nome
    