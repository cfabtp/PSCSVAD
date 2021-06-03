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
    Write-Host "* f     : Chercher un utilisateur dans la base de données"
    Write-Host
    Write-Host "* usmad : Utilisateurs sans mot de passe AD"
    Write-Host "* uiy   : Utilisateurs inactifs NetYpareo"
    Write-Host
    Write-Host "* rb    : Lecture RAW de la base de données"
    Write-Host "* re    : Lecture RAW de l'export Ypareo"
    Write-Host
    Write-Host "* sb    : Afficher la synthèse par classe de la base de données"
    Write-Host "* se    : Afficher la synthèse par classe de l'export NetYpareo"
    Write-Host "* sa    : Afficher la synthèse par classe de l'Active Directory"
    Write-Host
    Write-Host "- ib    : Importer la base de données en RAM"
    Write-Host "* ie    : Importer l'export Ypareo en RAM"
    Write-Host
    Write-Host "* v     : Vérification de l'intégrité de la base de données sur AD"
    Write-Host "* d     : Afficher le delta (Export Ypareo / Base de données)"
    Write-Host
    Write-Host "* p     : Générer un CSV pour publipostage des nouveaux codes"
    Write-Host
    Write-Host
    Write-Host "##### MODIFICATION #####"
    Write-Host
    Write-Host "* t  : Tri alphanumérique de la base de données"
    Write-Host
    Write-Host "* c  : Création des nouveaux utilisateurs"
    Write-Host
    Write-Host "* s  : Suppression des utilisateurs expirés"
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

    Read-Host
}

# Utilisateurs inactifs #

function utilisateursSansMDP
{
    param($mode)

    if($mode -eq "nb")     # Mode compteur
    {

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
    Import-Csv .\ADUsers.csv -delimiter ";"
    Read-Host
}

function lectureRawExport
{
    Import-Csv .\export.csv -delimiter ";"
    Read-Host
}

# Synthèse #

function syntheseBDD
{
    ui_nvPage
    ui_bandeau "SYNTHESE BDD"

    importerBDD

    ui_bandeau "Résumé"
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

}

function syntheseAD
{

}

# Importation #

function importerBDD
{
    Import-Csv .\ADUsers.csv -delimiter ";" | ForEach-Object {
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

    Write-Host
    Write-Host "Importation de la base de données en RAM terminée"
    Write-Host

    #$BDD_NOM_NET_UTILISATEUR_APPRENANT[0..10]

    Read-Host "Continuer ?"
}

# Delta #

function delta
{
  $CSV1 = Import-Csv C:\Users\tl\Desktop\STAGE\PSCSVAD\BDD.csv -delimiter ";"
  $CSV2 = Import-Csv C:\Users\tl\Desktop\STAGE\PSCSVAD\export.csv -delimiter ";"

  
  Compare-Object -ReferenceObject $CSV1 -DifferenceObject $CSV2 -Property Pays | Where{ $_.SideIndicator -eq "<=" }
       Read-Host
}




# Publipostage #



### Modification ###

# Tri #

function trierCSV
{
    $fichierATrier = Read-Host "Quel fichier ( bdd | export )"
    Write-Host "Démarrage du tri de " $fichierATrier
    Read-Host
}

# Création #



# Suppression #



### Sortie / Test ###

# Init #

function initVariables
{
    $global:BDD_NOM_APPRENANT = @()
    $global:BDD_PRENOM_APPRENANT = @()
    $global:BDD_NOM_NET_UTILISATEUR_APPRENANT = @()
    $global:BDD_PASSWORD_NET_UTILISATEUR_APPRE = @()
    $global:BDD_MDP_AD = @()
    $global:BDD_EMAIL_COURRIER = @()
    $global:BDD_TELEPHONE_COURRIER = @()
    $global:BDD_PORTABLE_COURRIER = @()
    $global:BDD_ABREGE_GROUPE_APPRENANT = @()
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
    if (Test-Path -Path .\ADUsers.csv) {Write-Host "Base de données : OK"}
    else {Write-Host "ERREUR : Base de données absente"}
    if (Test-Path -Path .\export.csv) {Write-Host "Export Ypareo : OK"}
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
    If($choix -eq "uiy") {}

    If($choix -eq "rb") {lectureRawBDD}
    If($choix -eq "re") {lectureRawExport}
    If($choix -eq "sb") {syntheseBDD}
    If($choix -eq "se") {syntheseExport}
    If($choix -eq "se") {syntheseAD}
    If($choix -eq "ib") {importerBDD}
    If($choix -eq "ie") {importerExport}

    If($choix -eq "v") {}
    If($choix -eq "d") {delta}

    If($choix -eq "p") {}

    # Modification

    If($choix -eq "t") {trierCSV}

    If($choix -eq "c") {}

    If($choix -eq "s") {}

    # Sortie

    If($choix -eq "b") {test}
    If($choix -eq "q") {$exit = 1}
}

ui_messageFin
