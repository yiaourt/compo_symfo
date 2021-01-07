#!/bin/bash
# 
# Bienvenu dans compo_symfo 1.5

# Utilisation : compo_symfo(.sh) [OPTION: -new]
# 
# Usage: Dans le dossier racine du projet Symfony créer précedement -> ./compo_symfo(.sh)
#        Ou alors dans le dossier "/var/www/" avec l'option new -> ./compo_symfo(.sh) -new
# 
# Pour Debian/Ubuntu (Contactez moi pour une version Arch avec Pacman.. etc ...)
#      
#       Options : 
#               (pas d'option) : Déroulement du script dans le projet symfony créer précedement --->
                            # Installation de filesystem, apache-pack, Webpack-Encore, Node-Sass, PostCSS et autoprefixer pour Symfony.
                            # Debug de la "Debug Toolbar" de Profiler (du à la configuration d'apache)
                            # Configuration de Webpack-Encore.
                            # Configuration des fichiers assets (JS et SCSS).
                            # Configuration des fichiers Controller et Templates de Symfony.
                            # Téléchargement de quelques polices d'écritures dans le dossier racine du projet : public/fonts/
                            # Configuration du fichier de particles.js
#               
#               
#               -new (Installe tous les composants nécessaire de A à Z)
#                              Déroulement du script dans le dossier "/var/www/" ->
#                                            - Paquets LAMP (+ php et mysql)
#                                            - Github (obligatoire pour symfony client)
#                                            - Symfony client et Symfony 5.1
#                                            - Composer
#                                            - Node JS
#                                            - Yarn
#                                            - ensuite, création du projet symfony
#                                            - puis on passe à la suite du script comme si il ni avait pas eu l'option -new
#
# par Yiaourt

# Récuperation de l'option -new pour savoir
# si l'utilisateur souhaite installer tous les composants
# de "A" à "Z" à la bonne version etc depuis l'installation et la configuration
# du localserver de apache2 puis on reprend le script comme s'il ni à pas d'options
if  [[ $1 = "-new" ]]; then
    
    echo -e "\nCe script va installer tous les paquets et composants nécessaire à la création de projet web"
    echo -e " de la base \"Apache\" jusqu'à la template même d'un site par défault modulable."

    echo -e "\n\033[33mVous avez choisi l'option -new (répondez aux questions pour savoir ce que le script doit installer)\e[0m"

    while true; do
        # On demande à l'utilisateur s'il veut installer apache, php et mysql
        echo ""
        read -p "Voulez-vous installer Apache, PHP, Mysql... (paquets LAMP) ? (y/n)" yn 
        case $yn in
            
            [Yy]* )
                echo -e "\nTéléchargements et installation du paquet LAMP depuis les dépots aptitude (/!sudo!\)"
                sudo apt install apache2 libapache2-mod-php mysql-server
                sudo apt install php php-mysql php-cli unzip wget
                sudo apt install curl php-curl php-gd php-intl php-json php-mbstring php-xml php-zip
                break;;
            
            [Nn]* ) 
                break;;
            * ) 

            echo "répondez \"yes\" or \"no\".";;
        esac
    done

    while true; do
        # On demande à l'utilisateur s'il veut installer Github
        echo ""
        read -p "Voulez-vous installer Github ? (y/n) (Obligatoire pour symfony)" yn 
        case $yn in
            
            [Yy]* )
                echo -e "\nTéléchargements et installation de Github..."
                echo -e "(Obligatoire pour symfony ! N'oubliez pas de créer un compte -> https://github.com/)\n"
                sudo apt-get install git

                read -p "\nVotre nom pour Github ? " name_git 
                read -p "\nVotre e-mail pour Github ? " mail_git

                git config --global user.email "$mail_git"
                git config --global user.name "$name_git"

                break;;
            
            [Nn]* ) 
                break;;
            * ) 

            echo "répondez \"yes\" or \"no\".";;
        esac
    done

    while true; do
        # On demande à l'utilisateur s'il veut installer symfony
        echo ""
        read -p "Voulez-vous installer Symfony dans le répertoire (/usr/local/bin/symfony) ? (y/n)" yn 
        case $yn in
            
            [Yy]* )
                echo -e "\nTéléchargements de symfony ...\n"
                wget https://get.symfony.com/cli/installer -O - | bash
                echo -e "\n\033[32mInstallation de symfony dans le dossier \"/usr/local/bin\" !\e[0m\n"
                mv /root/.symfony/bin/symfony /usr/local/bin/symfony
                break;;
            
            [Nn]* ) 
                break;;
            * ) 

            echo "répondez \"yes\" or \"no\".";;
        esac
    done

    while true; do
        # On demande à l'utilisateur s'il veut installer Composer
        echo ""
        read -p "Voulez-vous installer composer.phar dans le répertoire (/usr/local/bin/composer.phar) ? (y/n)" yn 
        case $yn in
            
            [Yy]* )
                echo -e "\nTéléchargements et installation de Composer 2.0 ...\n"
                EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
				php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
				ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

				if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
				then
				    >&2 echo 'ERROR: Invalid installer checksum'
				    rm composer-setup.php
				    exit 1
				fi

				php composer-setup.php --quiet
				RESULT=$?
				rm composer-setup.php
				mv composer.phar /usr/local/bin/
                break;;
            
            [Nn]* ) 
                break;;
            * ) 

            echo "répondez \"yes\" or \"no\".";;
        esac
    done

    while true; do
        # On demande à l'utilisateur s'il veut installer NodeJS et ses dépendances
        echo ""
        read -p "Voulez-vous installer NodeJS ? (y/n)" yn 
        case $yn in
            
            [Yy]* )
                echo -e "\nTéléchargements et installation de NodeJS / GCC / G++ / Make ...\n"
                curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
                sudo apt-get install gcc g++ make
                sudo apt-get install -y nodejs
                sudo apt-get autoremove
                break;;
            
            [Nn]* )
                break;;
            * ) 

            echo "répondez \"yes\" or \"no\".";;
        esac
    done

    while true; do
        # On demande à l'utilisateur s'il veut installer Yarn
        echo ""
        read -p "Voulez-vous installer Yarn Package ? (y/n)" yn 
        case $yn in
            
            [Yy]* )
                curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
                echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
                sudo apt-get update && sudo apt-get install yarn
                break;;
            
            [Nn]* )
                break;;
            * ) 

            echo "répondez \"yes\" or \"no\".";;
        esac
    done

    # on demande à l'utilisateur quel nom veut-il donner au nouveau projet symfony
    echo -e "\n Création d'un nouveau projet symfony !"
    echo ""
    read -p "Quel nom voulez vous donnez au nouveau projet symfony ? " project_name
    # On créer ensuite le projet Symfony
    echo -e "\n\033[33m!!! Infos : \e[0m Si le chargement de création du projet Symfony est trop long, appuyez sur la touche entrée"
    symfony new --full $project_name
    cd $project_name

    # Fin de l'option -new #####################################################################################################  
