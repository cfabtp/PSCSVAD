##### FONCTIONS - INTERFACE UTILISATEUR #####

function color ($bc,$fc) {
$a = (Get-Host).UI.RawUI
$a.BackgroundColor = $bc
$a.ForegroundColor = $fc}

function ui_nvPage
{
    Clear-Host
}

function ui_bandeau
{
    param($test)
    $nb = (96 - $test.length) / 2
    Write-Host
    Write-Host "####################################################################################################"
    For($i=0;$i -lt $nb;$i++) {Write-Host -NoNewline "#"}
    Write-Host -NoNewline " " $test " "
    For($i=0;$i -lt $nb-0.5;$i++) {Write-Host -NoNewline "#"}
    Write-Host
    Write-Host "####################################################################################################"
    Write-Host
}

function ui_menuPrincipal
{
    ui_nvPage
    ui_bandeau "MENU PRINCIPAL"
    Write-Host
    Write-Host "##### CONSULTATION #####"
    Write-Host
    Write-Host "* f     : Chercher un utilisateur dans la base de donnees"
    Write-Host
    Write-Host "* usmad : Utilisateurs sans mot de passe AD"
    Write-Host "* uiy   : Utilisateurs inactifs NetYpareo"
    Write-Host
    Write-Host "- rb    : Lecture RAW de la base de donnees"
    Write-Host "- re    : Lecture RAW de l'export Ypareo"
    Write-Host
    Write-Host "- sb    : Afficher la synthese par classe de la base de donnees"
    Write-Host "- se    : Afficher la synthese par classe de l'export NetYpareo"
    Write-Host "\ sa    : Afficher la synthese par classe de l'Active Directory"
    Write-Host
    Write-Host "- ib    : Importer la base de donn�es en RAM"
    Write-Host "- ie    : Importer l'export Ypareo en RAM"
    Write-Host
    Write-Host "* v     : Verification de l'integrite de la base de donnees sur AD"
    Write-Host "- dn    : Afficher le delta (Export Ypareo / Base de donnees)"
    Write-Host "- dp    : Afficher le delta (Base de donnees / Export Ypareo)"
    Write-Host
    Write-Host "* p     : Generer un CSV pour publipostage des nouveaux codes"
    Write-Host
    Write-Host
    Write-Host "##### MODIFICATION #####"
    Write-Host
    Write-Host "- t    : Tri alphanumerique de la base de donnees"
    Write-Host
    Write-Host "* ina  : Integrer les nouveaux utilisateurs dans l'ADUsers "
    Write-Host
    Write-Host "\ c    : Creation des nouveaux utilisateurs"
    Write-Host
    Write-Host "* s    : Suppression des utilisateurs expires"
    Write-Host
    Write-Host
    Write-Host "##### SORTIE / DEBUG #####"
    Write-Host
    Write-Host "- b  : Fonction de test"
    Write-Host
    Write-Host "- q  : Quitter"
    Write-Host
    Write-Host
}

function ui_messageFin
{
    Clear-Host
    ui_bandeau "AU REVOIR !"
}

##### FONCTIONS - BACKEND #####

### Consultation ###

# Chercher utilisateur #

function chercherUtilisateur
{
    <# 
    ui_nvPage
    ui_bandeau "RECHERCHE"
    Write-Host
    Write-Host "n : Par nom"
    Write-Host "p : Par prénom"
    Write-Host "q : Quitter"
    Write-Host
    $choix = Read-Host "Votre choix ?"
    If($choix -eq "n") {chercherUtilisateurDansBDD}
    If($choix -eq "p") {chercherUtilisateurDansBDD}
    If($choix -eq "q") {break}

    #> 


    $Data = Import-Csv "C:\Users\tl\Desktop\STAGE\PSCSVAD\ADUsers.csv"
    $Search = Read-Host 
    $MyResult = $Data | Where {$_.NOM_APPRENANT -eq $Search}

    Read-Host
}

# Utilisateurs inactifs #

function utilisateursSansMDP
{
    $mode = Read-Host 
    if($mode -eq "nb")     # Mode compteur
    {
        $deltaPartis_NOM_APPRENANT
        Read-host
    }

    if($mode -eq "ls")     # Mode liste
    {

    }

}

function utilisateursInactifsYpareo
{

}

# Lecture RAW #

function lectureRawBDD
{
    Import-Csv C:\Users\tl\Desktop\STAGE\PSCSVAD\ADUsers.csv -delimiter ";"
    Read-Host
}

