# bootstrict — chantiers issus de l'audit

Base : `main` à `6dedde1`, R 4.6.1, shiny 1.14.0, bslib 0.11.0 (Bootstrap 5.3.8).
Rapport complet : https://claude.ai/code/artifact/3786fafd-4cbf-4914-8551-e2c56057a10a

Une tâche traitée se supprime d'ici. Le code fait foi.

---

## Avant de publier

### 12. Le site pkgdown annonce dans DESCRIPTION renvoie 404

Rien a corriger dans le depot : `.github/workflows/pkgdown.yaml` a ete ajoute
au commit `6dedde1`, qui n'est pas sur le distant (`origin/main` est a
`e5b205d`, soit 14 commits en arriere). Le workflow n'a donc jamais tourne et
la branche `gh-pages` n'existe pas.

A faire : pousser, verifier que le run pkgdown aboutit et que GitHub Pages est
active sur `gh-pages`. Si le site n'est pas prevu, retirer l'URL de
`DESCRIPTION` et de `man/bootstrict-package.Rd`.

C'est la seule NOTE qui reste a `R CMD check --as-cran` (avec la mention
« New submission » et la version de developpement).

---

## Ensuite

### 19. Les inputs date embarquent bootstrap-datepicker

`R/forms-controls.R` — `bs_date_input()` et `bs_date_range_input()` deleguent a
shiny, qui charge bootstrap-datepicker. Son popup n'est pas du markup 5.3 : il
n'est nulle part dans la doc Bootstrap. Une designer qui dessine un champ date
dessine un `.form-control` et compte sur le selecteur natif du navigateur.

Le markup du champ lui-meme est desormais propre (taille pilotee, add-on 5.3
pour le separateur du range) ; c'est le widget de selection qui reste hors
perimetre Bootstrap.

Passer a `<input type="date">` reglerait le probleme mais c'est une decision
d'API : on perd `shiny::updateDateInput()`, les arguments `format` /
`language` / `datesdisabled`, et `input$id` change de semantique. A trancher
avant de le faire.

---

## Plus tard

### 25. Contrôle serveur des tooltips et popovers

Bootstrap expose `show` / `hide` / `enable` / `disable` / `setContent` sur
Tooltip et Popover ; rien de tout ca n'est atteignable depuis le serveur. Les
options passent maintenant par `...` (`data-bs-delay`, `data-bs-container`,
`data-bs-custom-class`...) et `placement = "auto"` est accepte, donc il ne
reste que les methodes.

A trancher : un tooltip decore un tag qui a souvent deja un id, donc
`update_bs_tooltip("save", title = "...")` serait faisable. Mais rien
n'oblige la cible a avoir un id, et en inventer un casserait le contrat
"minimum de deviation".

### 26. Modes couleur incomplets

`data-bs-theme` est posé sur `<body>` alors que la doc le met sur `<html>`. Le sélecteur
canonique de la doc (auto / `prefers-color-scheme` / `localStorage`) est absent — aucune
occurrence de `localStorage` dans le dépôt — et le mode courant n'est jamais remonté au
serveur. `binding-color-mode.js` fait 16 lignes.

### 27. Internationalisation

Libellés en dur sans override : contrôles de carousel (`R/carousel.R:183,220,236`),
toggler de navbar (`R/navbar.R:134`), précédent / suivant de pagination
(`R/pagination.R:227-236,258-267`), fermeture du toast construit en JS. `bs_date_input()`
n'expose ni `language` ni `format` ni `weekstart` : anglais et ISO en dur.

À faire : des arguments par appel plus une option globale `bootstrict.lang`.

### 28. Aucun diagnostic hors Bootstrap 5

`htmltools::renderTags(shiny::fluidPage(bs_card(bs_card_body("hi"))))` charge
`bootstrap@3.4.1` sans un mot. Un message quand aucun thème bslib 5 n'est actif éviterait
des heures de débogage.

