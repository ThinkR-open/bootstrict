On va faire ici un package R qui va être une série de widget pour shiny.

Voici mon objectif :

Je vais travailler avec une designer freelance qui connait boostrap. On lui a donné comme consigne "open bar sur Bootstrap 5, ce que tu trouves sur https://getbootstrap.com/docs/5.0 tu as le droit de l'utiliser dans ta maquette, mais pas plus"

Elle va créer des maquettes et exporter des variables SASS. Mon but est de pouvoir prendre sa maquette et ses variables et le mettre dans une app shiny.

Mon pain point actuel : certains composants de shiny sont hors bootstrap, et certains composants boostrap ne sont pas dans shiny.

Je veux donc un package R qui implémente TOUS ce qui peut se faire dans Boostrap 5, avec le minimum de variation par rapport à shiny.

Je veux pouvoir refaire les layouts, les forms, les components, etc.

Tu vas me créer le package qui implémente tout ça.