fi

# Début du Bash qui sert à créer une base de projet symfony avec tout ses composants "Composer"
# 


#clear

echo -e "\nAjout de tous les composants nécessaire à un \033[32mnouveau\e[0m projet Symfony..."

echo -e "\nVous devez vérifier que vous avez bien les bonnes version des composants."

echo -e "\n(/!\) Affichage des versions en cours... (certaines questions peuvent être poser si vous êtes en root/super user..)"
php bin/console --version
composer.phar --version
yarn

echo -e "\n\033[33m!!! A noter : \e[0mil est important que vous ayez installé les bonnes versions de"
echo -e "Symfony \033[32m5.2\e[0m, de Composer \033[32m2\e[0m et Yarn \033[32m1.2\e[0m avant de continuer !"
echo -e "(Pour les installer passer par l'option -new #-> compo_symfo(.sh) -new"
echo -e ""
echo "|------------------------------------------------------------------------------------------------|"
read -p "Press any key to continue ... (or ctrl+C)"
echo ""

# Déroulement du script de la template (n°1) --->

# Installation de filesystem, apache-pack, Webpack-Encore, Node-Sass, PostCSS et autoprefixer pour Symfony.
# Debug de la "Debug Toolbar" de Profiler (du à la configuration d'apache)
# Configuration de Webpack-Encore.
# Configuration des fichiers assets (JS et SCSS).
# Configuration des fichiers Controller et Templates de Symfony.
# Téléchargement de quelques polices d'écritures dans le dossier racine du projet : public/fonts/
# Configuration du fichier de particles.js

echo "Veuillez patienter jusqu'à la fin du script..."
# On ajoute quelques composant utiles tout d'abord filesystem pour symfony
echo -e "\n\033[33m!!! Infos : \e[0mInstallation de filesystem"
composer.phar require symfony/filesystem

# On ajoute le composant Profiler de Symfony
echo -e "\n\033[33m!!! Infos : \e[0mInstallation de profiler-pack"
composer.phar require --dev symfony/profiler-pack

# On installe le composant apache-pack et on débug la toolbar de symfony
# -> comment if not apache, and if you will want to do your apache.conf  \oYc
echo -e "\n\033[33m!!! Infos : \e[0mInstallation de apache-pack"
composer.phar require symfony/apache-pack