function lectureRawExport
{
    Import-Csv C:\Users\tl\Desktop\STAGE\PSCSVAD\export.csv -delimiter ";"
    Read-Host
}

# Synthèse #

function syntheseBDD
{
    ui_nvPage
    ui_bandeau "SYNTHESE BDD"

    importerBDD

    ui_bandeau "Resume"
    Write-Host

    Write-Host "BDD : " $BDD_NOM_NET_UTILISATEUR_APPRENANT.count " comptes distincts"
    Write-Host
    $groupes = $BDD_ABREGE_GROUPE_APPRENANT | Group-Object -NoElement | Sort-Object -Property Name
    Write-Host "Répartis dans " $groupes.count " groupes"
    Write-Host
    Write-Host "Pour un total de " "0" " cursus"
    Write-Host
    Write-Host

    ui_bandeau "Classes"
    Write-Host

    $choix = Read-Host "Afficher les groupes ?"
    If($choix -eq "y") {$groupes}
    Write-Host

    Read-Host "END func"
}

function syntheseExport
{
    ui_nvPage
    ui_bandeau "SYNTHESE EXPORT"

    importerExport

    ui_bandeau "Resume"
    Write-Host

    Write-Host "EXPORT : " $EXPORT_NOM_NET_UTILISATEUR_APPRENANT.count " comptes distincts"
    Write-Host
    $groupes = $export_ABREGE_GROUPE_APPRENANT | Group-Object -NoElement | Sort-Object -Property Name
    Write-Host "Repartis dans " $groupes.count " groupes"
    Write-Host
    Write-Host "Pour un total de " "0" " cursus"
    Write-Host
    Write-Host

    ui_bandeau "Classes"
    Write-Host

    $choix = Read-Host "Afficher les groupes ?"
    If($choix -eq "y") {$groupes}
    Write-Host

    Read-Host "END func"
}

function syntheseAD
{
    ui_nvPage
    ui_bandeau "SYNTHESE AD"

    ui_bandeau "Resume"
    Write-Host

    Write-Host "AD : " (Get-ADUser -Filter *).Count " comptes distincts"
    Write-Host
    $groupes = $export_ABREGE_GROUPE_APPRENANT | Group-Object -NoElement | Sort-Object -Property Name
    Write-Host "Repartis dans " (Get-ADGroup -Filter *).Count " groupes"
    Write-Host
    Write-Host "Pour un total de " "0" " cursus"
    Write-Host
    Write-Host

    ui_bandeau "Classes"
    Write-Host

    $choix = Read-Host "Afficher les groupes ?"
    If($choix -eq "y") {$groupes}
    Write-Host

    Read-Host "END func"
}

# Importation #

function importerBDD
{
    Import-Csv C:\Users\tl\Desktop\STAGE\PSCSVAD\ADUsers.csv -delimiter ";" | ForEach-Object {
        $global:BDD_NOM_APPRENANT += $_.NOM_APPRENANT
        $global:BDD_PRENOM_APPRENANT += $_.PRENOM_APPRENANT
        $global:BDD_NOM_NET_UTILISATEUR_APPRENANT += $_.NOM_NET_UTILISATEUR_APPRENANT
        $global:BDD_PASSWORD_NET_UTILISATEUR_APPRE += $_.PASSWORD_NET_UTILISATEUR_APPRE
        $global:BDD_MDP_AD += $_.MDP_AD
        $global:BDD_EMAIL_COURRIER += $_.EMAIL_COURRIER
        $global:BDD_TELEPHONE_COURRIER += $_.TELEPHONE_COURRIER
        $global:BDD_PORTABLE_COURRIER += $_.PORTABLE_COURRIER
        $global:BDD_ABREGE_GROUPE_APPRENANT += $_.ABREGE_GROUPE_APPRENANT
    }

    write-host "Nombre d'entrées :"
    $BDD_NOM_APPRENANT.count

    Write-Host "Importation de la base de donnees en RAM terminee"
    Write-Host

    Read-Host "Continuer ?"
}


