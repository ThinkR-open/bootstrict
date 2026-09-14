# bootstrict — chantiers issus de l'audit

Base : `main` à `6dedde1`, R 4.6.1, shiny 1.14.0, Bootstrap 5.3.8 (vendoré).
Rapport complet : https://claude.ai/code/artifact/3786fafd-4cbf-4914-8551-e2c56057a10a

Une tâche traitée se supprime d'ici. Le code fait foi.

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

### 27. Internationalisation

Libellés en dur sans override : contrôles de carousel (`R/carousel.R:183,220,236`),
toggler de navbar (`R/navbar.R:134`), précédent / suivant de pagination
(`R/pagination.R:227-236,258-267`), fermeture du toast construit en JS. `bs_date_input()`
n'expose ni `language` ni `format` ni `weekstart` : anglais et ISO en dur.

À faire : des arguments par appel plus une option globale `bootstrict.lang`.

### 28. Aucun diagnostic hors Bootstrap 5

`htmltools::renderTags(shiny::fluidPage(bs_card(bs_card_body("hi"))))` charge
`bootstrap@3.4.1` sans un mot : hors `bs_page*()`, rien n'attache `bootstrap_dep()`.
Un message quand Bootstrap 5 n'est pas dans les dépendances éviterait des heures de
débogage.

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
- **RTL** : pas d'argument `dir` sur `bs_page*()`, et la variante RTL de Bootstrap se
  produit par postcss-rtlcss après Sass, hors de portée de `sass`. Le markup utilise déjà les classes logiques, il ne manque que la
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
- Le markup `.form-check` est celui de shiny mais Bootstrap 5 le rattrape ; rendu
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
