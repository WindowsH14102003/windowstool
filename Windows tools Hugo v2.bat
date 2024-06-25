@echo off

:: On execute les commandes en administrateur

REM –> Verification des permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM –> Erreur vous ne possedez pas les droits admin
if '%errorlevel%' NEQ '0' (
    echo Verification des privileges administrateur
    goto UACPrompt
) else (goto gotAdmin)

:UACPrompt
echo Set UAC = CreateObject("Shell.Application") > "%temp%\getadmin.vbs"
set params = %*: = %
echo UAC.ShellExecute "%~s0", "%params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

"%temp%\getadmin.vbs"
exit /B

:gotAdmin
if exist "%temp%\getadmin.vbs" (del "%temp%\getadmin.vbs")
pushd "%CD%"
CD /D "%~dp0"

setlocal
:: Ecran de demarrage
cls
echo.
echo.
echo.
echo #############################################################
echo #                                                           #
echo #  Ce programme a ete cree par Hugo                         #
echo #  Toutes les erreurs ou problemes sont a prendre en charge #
echo #  par l'utilisateur.                                       #
echo #                                                           #
echo #############################################################
echo.
echo.
pause

::...

:main_menu
cls
echo ============================================================
echo Choisissez une option :
echo 1. Activer Windows
echo 2. Voir les specifications de l'ordinateur
echo 3. Telecharger et installer Ninite
echo 4. Verifier les mises a jour de Windows
echo 5. Telecharger et installer Office 2021 Pro Plus
echo 6. Activer Office 2021
echo 7. Transformer le compte en administrateur
echo 8. Retirer le mot de passe de Windows
echo 9. Quitter
echo ============================================================
set /p choix="Entrez le numero de votre choix : "

if "%choix%"=="1" (
    call :activate_windows
) else if "%choix%"=="2" (
    call :view_specs
) else if "%choix%"=="3" (
    call :download_ninite
) else if "%choix%"=="4" (
    call :check_windows_update
) else if "%choix%"=="5" (
    call :download_install_office
) else if "%choix%"=="6" (
    call :activate_office
) else if "%choix%"=="7" (
    call :transform_account_admin
) else if "%choix%"=="8" (
    call :remove_windows_password
) else if "%choix%"=="9" (
    goto :end
) else (
    echo Choix invalide. Veuillez entrer un numero valide.
    pause
    goto :main_menu
)

::...

echo ============================================================
echo                    Activation de Windows
echo ============================================================

:: Afficher l'edition actuelle de Windows
echo Edition actuelle de Windows :
for /f "tokens=2 delims==" %%a in ('wmic os get Caption /value') do echo %%a
echo ============================================================

:: Afficher les options de licence
echo ============================================================
echo Choisissez une licence :
echo 1. Home: TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
echo 2. Home N: 3KHY7-WNT83-DGQKR-F7HPR-844BM
echo 3. Home Single Language: 7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH
echo 4. Home Country Specific: PVMJN-6DFY6-9CCP6-7BKTT-D3WVR
echo 5. Professional: W269N-WFGWX-YVC9B-4J6C9-T83GX
echo 6. Professional N: MH37W-N47XK-V7XM9-C7227-GCQG9
echo 7. Education: NW6C2-QMPVW-D7KKK-3GKT6-VCFB2
echo 8. Education N: 2WH4N-8QGBV-H22JP-CT43Q-MDWWJ
echo 9. Enterprise: NPPR9-FWDCX-D2C8J-H872K-2YT43
echo 10. Enterprise N: DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4
echo ============================================================
set /p licence="Entrez le numero de la licence desiree : "

:: Verifier si le numero de licence estvalide
set valid_licence=0
for /l %%i in (1, 1, 10) do (
    if "%licence%"=="%%i" (
        set valid_licence=1
    )
)

if %valid_licence%==0 (
    echo Numero de licence invalide. Veuillez choisir un numero valide.
    pause
    goto :activate_windows
)

:: Definir la cle de licence en fonction du choix de l'utilisateur
set "cle="
if "%licence%"=="1" set cle=TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
if "%licence%"=="2" set cle=3KHY7-WNT83-DGQKR-F7HPR-844BM
if "%licence%"=="3" set cle=7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH
if "%licence%"=="4" set cle=PVMJN-6DFY6-9CCP6-7BKTT-D3WVR
if "%licence%"=="5" set cle=W269N-WFGWX-YVC9B-4J6C9-T83GX
if "%licence%"=="6" set cle=MH37W-N47XK-V7XM9-C7227-GCQG9
if "%licence%"=="7" set cle=NW6C2-QMPVW-D7KKK-3GKT6-VCFB2
if "%licence%"=="8" set cle=2WH4N-8QGBV-H22JP-CT43Q-MDWWJ
if "%licence%"=="9" set cle=NPPR9-FWDCX-D2C8J-H872K-2YT43
if "%licence%"=="10" set cle=DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4