function importerExport
{
    Import-Csv C:\Users\tl\Desktop\STAGE\PSCSVAD\export.csv -delimiter ";" | ForEach-Object {
        $global:export_NOM_APPRENANT += $_.NOM_APPRENANT
        $global:export_PRENOM_APPRENANT += $_.PRENOM_APPRENANT
        $global:export_NOM_NET_UTILISATEUR_APPRENANT += $_.NOM_NET_UTILISATEUR_APPRENANT
        $global:export_PASSWORD_NET_UTILISATEUR_APPRE += $_.PASSWORD_NET_UTILISATEUR_APPRE
        $global:export_MDP_AD += $_.MDP_AD
        $global:export_EMAIL_COURRIER += $_.EMAIL_COURRIER
        $global:export_TELEPHONE_COURRIER += $_.TELEPHONE_COURRIER
        $global:export_PORTABLE_COURRIER += $_.PORTABLE_COURRIER
        $global:export_ABREGE_GROUPE_APPRENANT += $_.ABREGE_GROUPE_APPRENANT
    }

    write-host "Nombre d'entrées :"
    $export_NOM_APPRENANT.count

    Write-Host "Importation de l'export en RAM terminee"
    Write-Host

    #$BDD_NOM_NET_UTILISATEUR_APPRENANT[0..10]

    Read-Host "Continuer ?"
}

# Delta #

function faireDeltaNouveauxUtilisateurs
{

        $export = Import-Csv C:\Users\tl\Desktop\STAGE\PSCSVAD\export.csv -delimiter ";"
        $ADUsers = Import-Csv C:\Users\tl\Desktop\STAGE\PSCSVAD\ADUsers.csv -delimiter ";"

        Compare-Object -ReferenceObject $export -DifferenceObject $ADUsers  -Property NOM_APPRENANT,PRENOM_APPRENANT,NOM_NET_UTILISATEUR_APPRENANT,PASSWORD_NET_UTILISATEUR_APPRE,EMAIL_COURRIER,TELEPHONE_COURRIER,PORTABLE_COURRIER,ABREGE_GROUPE_APPRENANT | Where{ $_.SideIndicator -eq "<=" } | ForEach-Object {
        $global:deltaNv_NOM_APPRENANT += $_.NOM_APPRENANT
        $global:deltaNv_PRENOM_APPRENANT += $_.PRENOM_APPRENANT
        $global:deltaNv_NOM_NET_UTILISATEUR_APPRENANT += $_.NOM_NET_UTILISATEUR_APPRENANT
        $global:deltaNv_PASSWORD_NET_UTILISATEUR_APPRE += $_.PASSWORD_NET_UTILISATEUR_APPRE
        $global:deltaNv_MDP_AD += $_.MDP_AD
        $global:deltaNv_EMAIL_COURRIER += $_.EMAIL_COURRIER
        $global:deltaNv_TELEPHONE_COURRIER += $_.TELEPHONE_COURRIER
        $global:deltaNv_PORTABLE_COURRIER += $_.PORTABLE_COURRIER
        $global:deltaNv_ABREGE_GROUPE_APPRENANT += $_.ABREGE_GROUPE_APPRENANT
    }
    Write-Host "Comparaison en RAM terminée"
    Write-Host $deltaNv_NOM_APPRENANT

    Read-Host "Continuer ?"
}

function faireDeltaUtilisateursPartis
{
        $export = Import-Csv C:\Users\tl\Desktop\STAGE\PSCSVAD\export.csv -delimiter ";"
        $ADUsers = Import-Csv C:\Users\tl\Desktop\STAGE\PSCSVAD\ADUsers.csv -delimiter ";"

        Compare-Object -ReferenceObject $ADUsers -DifferenceObject $export   -Property NOM_APPRENANT,PRENOM_APPRENANT,NOM_NET_UTILISATEUR_APPRENANT,PASSWORD_NET_UTILISATEUR_APPRE,EMAIL_COURRIER,TELEPHONE_COURRIER,PORTABLE_COURRIER,ABREGE_GROUPE_APPRENANT | Where{ $_.SideIndicator -eq "<=" } | ForEach-Object {
        $global:deltaPartis_NOM_APPRENANT += $_.NOM_APPRENANT
        $global:deltaPartis_PRENOM_APPRENANT += $_.PRENOM_APPRENANT
        $global:deltaPartis_NOM_NET_UTILISATEUR_APPRENANT += $_.NOM_NET_UTILISATEUR_APPRENANT
        $global:deltaPartis_PASSWORD_NET_UTILISATEUR_APPRE += $_.PASSWORD_NET_UTILISATEUR_APPRE
        $global:deltaPartis_MDP_AD += $_.MDP_AD
        $global:deltaPartis_EMAIL_COURRIER += $_.EMAIL_COURRIER
        $global:deltaPartis_TELEPHONE_COURRIER += $_.TELEPHONE_COURRIER
        $global:deltaPartis_PORTABLE_COURRIER += $_.PORTABLE_COURRIER
        $global:deltaPartis_ABREGE_GROUPE_APPRENANT += $_.ABREGE_GROUPE_APPRENANT
    }
    Write-Host "Comparaison en RAM terminée"
    Write-Host  $deltaPartis_NOM_APPRENANT

    Read-Host "Continuer ?"
}