echo -e "\n\033[33m!!! Infos : \e[0mDébug de la Toolbar du Profiler de Apache"
# On recréer le fichier local de Apache qui est ->  000-default.conf
rm -fv /etc/apache2/sites-available/000-default.conf
touch /etc/apache2/sites-available/000-default.conf

echo -e "\n\033[33m!!! Infos : \e[0mRecréation du fichier de configuration Apache du serveur local"

echo "<VirtualHost *:80>

    ServerName localhost

    DocumentRoot $PWD/public
    DirectoryIndex /index.php

    <Directory $PWD/public>
        AllowOverride None
        Order Allow,Deny
        Allow from All

        FallbackResource /index.php
    </Directory>

    # uncomment the following lines if you install assets as symlinks
    # or run into problems when compiling LESS/Sass/CoffeeScript assets
    # <Directory /var/www/project>
    #     Options FollowSymlinks
    # </Directory>

    # optionally disable the fallback resource for the asset directories
    # which will allow Apache to return a 404 error when files are
    # not found instead of passing the request to Symfony
    <Directory /var/www/project/public/bundles>
        FallbackResource disabled
    </Directory>
    ErrorLog /var/log/apache2/${PWD##*/}.log
    CustomLog /var/log/apache2/${PWD##*/}.log combined

    # optionally set the value of the environment variables used in the application
    #SetEnv APP_ENV prod
    #SetEnv APP_SECRET <app-secret-id>
    #SetEnv DATABASE_URL \"mysql://db_user:db_pass@host:3306/db_name\"

</VirtualHost>" >> /etc/apache2/sites-available/000-default.conf

# On redémarre apache2
/etc/init.d/apache2 reload
/etc/init.d/apache2 restart

# ajout des sessions PHP à symfony
echo -e "\n\033[33m!!! Infos : \e[0mAjout des sessions -> config/packages/framework.yaml"
echo -e "\n\033[33m!!! Infos : \e[0mRecréation de config/packages/framework.yaml"
rm config/packages/framework.yaml
touch config/packages/framework.yaml

echo "# see https://symfony.com/doc/current/reference/configuration/framework.html
framework:
    secret: '%env(APP_SECRET)%'
    #csrf_protection: true
    #http_method_override: true

    # Enables session support. Note that the session will ONLY be started if you read or write from it.
    # Remove or comment this section to explicitly disable session support.
    session:
        enabled: true
        handler_id: null
        cookie_secure: auto
        cookie_samesite: lax

    #esi: true
    #fragments: true
    php_errors:
        log: true
" >> config/packages/framework.yaml

# installation de webpack-encore
echo -e "\n\033[33m!!! Infos : \e[0mInstallation de webpack-encore"
composer.phar require symfony/webpack-encore-bundle
yarn install

echo -e "\n\033[33m!!! Infos : \e[0mRecréation du fichier -> (webpack.config.js)"
# On recréer le webpack pour ajouter sass loader et postcss
rm webpack.config.js
touch webpack.config.js

echo "var Encore = require('@symfony/webpack-encore');

// Manually configure the runtime environment if not already configured yet by the ''encore'' command.
// It's useful when you use tools that rely on webpack.config.js file.
if (!Encore.isRuntimeEnvironmentConfigured()) {
    Encore.configureRuntimeEnvironment(process.env.NODE_ENV || 'dev');
}

Encore
    // directory where compiled assets will be stored
    .setOutputPath('public/build/')
    // public path used by the web server to access the output path
    .setPublicPath('/build')
    // only needed for CDN's or sub-directory deploy
    //.setManifestKeyPrefix('build/')

    /*
     * ENTRY CONFIG
     *
     * Add 1 entry for each ''page'' of your app
     * (including one that's included on every page - e.g. ''app'')
     *
     * Each entry will result in one JavaScript file (e.g. app.js)
     * and one CSS file (e.g. app.css) if your JavaScript imports CSS.
     */
    .addEntry('basic', './assets/basic.js')
    .addEntry('home', './assets/home.js')
    //.addEntry('page1', './assets/js/page1.js')
    //.addEntry('page2', './assets/js/page2.js')

    // When enabled, Webpack ''splits'' your files into smaller pieces for greater optimization.
    .splitEntryChunks()

    // will require an extra script tag for runtime.js
    // but, you probably want this, unless you're building a single-page app
    .enableSingleRuntimeChunk()

    /*
     * FEATURE CONFIG
     *
     * Enable & configure other features below. For a full
     * list of features, see:
     * https://symfony.com/doc/current/frontend.html#adding-more-features
     */
    .cleanupOutputBeforeBuild()
    .enableBuildNotifications()
    .enableSourceMaps(!Encore.isProduction())
    // enables hashed filenames (e.g. app.abc123.css)
    .enableVersioning(Encore.isProduction())

    // enables @babel/preset-env polyfills
    .configureBabelPresetEnv((config) => {
        config.useBuiltIns = 'usage';
        config.corejs = 3;
    })

    // enables Sass/SCSS support + postCSS
    .enableSassLoader()
    .enablePostCssLoader((options) => {
        options.config = {
            // the directory where the postcss.config.js file is stored
            path: 'postcss.config.js'
        };
    })

    // uncomment if you use TypeScript
    //.enableTypeScriptLoader()

    // uncomment to get integrity=''...'' attributes on your script & link tags
    // requires WebpackEncoreBundle 1.4 or higher
    //.enableIntegrityHashes(Encore.isProduction())

    // uncomment if you're having problems with a jQuery plugin
    //.autoProvidejQuery()

    // uncomment if you use API Platform Admin (composer.phar req api-admin)
    //.enableReactPreset()
    //.addEntry('admin', './assets/admin.js')
;

module.exports = Encore.getWebpackConfig(); " >> webpack.config.js


# !!!\ Attention ci dessous, on install sass-loader, node-sass, postcss et autoprefixer
# dans une version symfony 5.1.8, de composer 2.0.4 et Yarn 1.22.5 ! (important)
# Si vous rencontrer des érreurs du à une nouvelle version n'hésitez pas à me contacter Y##Yiaourt
echo -e "\n\033[33m!!! Infos :\e[0m Installation du composant SassLoader"
yarn add sass-loader@^9.0.1 node-sass@^4.0.0 --dev

echo -e "\n\033[33m!!! Infos :\e[0m Installation des composants PostCss et Autoprefixer"
yarn add postcss-loader@^3.0.0 autoprefixer@^8.0.0 --dev

#création de postcss.config.js
touch postcss.config.js

echo 'module.exports = {
    plugins: {
        // include whatever plugins you want
        // but make sure you install these via yarn or npm!

        // add browserslist config to package.json (see below)
        autoprefixer: {}
    }
}' >> postcss.config.js


#modifications de fichiers
echo -e "\n\033[33m!!! Infos :\e[0m Recréation des fichiers assets pour accueillir la page 'home' !"
touch assets/basic.js
touch assets/home.js
touch assets/styles/home.scss
touch assets/styles/basic.scss
touch assets/styles/_base.scss

echo -e "\n\033[33m!!! Infos :\e[0m Supression des fichiers assets par défault 'app' pour -> 'basic' !"
rm assets/app.js
rm assets/styles/app.css

# On écrit le fichier javascript de la page basic
echo "/*
 * 
 *
 *      Bienvenu dans le fichier de la page basic
 */

// SCSS need to be import!
import './styles/basic.scss';

// On créer un fond d'écran de particules avec particles.js
particlesJS.load('particles-js', 'particles.json', function() {});


//
// On créer maintenant un évenement lorsque l'on scroll plus bas que la position du titre
\$(window).scroll(function(){

    // Par défault on débug l'animation de animate.css du titre logo et de sa location
    \$('#title').addClass('animate__fadeInDown');
    \$('#title_location').addClass('animate__fadeInRight');

    
    var body_offset = \$('body').scrollTop();
    var window_offset = \$(window).scrollTop();
    var last_window_offset = localStorage.getItem('window_pos');
    
    // Quelques logs utiles ...
    //console.log('window : '+window_offset);
    //console.log('body : '+body_offset);
    //console.log('last_window : '+last_window_offset);
    //
    //

    if(window_offset == body_offset){

        // On affiche la barre de navigation
        \$('#navigation').removeClass('animate__fadeOutUp').addClass('animate__fadeInDown');

        // On affiche le titre avec animate_animated
        \$('#title').removeClass('top-cool animate__fadeInDown d-none').addClass('top-center animate__fadeInDown');

        // On affiche le titre de location avec animate__animated
        \$('#title_location').removeClass('top-center-nomg top-right animate__fadeInRight d-none').addClass('top-center-nomg animate__fadeInRight');
        
        localStorage.removeItem('window_pos');

        return false;
    }

    if(window_offset > body_offset){ // Si la fenêtre est plus grande que le top body

        // On cache la barre de navigation
        \$('#navigation').removeClass('animate__fadeInDown').addClass('animate__fadeOutUp');

        // On place le titre sur la barre de navigation car on scroll
        \$('#title').removeClass('animate__fadeInDown').addClass('d-none');

        \$('#title').removeClass('top-center').addClass('top-cool');

        // On cache le titre de location car l'utilisateur scroll
        \$('#title_location').removeClass('animate__fadeInRight').addClass('d-none');

        \$('#title_location').removeClass('top-center-nomg').addClass('top-right');

        // On sauvegarde la position de la fenetre dans une variable local
        localStorage.setItem('window_pos', window_offset);
        
        if(last_window_offset){ // On vérifie si on à sauvegarder la dernière position de window

            if(last_window_offset > window_offset){ // Si la fenetre scroll up

                \$('#navigation').removeClass('animate__fadeOutUp').addClass('animate__fadeInDown');

                \$('#title').removeClass('d-none').addClass('animate__fadeInDown');

                \$('#title_location').removeClass('d-none').addClass('animate__fadeInRight');
                
                return false;
            }
        }

        return false;
    }
});

//
// On créer ensuite un évenement lorsque la souris de l'utilisateur passe sur le bloc \"hover_tha_menu\"
\$('#hover_tha_menu').hover(function(e){

    e.preventDefault();

    // On récupere la valeur de la hauteur de la fenêtre de scroll actuel et ses sauvegardes
    var body_offset = \$('body').scrollTop();
    var window_offset = \$(window).scrollTop();
    var last_window_offset = localStorage.getItem('window_pos');
    
     // Quelques logs utiles ...
    //console.log('window : '+window_offset);
    //console.log('body : '+body_offset);
    //console.log('last_window : '+last_window_offset);
    //
    //

    if(window_offset == body_offset){

        localStorage.removeItem('window_pos');

        return false;
    }

    if(window_offset > body_offset){ // Si la fenêtre est plus grande que le top body

        // On affiche la barre de navigation
        \$('#navigation').removeClass('animate__fadeOutUp').addClass('animate__fadeInDown');

        // On affiche le titre avec animate_animated
        \$('#title').removeClass('top-center animate__fadeInDown d-none').addClass('top-cool animate__fadeInDown');

        // On affiche le titre de location avec animate__animated
        \$('#title_location').removeClass('top-center-nomg top-right animate__fadeInRight d-none').addClass('top-right animate__fadeInRight');
        
        // On sauvegarde la position de la fenetre dans une variable local
        localStorage.setItem('window_pos', window_offset);
        
        if(last_window_offset){ // On vérifie si on à sauvegarder la dernière position de window

            if(last_window_offset > window_offset){ // Si la fenetre scroll up

                \$('#navigation').removeClass('animate__fadeOutUp').addClass('animate__fadeInDown');

                \$('#title').removeClass('d-none').addClass('animate__fadeInDown');
                
                \$('#title_location').removeClass('d-none').addClass('animate__fadeInRight');
                
                return false;
            }
        }

        return false;
    }
});
" >> assets/basic.js

# On écrit le fichier javascript de la page home
echo "/*
 * 
 *
 * Bienvenu dans le fichier de la page home
 */

// SCSS need to be import!
import './styles/home.scss';" >> assets/home.js

# On écrit dans le fichier de styles 'home'
echo '@import "base";' >> assets/styles/home.scss

# On écrit dans le fichier de styles 'basic'
echo '@import "base";' >> assets/styles/basic.scss

# On écrit dans le fichier de styles 'base'
echo "body,
html {
    background-color: black;
}

footer{
    position: absolute;
    bottom: 0; left: 0;

    text-align: center;
    background-color: #333;

    width: 100%;
    height: 6.66em;
}

/* link */
a{
    color: default;

    transition: 0.314s;

    &:hover{
        color: #FF9200;

        transition: 0.314s;
    }
}

a.nav-link{
    transition: 0.314s;

    &:hover{

        color: #FF9200 !important;

        transition: 0.314s;
    }
}

/* particles.js */
#particles-js {
    width: 100%;
    height: 100%;
    position: absolute;
    top: 0; left: 0;

    z-index: -10;
}

