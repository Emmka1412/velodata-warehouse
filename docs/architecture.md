# Architecture

```mermaid
flowchart LR
    subgraph Sources
        CRM[CRM : 3 CSV]
        ERP[ERP : 3 CSV]
    end
    subgraph Bronze
        B[6 tables brutes]
    end
    subgraph Silver
        S[6 tables nettoyées]
    end
    subgraph Gold
        G[Schéma en étoile]
    end
    CRM --> B
    ERP --> B
    B --> S
    S --> G
    G --> A[Analyses métier]
```

- **Bronze** : données brutes, chargées telles quelles depuis les CSV.
- **Silver** : données nettoyées, typées, dédoublonnées et standardisées.
- **Gold** : modèle en étoile (dim_customers, dim_products, fact_sales) prêt pour l'analyse.