# Publipostage #



### Modification ###

# Sauvegarde ADUsers

function sauvegarderADUsers
{

}

# Tri #

function trierCSV
{
    Write-Host "Démarrage du tri de la base de donn�es "
    Import-Csv C:\Users\tl\Desktop\STAGE\PSCSVAD\ADUsers.csv -Delimiter ';'| Sort-Object NOM_APPRENANT �Unique| Export-Csv -Path C:\Users\tl\Desktop\STAGE\PSCSVAD\ADUsersTri.csv -NoTypeInformation -Delimiter ';' -Force
    Read-Host
}

# Ajout nvx utilisateurs à l'ADUsers

function ajouterNvxUtilisateursToADUsers
{
import-csv "C:\Users\tl\Desktop\STAGE\PSCSVAD\ADUsersTri.csv" -delimiter ";" | export-csv -append -path "C:\Users\tl\Desktop\STAGE\PSCSVAD\backups\ADUsers_$((Get-Date).ToString('yyyy-MM-dd')).csv" -delimiter ";" -NoTypeInformation


New-Object -TypeName PSCustomObject -Property @{
FeedName = $deltaNv_NOM_APPRENANT
} | Export-Csv -Path "C:\Users\tl\Desktop\STAGE\PSCSVAD\backups\ADUsers_$((Get-Date).ToString('yyyy-MM-dd')).csv" -NoTypeInformation -Append

}

# Création #