/* Quelques polices d'écriture */
@font-face {
  font-family: bombtrack;
  src: url('/fonts/Bombtrack\ Demo.ttf');
}

@font-face {
    font-family: coolvetica;
    src: url('/fonts/coolvetica\ rg.ttf');
}

/* Styles utile à la navigation TopBar dans la base.html.twig */
#navigation{
    display: block; 
    z-index: 20;
}

#title{
    position: absolute;
    left: 0; right: 0;
    top: 10px;

    width: 350px;

    font-family: bombtrack;
    font-size: 55px;

    z-index: 21;
}

a#title_location{

    width: 350px;

    color: black !important;

    z-index: 99999;

    transition: 0.314s;

    &:hover{

        color: #FF9200 !important;

        transition: 0.314s;
    }
}

#non-nav{
    z-index: 1;
}


#super_nav{

    z-index: 200;

    color: black;

    transition: 0.314s;

    &:hover{

        color: #FF9200;

        transition: 0.314s;
    }
}

.top-right{
    position: fixed !important;
    top: 15px; right: 150px;

    z-index: 99999;

}

.top-center{

    margin-top: 50px;
    margin-left: auto;
    margin-right: auto;

    color: white;
}

.top-center-nomg{
    position: fixed !important;
    top: 15px; left: 50%; right: 50%;

    z-index: 99999;

}

