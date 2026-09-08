# bootstrict — chantiers issus de l'audit

Base : `main` à `6dedde1`, R 4.6.1, shiny 1.14.0, bslib 0.11.0 (Bootstrap 5.3.8).
Rapport complet : https://claude.ai/code/artifact/3786fafd-4cbf-4914-8551-e2c56057a10a

Une tâche traitée se supprime d'ici. Le code fait foi.

---

## Avant de publier

### 6. Composer une modal à la main imbrique le header dans le body

`R/modal.R:130`, contredit le roxygen `R/modal.R:9-11`

`bs_modal()` emballe inconditionnellement tous les enfants non nommés dans
`bs_modal_body()`, alors que sa propre doc invite à composer avec `bs_modal_header()` /
`bs_modal_body()` / `bs_modal_footer()`. Résultat :
`.modal-content > .modal-body > (.modal-header, .modal-body)`. Casse le header collant et
le body défilable.

À faire : n'emballer que si aucun enfant ne porte déjà `.modal-header` / `.modal-body` /
`.modal-footer`.

### 7. Le bouton de fermeture d'un offcanvas responsive ne fait rien

`R/offcanvas.R:112-115`

Un offcanvas responsive reçoit `.offcanvas-lg` à la place de `.offcanvas` (correct), mais
le bouton n'a que `data-bs-dismiss="offcanvas"`. Bootstrap résout la cible par
`getElementFromSelector(this) || this.closest('.offcanvas')` : sans `data-bs-target` et
sans la classe, la cible est `null`.

À faire : toujours poser `data-bs-target = css_id_selector(id)` sur ce bouton.

### 8. `bs_progress(height=)` produit du CSS invalide sur les barres empilées

`R/progress.R:160-167`

Chaque segment reçoit deux attributs `style` séparés ; htmltools les joint par une espace,
pas par `"; "`. Le rendu est `style="width: 15% height: 10px"`, que le navigateur jette
entièrement : le groupe empilé devient invisible dès qu'on passe `height`.

À faire : une seule chaîne
`paste(c(paste0("width: ", pct, "%"), height_style), collapse = "; ")` avant l'unique
`tagAppendAttributes()`. Ajouter un test `bs_progress(bar, bar, height = "10px")`.

### 9. `bs_list_unstyled()` / `bs_list_inline()` imbriquent un `<li>` dans un `<li>`

`R/content.R:562`, `R/content.R:598`, usage documenté en `vignettes/content.Rmd:141-147`

Les deux emballent chaque enfant dans un `tags$li()` neuf. La vignette dit de passer des
`tags$li()` explicites pour les items riches : le parseur ferme alors le premier `li`, on
obtient un `<li class="list-inline-item">` vide suivi d'un `<li>` nu sans la classe.

À faire : laisser passer tel quel un enfant qui est déjà une `shiny.tag` nommée `"li"`
(en lui ajoutant `.list-inline-item` pour `bs_list_inline()`), n'emballer que le reste.

### 10. `bs_input_group_text()` contenant une checkbox est détruit

`R/forms-layout.R:77-133`

`ig_unwrap_control()` descend dans n'importe quel enfant contenant un
`.shiny-input-container` et renvoie le premier contrôle trouvé en jetant tout autour. Le
`<span class="input-group-text">` disparaît — c'est le motif « checkbox dans un input
group » de la doc.

À faire : ne déballer que les enfants de premier niveau qui sont eux-mêmes des wrappers
`.shiny-input-container`, sauter ceux qui portent déjà `.input-group-text`.

### 11. `bs_table()` corrompt les tibbles

`R/content.R:222-232`, `R/content.R:243-258`

L'extraction par `data[i, j]` tombe en vecteur sur un data.frame mais renvoie un data
frame 1×1 sur un tibble : `as.character()` sur une liste rend le stockage sous-jacent.

```r
bs_table(tibble::tibble(f = factor(c("a", "b")), d = as.Date("2020-01-01")))
#> <td>1</td><td>18262</td>
```

Deux défauts voisins dans la même fonction : `as.character()` rend `100000` en `"1e+05"`
et `1/3` en `"0.333333333333333"` ; les `row.names` sont jetés, donc
`bs_table(head(mtcars))` perd les noms de voitures.

À faire : indexer la colonne (`format_cell(data[[j]][[i]])`), utiliser `format()` plutôt
que `as.character()`, ajouter un argument `rownames=` émettant le `<th scope="row">` de
la référence.

### 12. Nettoyage de publication

- `inst/examples/quakewatch/rsconnect/connect.thinkr.fr/colin/quakewatch.dcf` part dans
  le tarball avec le nom du serveur et de l'utilisateur : ajouter
  `^inst/examples/quakewatch/rsconnect$` à `.Rbuildignore` (vérifier avec `tar tzf`).
- Le site annoncé dans `DESCRIPTION` renvoie 404 : aucune branche `gh-pages`, le workflow
  pkgdown n'a jamais abouti, et `docs/` est à la fois non suivi par git et dans
  `.Rbuildignore`. Choisir une stratégie, ou retirer l'URL en attendant.
- `NEWS.md` n'a pas de section `0.2.0` alors que `DESCRIPTION` dit `0.2.0` : tout est sous
  « (development version) ».
- Ajouter `^\.\.Rcheck$` à `.Rbuildignore` (le dossier `..Rcheck` traîne à la racine).

---

## Ensuite

### 13. Pas de dropdown de nav ni de navbar

`R/navbar.R:7` recommande de composer avec `bs_dropdown()`, mais celui-ci rend toujours
`<div class="dropdown"><button class="btn btn-secondary dropdown-toggle">`. Posé dans
`bs_navbar_nav()`, ça donne un `<div>` enfant direct de `<ul class="navbar-nav">` (HTML
invalide) et un bouton gris dans la navbar. C'est le composant le plus dessiné en maquette.

À faire : un `bs_nav_dropdown(label, ...)`, ou un mode `nav = TRUE` sur `bs_dropdown()`,
rendant `<li class="nav-item dropdown"><a class="nav-link dropdown-toggle" role="button">`
plus `<ul class="dropdown-menu">`.

### 14. Aucun test navigateur sur les bindings

937 lignes de JS, zéro test : `grep -rn "testServer|shinytest2|chromote" tests/` ne
renvoie rien. Les 99,4 % de couverture ne concernent que `R/`. Les quatre bloquants
ci-dessus sont tous du JS ou de la frontière R/JS, et aucun n'a été vu par 999 tests.

À faire : un test `chromote` minimal sur `inst/examples/demo` qui vérifie l'absence
d'exception JS, les valeurs initiales des inputs, et un aller-retour par widget interactif.

### 15. Aucun test de snapshot

`grep -rn "expect_snapshot" tests/` renvoie 0, `tests/testthat/_snaps` n'existe pas. Le
contrat unique du package est la fidélité du markup à l'octet près.

À faire : un `expect_snapshot()` du HTML rendu par constructeur, pour que toute
régression de fidélité sorte en diff.

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