function creation
{
$ADUsers = Import-csv C:\Users\tl\Desktop\STAGE\PSCSVAD\ADUsersTri.csv

foreach ($User in $ADUsers)
{
       $Username = $user.NOM_NET_UTILISATEUR_APPRENANT
       $Prenom = $User.PRENOM_APPRENANT
       $Nom    = $User.NOM_APPRENANT
       $Password    = $User.PASSWORD_NET_UTILISATEUR_APPRE
       $Mail = $User.EMAIL_COURRIER
       $TEL = $User.TELEPHONE_COURRIER
       $Portable = $User.PORTABLE_COURRIER
       $OU           = $User.ABREGE_GROUPE_APPRENANT

       if (Get-ADUser -F {SamAccountName -eq $Username})
       {
               Write-Warning "L'utilisateur existe d�j�"
       }
       else
       {
              New-ADUser `
            -SamAccountName $Username `
            -GivenName $Prenom `
            -Surname $Nom `
            -Surname $Lastname `
            -Enabled $True `
            -MobilePhone $TEL `
            -Email $Mail `
            -Path $OU `
            -AccountPassword $Password
       }
}
    Read-Host "Continuer ?"
}


# Suppression #



### Sortie / Test ###

# Init #

function initVariables
{
    $global:export = @()
    $global:ADUsers = @()

    $global:BDD_NOM_APPRENANT = @()
    $global:BDD_PRENOM_APPRENANT = @()
    $global:BDD_NOM_NET_UTILISATEUR_APPRENANT = @()
    $global:BDD_PASSWORD_NET_UTILISATEUR_APPRE = @()
    $global:BDD_MDP_AD = @()
    $global:BDD_EMAIL_COURRIER = @()
    $global:BDD_TELEPHONE_COURRIER = @()
    $global:BDD_PORTABLE_COURRIER = @()
    $global:BDD_ABREGE_GROUPE_APPRENANT = @()

    $global:export_NOM_APPRENANT = @()
    $global:export_PRENOM_APPRENANT = @()
    $global:export_NOM_NET_UTILISATEUR_APPRENANT = @()
    $global:export_PASSWORD_NET_UTILISATEUR_APPRE = @()
    $global:export_MDP_AD = @()
    $global:export_EMAIL_COURRIER = @()
    $global:export_TELEPHONE_COURRIER = @()
    $global:export_PORTABLE_COURRIER = @()
    $global:export_ABREGE_GROUPE_APPRENANT = @()

    $global:deltaPartis_NOM_APPRENANT = @()
    $global:deltaPartis_PRENOM_APPRENANT = @()
    $global:deltaPartis_NOM_NET_UTILISATEUR_APPRENANT = @()
    $global:deltaPartis_PASSWORD_NET_UTILISATEUR_APPRE = @()
    $global:deltaPartis_MDP_AD = @()
    $global:deltaPartis_EMAIL_COURRIER = @()
    $global:deltaPartis_TELEPHONE_COURRIER = @()
    $global:deltaPartis_PORTABLE_COURRIER = @()
    $global:deltaPartis_ABREGE_GROUPE_APPRENANT = @()

    $global:deltaNv_NOM_APPRENANT = @()
    $global:deltaNv_PRENOM_APPRENANT = @()
    $global:deltaNv_NOM_NET_UTILISATEUR_APPRENANT = @()
    $global:deltaNv_PASSWORD_NET_UTILISATEUR_APPRE = @()
    $global:deltaNv_MDP_AD = @()
    $global:deltaNv_EMAIL_COURRIER = @()
    $global:deltaNv_TELEPHONE_COURRIER = @()
    $global:deltaNv_PORTABLE_COURRIER = @()
    $global:deltaNv_ABREGE_GROUPE_APPRENANT = @()
}

function test
{
    $pshost = Get-Host
    $psWindow = $pshost.UI.RawUI
    Write-Host $psWindow.WindowSize

}

##### AUTRES FONCTIONS LIEES #####

function parcoursComplet
{
    ui_nvPage
    ui_bandeau "FUSION"
    Write-Host
    Write-Host "RECAP :"
    Write-Host ""
    Write-Host "1 / Vérification de la présence des fichiers requis"
    Write-Host "2 / Réorganisation alphanumérique"
    Write-Host "3 / Affichage des compteurs liés"
    Write-Host "4 / Sélection des fusions"
    Write-Host "5 / Récapitulatif final"

    ui_bandeau "Etape 1 / Vérification de la présence des fichiers requis"
    verifierPresenceFichiers

    Write-Host "Etape 1 terminée."
    $choix = Read-Host "Passer à l'étape 2 ?"
    If($choix -ne "y") {break}

    ui_bandeau "Etape 2 / Réorganisation alphanumérique"
    trierCSV
    Write-Host

    Write-Host "Etape 2 terminée."
    $choix = Read-Host "Passer à l'étape 3 ?"
    If($choix -ne "y") {break}

    ui_bandeau "Etape 3 / Affichage des compteurs liés"
    afficherCompteurs
    Write-Host

    Write-Host "Etape 3 terminée."
    $choix = Read-Host "Passer à l'étape 3 ?"
    If($choix -ne "y") {break}
}

function verifierPresenceFichiers
{
    $dir = Get-Location
    Write-Host "Dossier de travail : "$dir
    Write-Host
    if (Test-Path -Path ADUsers.csv) {Write-Host "Base de données : OK"}
    else {Write-Host "ERREUR : Base de données absente"}
    if (Test-Path -Path export.csv) {Write-Host "Export Ypareo : OK"}
    else {Write-Host "ERREUR : Export Ypareo absent"}
    Write-Host
}

function afficherCompteurs
{

}

##### SCRIPT #####

Write-Host "Start"

### Init variables ###

initVariables

### Menu principal ###

$exit = 0

While($exit -ne 1)   # If($choix -eq "") {}
{
    ui_menuPrincipal
    $choix = Read-Host "Votre choix ?"

    # Consultation

    If($choix -eq "f") {chercherUtilisateur}

    If($choix -eq "usmad") {utilisateursSansMDP}
    If($choix -eq "uiy") {utilisateursSansMDP}

    If($choix -eq "rb") {lectureRawBDD}
    If($choix -eq "re") {lectureRawExport}
    If($choix -eq "sb") {syntheseBDD}
    If($choix -eq "se") {syntheseExport}
    If($choix -eq "sa") {syntheseAD}
    If($choix -eq "ib") {importerBDD}
    If($choix -eq "ie") {importerExport}

    If($choix -eq "v") {}
    If($choix -eq "dn") {faireDeltaNouveauxUtilisateurs}
    If($choix -eq "dp") {faireDeltaUtilisateursPartis}

    If($choix -eq "p") {}

    # Modification
    If($choix -eq "svg") {sauvegarderADUsers}

    If($choix -eq "t") {trierCSV}

    If($choix -eq "ina") {ajouterNvxUtilisateursToADUsers}

    If($choix -eq "c") {creation}

    If($choix -eq "s") {}

    # Sortie

    If($choix -eq "b") {test}
    If($choix -eq "q") {$exit = 1}
}

ui_messageFin