### 29. Reste de la surface Bootstrap 5.3

- **toast** : sans `title`, aucun bouton de fermeture, donc un toast `autohide = FALSE`
  est indéfermable ; pas de `.text-bg-*` ni de structure « contenu libre » ; `role` et
  `aria-live` figés sur `alert` / `assertive`, la variante polie est inatteignable.
- **navbar** : tous les enfants sont forcés dans le `.collapse` et le toggler est
  inconditionnel — pas de navbar offcanvas, rien ne peut rester hors de la zone repliable.
- **tabset** : impossible de désactiver un onglet, d'y loger un dropdown, ou de retirer
  `.fade`. Pas de parité `insertTab()` / `removeTab()` / `hideTab()` / `showTab()`.
- **collapse** : « Multiple toggles and targets » impossible, `bs_collapse_trigger()`
  construit toujours un sélecteur d'id.
- **forms** : `.form-control-plaintext`, formulaires horizontaux (`.col-form-label`),
  datalists, attribut `size` sur `bs_select_input()` (liste déroulante à n lignes), et
  `disabled` / `readonly` / `required` en vrais arguments documentés.
- **layout** : gouttières responsives (`.g-2 .g-lg-3`), page CSS Grid entière
  (`.grid`, `.g-col-*`, `.g-start-*` ; `$enable-cssgrid` fonctionne mais n'est documenté
  nulle part).
- **helpers** : `.visually-hidden-focusable`, `--bs-aspect-ratio` personnalisé sur
  `bs_ratio()`, `.sticky-{bp}-*`.
- **bs_blockquote()** : `class` et attributs vont sur le `<blockquote>`, la doc place
  l'alignement sur la `<figure>`.
- **bs_spinner()** : le motif « spinner dans un bouton » n'est pas exprimable, un `<div>`
  est émis dans le `<button>`.
- **bs_notify_toast()** : loin de la parité `showNotification()` — texte seul, pas d'`id`
  pour retirer, pas d'action.
- **bookmarking** : aucun widget n'est restaurable (pas de `restoreInput()` dans
  `bs_range_input()` / `bs_color_input()`, pas de `getState` dans les bindings).
- **RTL** : pas d'argument `dir` sur `bs_page*()`, et bslib ne livre pas de
  `bootstrap.rtl.css`. Le markup utilise déjà les classes logiques, il ne manque que la
  coquille.

---

## Vérifié et conforme, ne pas y toucher

Points soulevés pendant l'audit où la vérification contradictoire a conclu que le code
avait raison.

- `bs_close_button(white = TRUE)` fonctionne : en 5.3 la variante sombre passe par une
  variable CSS, pas par une règle descendante. Et c'est testé (`test-bs53.R:44-49`).
- Les états *toggle* de bouton et la variante `<input class="btn">` s'obtiennent par les
  arguments documentés (`class=` et `...` nommés).
- Le badge de notification positionné est un pur assemblage d'utilitaires, déjà faisable.
- Les placeholders en forme de bouton : `bs_button(disabled = TRUE, class = "placeholder col-6")`.
- Le markup `.form-check` est celui de shiny mais bslib le rattrape ; rendu
  pixel-identique à la référence, vérifié en navigateur.
- L'imbrication `aria-live` de `bs_notify_toast()` est exactement ce que fait la doc.
- La région repliable de la navbar est bien pilotable par `update_bs_collapse()`.
- Le markup est identique dans et hors `bs_page()` : pas de retour en Bootstrap 3 au
  rendu initial.
- Le namespacing modules côté serveur est correct de bout en bout.
- Valeurs initiales correctes pour accordion (0, 1, n panneaux), tabset, collapse, overlays.
- Aucune injection HTML brute : l'échappement htmltools est propre partout.
- Les deux apps de démo tournent sans exception JS, sans id dupliqué, sans cible
  orpheline, sans avertissement R.