.top-cool{

    position: fixed!important;
    top:-9px !important;

    margin-left: auto;
    margin-right: auto;

    color: black;
}


#hover_tha_menu{

    position: fixed!important;
    top: 0;

    width: 100%;
    height: 15%;

    /* 
    background-color: red;*/

    z-index: 10;
}


/* Quelques création de classes utiles en ajout à bootstrap */

/* Width */
.w-14{
    width: 14% !important;
}

.w-35{
    width: 35% !important;
}

.w-40{
    width: 40% !important;
}

.w-42{
    width: 42% !important;
}

/* Height */
.h-14{
    height: 14% !important;
}

.h-24{
    height: 24% !important;
}

.h-200{
    height: 100em !important;
}

/* Margin */
.mt-15{
    margin-top: 15% !important;
}
.mt-10{
    margin-top: 10% !important;
}
.mt-6{
    margin-top: 5% !important;
}

/* Polices et écritures */
.text-black{
    color: black !important;
}

.font-bombtrack{
    font-family: bombtrack;
}

.font-coolvetica{
    font-family: coolvetica;
}


" >> assets/styles/_base.scss

# On informe les créations et modifications à l'utilisateur
echo -e "[YOUR_PROJECT]/assets/basic.js \033[32m Créer !\e[0m"
echo -e "[YOUR_PROJECT]/assets/home.js \033[32m Créer !\e[0m"
echo -e "[YOUR_PROJECT]/assets/styles/home.scss \033[32m Créer !\e[0m"
echo -e "[YOUR_PROJECT]/assets/styles/_base.scss \033[32m Créer !\e[0m"

