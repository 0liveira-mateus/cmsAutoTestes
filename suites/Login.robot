*** Settings ***
Library    SeleniumLibrary
Library    Collections

*** Variables ***
&{login}
...    url=https://manual.biobots.com.br/login
...    cardLogin=//div[@class="card col-md-6 my-login-card"]
...    campoemail=//input[@type="text"]
...    camposenha=//input[@type="password"]
...    btnEntrar=//button[@id="btn-login"]
...    validacaoLogin=//div[@class="jconfirm-box jconfirm-hilight-shake jconfirm-type-red jconfirm-type-animated"]


*** Keywords ***

## Logando - Sucesso 
Dado um usuário Acessando a página de login do CMS
    Open Browser    ${login.url}    Firefox

    ${visivel}    Run Keyword And Return Status    Wait Until Element Is Visible    ${login.cardLogin}    2

    IF    ${visivel}
        Log To Console    1º Passo: Ok 
    ELSE
        Fail    1º Passo: Falhou - Página de Login não encontrada
    END

    &{fields}=    Create Dictionary
    ...    Campo de Email=${login.campoemail}
    ...    Campo de Senha=${login.camposenha}
    ...    Botão de Entrar=${login.btnEntrar}
    
    
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

E preenchendo os campos de email e senha 
    ${email}    Set Variable    admin@site.com    
    Input Text    ${login.campoemail}    ${email}
    ${senha}    Set Variable    TBmerT6Sqc  
    Input Password    ${login.camposenha}    ${senha}

    ${valorEmail}    Get Value    ${login.campoemail}
    
    IF    $valorEmail == $email
        ${valorSenha}    Get Value    ${login.camposenha}
        IF    $valorSenha == $senha
            Log To Console    2ºPasso: Ok 
        ELSE
            Fail    2ºPasso: Falhou - O campo de senha não foi preenchido corretamente e sim com o valor: ${valorSenha}  
        END
    ELSE
        Fail    2ºPasso: Falhou - O campo de email não foi preenchido corretamente e sim com o valor: ${valorEmail}  
    END
Quando ele Clicar no botão de Entrar
    Click Element    ${login.btnEntrar}
    Log To Console    3ºPasso: Ok 

Então ele terá finalizado o login com sucesso 
    ${tempoEspera}    Set Variable    6
    ${visivel}    Run Keyword And Return Status    Wait Until Element Is Not Visible    ${login.cardLogin}    ${tempoEspera}

    IF    ${visivel}    
        Log To Console    4º Passo: Ok - Página inicial oculta como esperado.
        Close Browser
    ELSE    
        Fail    4º Passo: Falhou - A página inicial de configuração do CMS ainda está visível após ${tempoEspera} segundos.
    END

## Logando Sem Senha 
E preenchendo apenas o campo de e-mail
    ${email}    Set Variable    admin@site.com    
    Input Text    ${login.campoemail}    ${email}

    ${valorEmail}    Get Value    ${login.campoemail}
    
    IF    $valorEmail == $email
        Log To Console    3ºPasso: Ok 
    ELSE
        Fail    3ºPasso: Falhou - O campo de email não foi preenchido corretamente e sim com o valor: ${valorEmail}  
    END
Então ele deverá ter seu login impedido pela falta de preenchimento de e-mail ou senha 
    ${tempoEspera}    Set Variable    6
    ${visivel}    Run Keyword And Return Status    Wait Until Element Is Visible    ${login.validacaoLogin}    ${tempoEspera}

    IF    ${visivel}    
        Log To Console    4º Passo: Ok - mensagem de validação de e-mail e senha mostrada com sucesso 
        Close Browser
    ELSE    
        Fail    4º Passo: Falhou - A mensagem de validação de e-mail e senha não foi vista em ${tempoEspera} segundos
    END
## Logando Sem Email 
E preenchendo apenas o campo de senha
    ${senha}    Set Variable    TBmerT6Sqc  
    Input Password    ${login.camposenha}    ${senha}
    
    ${valorSenha}    Get Value    ${login.camposenha}
    IF    $valorSenha == $senha
        Log To Console    2ºPasso: Ok 
    ELSE
        Fail    2ºPasso: Falhou - O campo de senha não foi preenchido corretamente e sim com o valor: ${valorSenha}  
    END
*** Test Cases ***
Logando - Sucesso 
    Dado um usuário Acessando a página de login do CMS
    E preenchendo os campos de email e senha 
    Quando ele Clicar no botão de Entrar
    Então ele terá finalizado o login com sucesso 
Logando Sem Senha 
    Dado um usuário Acessando a página de login do CMS
    E preenchendo apenas o campo de e-mail 
    Quando ele Clicar no botão de Entrar
    Então ele deverá ter seu login impedido pela falta de preenchimento de e-mail ou senha 
Logando Sem E-mail 
    Dado um usuário Acessando a página de login do CMS
    E preenchendo apenas o campo de senha
    Quando ele Clicar no botão de Entrar
    Então ele deverá ter seu login impedido pela falta de preenchimento de e-mail ou senha 