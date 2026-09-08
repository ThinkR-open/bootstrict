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

### 16. Quatre composants interactifs ne remontent rien

Bootstrap émet des événements pour eux, une designer les dessinera, et ils n'ont ni `id`
ni valeur ni helper serveur :

- **dropdown** — ouverture, item choisi (`shown.bs.dropdown`) ;
- **pagination** — page active ; le composant est purement `href`, totalement inerte ;
- **nav** — lien actif hors tabset (`R/nav-tabs.R:95` documente un `id` qui ne sert à rien) ;
- **alert** — fermeture (`closed.bs.alert`), et pas de fermeture depuis le serveur.

### 17. Les `updateXxx()` de shiny cassent le markup des groupes

`shiny:::generateOptions` n'a pas de branche par thème et sort toujours
`<div class="radio"><label><input>`. Le binding remplace tout le bloc d'options sur
update, donc après `updateRadioButtons(session, id, choices = …)` le contrôle a perdu
`.form-check`, `.form-check-input` et `.form-check-label`.

`vignettes/bootstrict.Rmd:150-152` promet pourtant que les `updateXxx()` de Shiny
« continuent de fonctionner à l'identique ».

À faire : `update_bs_radio_input()` / `update_bs_checkbox_group_input()` qui envoient le
markup enrichi, ou un shim JS qui réapplique les classes après `receiveMessage`. Corriger
la promesse de la vignette.

### 18. `.btn-check` absent

Les groupes de boutons à cocher / radio (contrôles segmentés) n'existent nulle part :
`grep -rn "btn-check" R/ inst/ vignettes/` ne renvoie rien. Non constructibles à partir
des inputs existants, qui passent tous par `form_check_enhance()`.

### 19. `bs_file_input()` rend du Bootstrap 3

`R/forms-controls.R:535-720` — motif « bouton Browse » (`span.btn-file` +
`input[type=text]` en lecture seule) au lieu du `<input class="form-control" type="file">`
de 5.3.

Même famille : `bs_date_input()` / `bs_date_range_input()` embarquent
bootstrap-datepicker, dont le popup n'est pas du markup 5.3, et le range laisse fuir
`.input-group-addon` et force `input-group-sm`.

### 20. Les constructeurs à panneaux refusent `lapply()`

`R/nav-tabs.R:181-197`, `R/accordion.R:39-63`, `R/carousel.R:78-90`, `R/progress.R:52-66`

```r
bs_tabset("t", lapply(1:2, function(i) bs_tab_panel(paste("T", i), "body")))
#> Error
```

Générer les panneaux en boucle est le cas d'usage principal dans une app pilotée par les
données, et `dev/CONVENTIONS.md` demande de laisser htmltools aplatir les listes.

À faire : aplatir les enfants de type `list` avant la validation de type.

### 21. Oublier l'`id` initial ne déclenche aucune erreur

`bs_tabset(bs_tab_panel("A", "a"))` rend
`<ul class="nav nav-tabs" id="A A NULL list(&quot;a&quot;) NULL"></ul>` sans un mot. Sur
une API dont la convention centrale est « l'`id` en premier », c'est l'erreur que tout le
monde fera. Idem `bs_modal()`.

### 22. Bugs localisés restants

- `bs_accordion_panel()` et `bs_tab_panel()` rendent les `...` **nommés** comme du texte
  de corps au lieu d'attributs : `data-bs-theme = "dark"` s'affiche littéralement.
- `bs_tab_panel()` avec un titre en tag produit du HTML échappé comme valeur :
  `data-value="&lt;span&gt;Home&lt;/span&gt;"`. Idem `bs_accordion_panel()`
  (`value = as.character(value %||% title)`).
- `bs_input_group()` retire le nœud `.form-text` mais garde `aria-describedby` :
  référence ARIA orpheline.
- `bs_floating_label()` pose un `placeholder` invalide sur un `<select>`.
- `bs_collapse_trigger()` avec un vecteur de cibles n'en garde que la première dans
  `data-bs-target`, tout en listant les deux dans `aria-controls`.
- `bs_scrollspy()` ne s'active jamais et ne remonte rien quand il est initialisé dans un
  onglet masqué (vérifié en navigateur sur l'app de démo).
- `bs_nav_link(disabled = TRUE)` garde `href="#"` sans `tabindex="-1"` : le lien reste
  activable au clavier.
- Une modal composée à la main n'a pas de nom accessible : `aria-labelledby`
  n'est posé que par le raccourci `title=`. Refléter l'id d'un
  `bs_modal_title()` présent dans les enfants.
- `bs_table(align=)` n'est pas validé : n'importe quelle chaîne devient une classe
  `align-*` inexistante.
- `bs_img()` et `bs_card_img()` émettent un `<img>` sans attribut `alt` du tout quand
  `alt = NULL`.

### 23. Documentation manquante côté développeur

- Le `ns()` dans les modules : le serveur namespace tout seul, mais la moitié UI exige un
  `ns()` manuel (`bs_modal_trigger(ns("info"))`). `grep -rn "ns("` sur `vignettes/` et
  `README.md` ne renvoie rien.
- Le contenu de modal dynamique par `uiOutput` : cas courant, ni documenté ni supporté,
  l'app vitrine s'en sort par un contournement (`inst/examples/quakewatch/app.R:1187-1196`).
- Le motif de page à navbar qui change de contenu (équivalent `navbarPage()` /
  `bslib::page_navbar()`) : c'est ce que dessine une maquette de navbar.
- Une page sur les utilitaires et l'Utility API : la posture « les utilitaires, tu les
  passes en `class=` » fonctionne mais n'est écrite nulle part.
- 28 exports n'apparaissent dans aucun `\examples`, 8 topics Rd n'en ont aucun
  (`bootstrict-package`, `bootstrict_dep`, `bs_close_button`, `bs_numeric_input`,
  `bs_password_input`, `bs_textarea_input`, `update_bs_accordion`, `use_bootstrict`).

### 24. `bs_table()` incomplet face à la doc

Pas de variante `.table-light` / `.table-dark` sur le `<thead>` généré, pas de
`.table-striped-columns` (`striped` est booléen), pas de `.table-group-divider`, pas de
variantes de ligne ou de cellule, pas de `.caption-top`.

---

## Plus tard

### 25. Options JS non exposées

- tooltip / popover : 3 options sur ~17 (ni `delay`, `offset`, `container`,
  `customClass`, `sanitize`, ni placement `auto`), aucune des 11 méthodes, et aucun
  contrôle serveur.
- dropdown : `auto-close`, `offset`, `reference`.
- carousel : `touch`, `pause`, `wrap`, `keyboard`, `ride="true"`, méthodes `pause` / `cycle`.
- scrollspy : seul le `offset` déprécié est exposé, sans `rootMargin` ni `threshold` ni
  `refresh()`. Remonte le lien parent sur les navs imbriquées.

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
