# Rapport qualité — couche Bronze

Audit réalisé avec [`sql/audit/bronze_profiling.sql`](../sql/audit/bronze_profiling.sql) sur les 6 tables Bronze (116 294 lignes).
Chaque anomalie est mesurée, puis traitée en couche Silver selon la décision ci-dessous.

## Synthèse

- **12 anomalies** détectées, réparties sur les 6 sources.
- **Aucune vente n'est supprimée** : le chiffre d'affaires total est préservé.
- **4 lignes seulement sont écartées** (clients sans identifiant), plus 6 doublons fusionnés.
- Principe directeur : **corriger quand on peut retrouver la valeur, neutraliser quand on ne peut pas, ne jamais supprimer une ligne utile.**

## Anomalies et décisions

| # | Anomalie | Volume | Décision | Justification |
| --- | --- | --- | --- | --- |
| A1 | Clients sans identifiant | 4 lignes | **Écarter** | Impossible de relier ces lignes aux ventes ou à l'ERP |
| A2 | Clients en double | 5 identifiants (11 lignes) | **Garder la fiche la plus récente** | La fiche la plus récente corrige la précédente (ex. : prénom vide le 25/01, complété le 27/01) |
| A3 | Espaces parasites dans les noms | 29 lignes | **Corriger** (`TRIM`) | Les espaces faussent les recherches et les regroupements |
| A4 | Genre et état civil codés (F/M, S/M) ou vides | 4 578 / 7 lignes vides | **Décoder** en libellés lisibles, **valeur par défaut** `n/a` si vide | Un utilisateur métier doit lire `Female`, pas `F` ; `n/a` est explicite, `NULL` ne l'est pas |
| A5 | Coût produit manquant | 2 lignes | **Valeur par défaut** `0` | Le coût est inconnu, mais le produit doit rester au catalogue pour ses ventes |
| A6 | Date de fin antérieure à la date de début | 200 lignes | **Corriger** : fin = début de la version suivante − 1 jour | Les dates de fin sources sont incohérentes ; l'enchaînement des versions permet de les recalculer. La version la plus récente reste ouverte (`NULL`) |
| A7 | Date de commande invalide (0 ou mal formée) | 19 lignes | **Mettre à NULL**, garder la vente | La date est irrécupérable, mais le montant compte dans le chiffre d'affaires |
| A8 | Montant ou prix incohérent | 35 lignes | **Corriger** : montant = quantité × \|prix\| ; prix = montant ÷ quantité s'il manque | Les trois valeurs sont liées : deux valeurs fiables suffisent à recalculer la troisième |
| A9 | Date de naissance dans le futur | 16 lignes | **Mettre à NULL**, garder le client | La date est impossible, mais le client, ses achats et son pays restent valables |
| A10 | Genre ERP écrit de 8 façons | 8 variantes | **Normaliser** en `Female` / `Male` / `n/a` | `M`, `Male`, `M ` désignent la même valeur |
| A11 | Pays écrit de 12 façons | 12 variantes | **Normaliser** : `DE` → `Germany`, `US`/`USA` → `United States`, vide → `n/a` | Sans cela, les États-Unis seraient comptés comme 3 pays différents |
| A12 | Produits sans catégorie ERP | 7 produits | **Signaler**, garder les produits | Ce n'est pas une erreur de format : la catégorie manque à la source. Les produits apparaîtront sans catégorie |

## Points à valider avec le métier

Ces cas ne sont pas des erreurs techniques. La décision revient aux équipes métier, pas au data engineer :

1. **17 clients nés avant 1925** (plus de 100 ans) : anomalie de saisie ou clients réels ? Conservés tels quels en attendant.
2. **Conflits de genre CRM / ERP** : quand les deux sources se contredisent, le CRM est considéré comme source maître. Règle à confirmer.
3. **7 produits sans catégorie** : faut-il compléter le référentiel ERP ?