:: Verifier si la cle de licence a ete definie
if not defined cle (
    echo Une erreur s'est produite lors de la selection de la licence.
    pause
    goto :main_menu
)

:: Activer la licence
slmgr /ipk %cle% && slmgr /skms zh.us.to && slmgr /ato

echo.
echo Votre cle a bien ete activee avec succes.
pause

:activate_windows_return
cls
echo ============================================================
echo 1. Retour au menu principal
echo 2. Quitter
echo ============================================================
set /p retour="Entrez le numero de votre choix : "
if "%retour%"=="1" (
    goto :main_menu
) else if "%retour%"=="2" (
    goto :end
) else (
    echo Choix invalide. Veuillez entrer un numero valide.
    pause
    goto :activate_windows_return
)

:view_specs
cls
echo ============================================================
echo                Specifications de l'ordinateur
echo ============================================================
echo.

echo Processeur :
for /f "tokens=2 delims==" %%a in ('wmic cpu get Name /value') do echo %%a
for /f "tokens=2 delims==" %%a in ('wmic cpu get NumberOfCores /value') do echo Nombre de coeurs: %%a
for /f "tokens=2 delims==" %%a in ('wmic cpu get NumberOfLogicalProcessors /value') do echo Nombre de processeurs logiques: %%a
echo.

echo Carte graphique :
for /f "tokens=2 delims==" %%a in ('wmic path win32_VideoController get name /value') do echo %%a
echo.

echo Memoire vive (RAM) :
for /f "tokens=2 delims==" %%a in ('wmic OS get TotalVisibleMemorySize /value') do set ram=%%a
set /a ram=%ram% / 1024 / 1024
echo %ram% Go
echo.

echo Carte mere :
for /f "tokens=2 delims==" %%a in ('wmic baseboard get product /value') do echo %%a
for /f "tokens=2 delims==" %%a in ('wmic baseboard get manufacturer /value') do echo Fabricant: %%a
echo.

echo Stockage :
for /f "tokens=2 delims==" %%a in ('wmic diskdrive get model /value') do echo Modele: %%a
echo.
echo ============================================================
pause

:view_specs_return
cls
echo ============================================================
echo 1. Retour au menu principal
echo 2. Quitter
echo ============================================================
set /p retour="Entrez le numero de votre choix : "
if "%retour%"=="1" (
    goto :main_menu
) else if "%retour%"=="2" (
    goto :end
)else (
    echo Choix invalide. Veuillez entrer un numero valide.
    pause
    goto :view_specs_return
)

:download_ninite
cls
echo ============================================================
echo            Telechargement et installation de Ninite
echo ============================================================

:: Vérifier si curl est disponible
where curl >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo curl n'est pas installe. Telechargez et installez curl pour continuer.
    pause
    goto :main_menu
)

:: Définir l'URL et le chemin de destination
set URL=https://ninite.com/.net4.8-.net8-7zip-chrome-cutepdf-firefox-libreoffice-paint.net-teamviewer15-thunderbird-vlc/ninite.exe
set DEST=%USERPROFILE%\Desktop\ninite.exe

:: Télécharger le fichier avec curl
curl -o %DEST% %URL%

if %ERRORLEVEL% NEQ 0 (
    echo Le telechargement a echoue. Verifiez votre connexion Internet et reessayez.
    pause
    goto :main_menu
)

:: Exécuter le fichier téléchargé
%DEST%

if %ERRORLEVEL% NEQ 0 (
    echo L'installation a echoue. Verifiez les logs d'installation pour plus de details.
    pause
    goto :main_menu
)

echo Le telechargement et l'installation de Ninite ont reussi.
pause

:download_ninite_return
cls
echo ============================================================
echo 1. Retour au menu principal
echo 2. Quitter
echo ============================================================
set /p retour="Entrez le numero de votre choix : "
if "%retour%"=="1" (
    goto :main_menu
) else if "%retour%"=="2" (
    goto :end
) else (
    echo Choix invalide. Veuillez entrer un numero valide.
    pause
    goto :download_ninite_return
)

:check_windows_update
cls
echo ============================================================
echo          Verification des mises a jour de Windows
echo ============================================================

:: Vérifier si PowerShell est disponible
where powershell >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo PowerShell n'est pas installe. Telechargez et installez PowerShell pour continuer.
    pause
    goto :main_menu
)

:: Exécuter le script PowerShell pour vérifier les mises à jour
powershell.exe -Command "Get-WindowsUpdate -Install -AcceptAll -AutoReboot"

if %ERRORLEVEL% NEQ 0 (
    echo La verification ou l'installation des mises a jour a echoue. Verifiez votre connexion Internet et reessayez.
    pause
    goto :main_menu
)

echo La verification et l'installation des mises a jour de Windows ont reussi.
pause

