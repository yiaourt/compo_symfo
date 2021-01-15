# compo_symfo
"compo_symfo" est script Bash(Linux) qui permet de lancer une maquette d'un site web (Symfony) pour y faciliter la conception, le script se charge de vous demandez si vous avez besoin d'installer tout un serveur sur votre machine ainsi que tous les composants (composer, git, Symfony) et vous laisses le choix de la maquette à créer, maquette qui, une fois créer, vous permet d'avoir un site prototype prêt à être entièrement modifié !



 **Utilisation :** compo_symfo(.sh) [OPTION: -new]
 
 **Usage :** Dans le dossier racine du projet Symfony créer précedement! -> ./compo_symfo(.sh)
        Ou alors dans le dossier "/var/www/" avec l'option new -> ./compo_symfo(.sh) -new
 
 **Pour Debian/Ubuntu (Contactez moi pour une version Arch avec Pacman.. etc ...)**
      
       Options : 
               (pas d'options) : 
                             Déroulement du script dans le projet symfony créer précedement! --->
                             
         - Installation de filesystem, apache-pack, Webpack-Encore, Node-Sass, PostCSS et autoprefixer
         pour le projet Symfony.
         - Debug de la "Debug Toolbar" de Profiler (du à la configuration d'apache)
         - Configuration de Webpack-Encore.
         - Configuration des fichiers assets (JS et SCSS).
         - Configuration des fichiers Controller et Templates de Symfony.
         - Téléchargement de quelques polices d'écritures dans le dossier racine du projet : public/fonts/
         - Configuration du fichier de particles.js
               
               
               -new (Installe tous les composants nécessaire de A à Z)
                              Déroulement du script dans le dossier "/var/www/" ->
                                            
        - Paquets LAMP (+ php et mysql)
        - Github (obligatoire pour symfony client)
        - Symfony client et Symfony 5.1
        - Composer
        - Node JS
        - Yarn
        - ensuite, création du projet symfony
        - puis on passe à la suite du script comme si il ni avait pas eu l'option -new

 **Yiaourt oY**