# On test de build avec yarn encore dev
echo -e "\n\033[33m!!! Infos Importante :\e[0m Test de build en cours !"
yarn encore dev

# On touche maintenant les fichiers Controller de symfony
echo -e "\n\033[33m!!! Infos :\e[0mCréation du fichier 'src/Controller/HomeController.php'"
touch src/Controller/HomeController.php

# on informe la recréation du templates de base de symfony
echo -e "\n\033[33m!!! Infos :\e[0mRecréation du fichier 'templates/base.html.twig'"
rm templates/base.html.twig
touch templates/base.html.twig

# On touche mainteant les fichier de templates de la page 'home'
echo -e "\n\033[33m!!! Infos :\e[0mCréation du dossier et du fichier 'templates/home/index.html.twig'"
mkdir templates/home/
touch templates/home/index.html.twig

echo -e "\n\033[33m!!! Infos :\e[0mAjout d'un code par défaut dans les fichiers créer précedement"

echo "
<!DOCTYPE html>
<html>
    <head>
        <meta charset='UTF-8'>

        <title>{% block title %}Titre de la page de base{% endblock %}</title>

        {# Les CDN ! important ! ----------------------------------------------------- #}

        <link rel=\"stylesheet\" href=\"https://fonts.googleapis.com/css?family=Roboto:300,400,500,700|Material+Icons\">

        <!-- Jquery --><script src=\"https://code.jquery.com/jquery-3.5.1.min.js\"></script>

        <!-- Popper.js --><script src=\"https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js\" integrity=\"sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN\" crossorigin=\"anonymous\"></script>

        <!-- Bootstrap </!-->
        <link rel=\"stylesheet\" href=\"https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css\" integrity=\"sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z\" crossorigin=\"anonymous\">
        
        <!-- Bootstrap material </!-->
        <link rel=\"stylesheet\" href=\"https://unpkg.com/bootstrap-material-design@4.1.1/dist/css/bootstrap-material-design.min.css\" integrity=\"sha384-wXznGJNEXNG1NFsbm0ugrLFMQPWswR3lds2VeinahP8N0zJw9VWSopbjv2x7WCvX\" crossorigin=\"anonymous\">
        <script src=\"https://unpkg.com/bootstrap-material-design@4.1.1/dist/js/bootstrap-material-design.js\" integrity=\"sha384-CauSuKpEqAFajSpkdjv3z9t8E7RlpJ1UP0lKM/+NdtSarroVKu069AlsRPKkFBz9\" crossorigin=\"anonymous\"></script>
        <script>\$(document).ready(function() { \$('body').bootstrapMaterialDesign(); });</script>
        
        <!-- icons Awesome (don't forget Material Icons) -->
        <script src=\"https://kit.fontawesome.com/35da9d16c3.js\" crossorigin=\"anonymous\"></script>

        <!-- animate.css --><link 
            rel=\"stylesheet\"
            href=\"https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.0.0/animate.min.css\"
          />
        <!-- (...) -->
        {# --------------------------------------------------------------------------- #}

        {% block stylesheets %}

            {{ encore_entry_link_tags('basic') }}

        {% endblock %}

        <div id=\"particles-js\"></div>
        {# Script de particules avec particles.js #}
        <script src=\"https://cdnjs.cloudflare.com/ajax/libs/particles.js/2.0.0/particles.min.js\" integrity=\"sha512-Kef5sc7gfTacR7TZKelcrRs15ipf7+t+n7Zh6mKNJbmW+/RRdCW9nwfLn4YX0s2nO6Kv5Y2ChqgIakaC6PW09A==\" crossorigin=\"anonymous\"></script>

    </head>

    <body>

        {# Ci dessous, la barre de navigation Bootstrap Material ! #}
        <header>
            <nav id=\"navigation\" 
                class=\"navbar fixed-top navbar-light bg-light animate__animated animate__faster\">
                
                <ul class=\"navbar-nav float-right\">
                    <li class=\"nav-item\">
                        <a id=\"super_nav\" class=\"nav-link\" href=\"javascript:void(0)\"><i class=\"material-icons align-middle mr-2\">question_answer</i>
                        <span class=\"d-inline\">Nous contacter</span></a>
                    </li>
                </ul>

                {# son titre de localisation #}
                <a href=\"/#api-map\" id=\"title_location\" class=\"nav-link top-center-nomg animate__animated animate__fast\">
                    <i class=\"material-icons align-middle mr-2\">location_on</i>
                    <span>à [\$localisation\$]</span>
                </a>
            </nav>
        </header>

        {# Logo du haut après le header #}
        <a id=\"title\" class=\"bg-black top-center animate__animated animate__faster\" href=\"/\">Hello World</a>

        {# Bloc invisible gérer par le script de la souris au survol en javascript
            sert à afficher le menu lorsque la souris passe devant #}
        <div id=\"hover_tha_menu\"></div>

        {# Bloc qui sert à espacer la barre de navigation #}
        <div class=\"mt-10\"></div>

        {# Ensuite le block body de chaques rendu controller de Symfony #}
        {% block body %}{% endblock %}

        {# le javascript extend de chaques pages avec vérification du thème actuel #}
        {% block javascripts %}

            {{ encore_entry_script_tags('basic') }}


        {% endblock %}

    </body>

    <footer>
        {% block footer %}
            


        {% endblock %}

        <div class=\"text-white text-center font-coolvetica h5\">Hello Footer</div>
    </footer>

</html>

" >> templates/base.html.twig

# On écrit ensuite le home.html.twig
echo "{% extends 'base.html.twig' %}

{% block title %}Accueil{% endblock %}

{% block stylesheets %}
    {{ parent() }}
    {{ encore_entry_link_tags('home') }}
{% endblock %}

{% block javascripts %}
    {{ parent() }}
    {{ encore_entry_script_tags('home') }}
{% endblock %}


{% block body %}

    {# On créer les avertissements (alertes etc...) Bootstrap + animate.css + fontawesome ! #}

    {% if success is defined and success == '1' %}

        <div id='alert' class='animate__animated animate__flipInX animate__delay-0.6s bg-success text-center p-2 m-1'><i class='far fa-check-circle fa-lg'></i> - Votre inscription a été enregistrée avec succès ! Vous pouvez désormais vous <a href='/connexion'>connecter</a>.</div>
        
    {% endif %}

    {% if success is defined and success == '2' %}

        <div id='alert' class='animate__animated animate__flipInX animate__delay-0.6s bg-success text-center p-2 m-1'>- Salut {{ username }} ! <i class='far fa-smile-wink fa-lg'></i> </div>

    {% endif %}

    {% if error is defined and error == '1' %}

        <div id='alert' class='animate__animated animate__flipInX animate__delay-0.6s bg-warning text-center p-2 m-1'><i class='fas fa-exclamation-triangle fa-lg'></i> - Erreur: Désoler les informations fournies ou le formulaire n'est pas correctement arrivé à destination, peut-être les avait vous envoyer 2 fois.</div>

    {% endif %}

    {% if error is defined and error == '2' %}

        <div id='alert' class='animate__animated animate__flipInX animate__delay-0.6s bg-warning text-center p-2 m-1'><i class='fas fa-exclamation-triangle fa-lg'></i> - Erreur: Désoler, vous êtes déjà connecter.</div>

    {% endif %}

    <div class=\"text-white font-coolvetica h5 ml-4 h-100 \">Hello body</div>

{% endblock %}
" >> templates/home/index.html.twig

echo "<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Session\SessionInterface;
use Symfony\Component\Routing\Annotation\Route;

class HomeController extends AbstractController
{

    // On active les sessions
    private \$session;

    public function __construct(SessionInterface \$session)
    {
        \$this->session = \$session;
    }
    
    /**
     * @Route(\"/\", name=\"home\")
     */
    public function index()
    {

        // on rend la page d'accueil
        return \$this->render('home/index.html.twig', [
            'controller_name' => 'HomeController'
        ]);
        
    }
}
" >> src/Controller/HomeController.php

# On télécharge maintenant les polices d'écriture Bombtrack et Coolvetica 
# que l'on place dans le dossier public/fonts/[FILE(S)] du projet symfony
echo -e "\n\033[33m!!! Infos :\e[0mTéléchargement et création des polices du site \033[33m en cours !\e[0m"
# On créer le dossier fonts
mkdir public/fonts/
# On télécharge les 2 fichiers zip
wget https://dl.dafont.com/dl/?f=bombtrack -O public/fonts/font1.zip
wget https://dl.dafont.com/dl/?f=coolvetica -O public/fonts/font2.zip
# On se place dans le dossier "fonts"
cd public/fonts/
# On dézippe les 2 archives puis on les supprimes oY
unzip font1.zip
unzip font2.zip
rm font1.zip font2.zip
# retour au dossier racine du projet
cd ../../

echo -e "\n\033[33m!!! Infos :\e[0mCréation du fichier /public/particles.json \033[33m en cours !\e[0m"
# On charge ensuite le fichier de particles.js important pour le script du fichier "basic.js"
echo "{
  \"particles\": {
    \"number\": {
      \"value\": 19,
      \"density\": {
        \"enable\": true,
        \"value_area\": 800
      }
    },
    \"color\": {
      \"value\": \"#ffffff\"
    },
    \"shape\": {
      \"type\": \"circle\",
      \"stroke\": {
        \"width\": 0,
        \"color\": \"#000000\"
      },
      \"polygon\": {
        \"nb_sides\": 5
      },
      \"image\": {
        \"src\": \"img/github.svg\",
        \"width\": 100,
        \"height\": 100
      }
    },
    \"opacity\": {
      \"value\": 0.5,
      \"random\": false,
      \"anim\": {
        \"enable\": false,
        \"speed\": 1,
        \"opacity_min\": 0.1,
        \"sync\": false
      }
    },
    \"size\": {
      \"value\": 3,
      \"random\": true,
      \"anim\": {
        \"enable\": false,
        \"speed\": 40,
        \"size_min\": 0.1,
        \"sync\": false
      }
    },
    \"line_linked\": {
      \"enable\": true,
      \"distance\": 150,
      \"color\": \"#ffffff\",
      \"opacity\": 0.4,
      \"width\": 1
    },
    \"move\": {
      \"enable\": true,
      \"speed\": 6,
      \"direction\": \"none\",
      \"random\": false,
      \"straight\": false,
      \"out_mode\": \"out\",
      \"bounce\": false,
      \"attract\": {
        \"enable\": false,
        \"rotateX\": 600,
        \"rotateY\": 1200
      }
    }
  },
  \"interactivity\": {
    \"detect_on\": \"canvas\",
    \"events\": {
      \"onhover\": {
        \"enable\": true,
        \"mode\": \"repulse\"
      },
      \"onclick\": {
        \"enable\": true,
        \"mode\": \"push\"
      },
      \"resize\": true
    },
    \"modes\": {
      \"grab\": {
        \"distance\": 400,
        \"line_linked\": {
          \"opacity\": 1
        }
      },
      \"bubble\": {
        \"distance\": 400,
        \"size\": 40,
        \"duration\": 2,
        \"opacity\": 8,
        \"speed\": 3
      },
      \"repulse\": {
        \"distance\": 200,
        \"duration\": 0.4
      },
      \"push\": {
        \"particles_nb\": 4
      },
      \"remove\": {
        \"particles_nb\": 2
      }
    }
  },
  \"retina_detect\": true
}" >> public/particles.json

# On test de rebuild avec yarn encore dev
echo -e "\n\033[33m!!! Infos Importante :\e[0m re-Test de re-build en cours !"
yarn encore dev

echo -e "\n\033[33m!!! Important :\e[0m Vous pouvez ajouter ou non\n le code suivant, au fichier -> (package.json) :"
echo -e '\n\033[32m{
  "browserslist": [
    "defaults"
  ]
}
\e[0m'

echo -e "\n\033[33m!!! Important :\e[0m Vérifier bien qu'il ni à aucune érreurs après les infos importantes"
echo -e "\nScript Bash \033[32m terminer !\e[0m"
echo -e "Vous pouvez maintenant tester le projet, créer et configurer, dans votre navigateur (http://localhost/)"

echo -e "(n'hésitez pas à soutenir mes projets \033[32mY\e[0m##\033[32mY\e[0miaourt)\n"