:check_windows_update_return
cls
echo ============================================================
echo 1. Retour au menu principal
echo 2. Quitter
echo ============================================================
set /p retour="Entrez le numero de votre choix : "
if "%retour%"=="1" (
    goto :main_menu
) else if "%retour%"=="2" (
    goto :end
) else (
    echo Choix invalide. Veuillez entrer un numero valide.
    pause
    goto :check_windows_update_return
)

:download_install_office
cls
echo ============================================================
echo      Téléchargement et installation d'Office 2021 Pro Plus
echo ============================================================

:: Définir l'URL de téléchargement et le chemin de destination
set URL=https://officecdn.microsoft.com/db/492350f6-3a01-4f97-b9c0-c7c6ddf67d60/media/fr-FR/ProPlus2021Retail.img
set DEST=E:\ProPlus2021Retail.img

:: Télécharger le fichier avec curl
curl -k -o %DEST% %URL%

if %ERRORLEVEL% NEQ 0 (
    echo Le téléchargement a échoué. Vérifiez votre connexion Internet et réessayez.
    pause
    goto :main_menu
)

:: Exécuter le fichier téléchargé
%DEST%

if %ERRORLEVEL% NEQ 0 (
    echo L'installation a échoué. Vérifiez les logs d'installation pour plus de détails.
    pause
    goto :main_menu
)

echo Le téléchargement et l'installation d'Office 2021 Pro Plus ont réussi.
pause

:download_install_office_return
cls
echo ============================================================
echo 1. Retour au menu principal
echo 2. Quitter
echo ============================================================
set /p retour="Entrez le numéro de votre choix : "
if "%retour%"=="1" (
    goto :main_menu
) else if "%retour%"=="2" (
    goto :end
) else (
    echo Choix invalide. Veuillez entrer un numéro valide.
    pause
    goto :download_install_office_return
)

:activate_office
cls
echo ============================================================
echo                    Activation d'Office 2021
echo ============================================================

cd /d %ProgramFiles%\Microsoft Office\Office16
for /f %%x in ('dir /b..\root\Licenses16\ProPlus2021VL*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x"
cscript ospp.vbs /setprt:1688
cscript ospp.vbs /unpkey:6F7TH >nul
cscript ospp.vbs /inpkey:FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH
cscript ospp.vbs /sethst:e8.us.to
cscript ospp.vbs /act


echo.
echo Office 2021 a bien ete active avec succes.
pause

:activate_office_return
cls
echo ============================================================
echo 1. Retour au menu principal
echo 2. Quitter
echo ============================================================
set /p retour="Entrez le numero de votre choix : "
if "%retour%"=="1" (
    goto :main_menu
) else if "%retour%"=="2" (
    goto :end
) else (
    echo Choix invalide. Veuillez entrer un numero valide.
    pause
    goto :activate_office_return
)

:remove_windows_password
cls
echo ============================================================
echo            Retirer le mot de passe de Windows
echo ============================================================
echo.

:: Vérifier si le mot de passe est déjà retiré
net user %username% * >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Le mot de passe est deja retire.
    pause
    goto :main_menu
)

:: Retirer le mot de passe
net user %username% *

if %ERRORLEVEL% NEQ 0 (
    echo Erreur lors de la suppression du mot de passe.
    pause
    goto :main_menu
)

echo Le mot de passe a bien ete retire.
pause

:remove_windows_password_return
cls
echo ============================================================
echo 1. Retour au menu principal
echo 2. Quitter
echo ============================================================
set /p retour="Entrez le numero de votre choix : "
if "%retour%"=="1" (
    goto :main_menu
) else if "%retour%"=="2" (
    goto :end
) else (
    echo Choix invalide. Veuillez entrer un numero valide.
    pause
    goto :remove_windows_password_return
)
:transform_account_admin
cls

echo ============================================================
echo            Transformer le compte en administrateur
echo ============================================================
echo.

:: Vérifier si le compte est déjà administrateur
net localgroup Administrators %username% >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Vous etes deja administrateur.
    pause
    goto :main_menu
)

:: Ajouter le compte à l'administrateur
net localgroup Administrators %username% /add

if %ERRORLEVEL% NEQ 0 (
    echo Erreur lors de l'ajout du compte à l'administrateur.
    pause
    goto :main_menu
)

echo Le compte a bien ete transforme en administrateur.
pause

:transform_account_admin_return
cls

echo ============================================================
echo 1. Retour au menu principal
echo 2. Quitter
echo ============================================================
set /p retour="Entrez le numero de votre choix : "
if "%retour%"=="1" (
    goto :main_menu
) else if "%retour%"=="2" (
    goto :end
) else (
    echo Choix invalide. Veuillez entrer un numero valide.
    pause
    goto :transform_account_admin_return
)
:end
endlocal
exit /b