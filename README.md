# 🛂 Visa Madagascar - Back-Office (visa_bo)

## 📋 Description
Solution de gestion des demandes de visa pour Madagascar. Elle permet le suivi complet du cycle de vie (workflow) d'une demande, de la soumission initiale jusqu'à la finalité.

L'application gère les visas **transformables** vers les statuts suivants :
*   **Travailleur** : Pour une activité salariée à Madagascar.
*   **Investisseur** : Pour les opérateurs économiques.

Elle permet également de gérer les types de demandes suivants :
*   **Nouveau titre**
*   **Duplicata**
*   **Sans antécédents**

## 🛠️ Stack Technique
*   **Backend** : Spring Boot 3.4 / Java 21
*   **Base de données** : PostgreSQL
*   **Frontend** : Bootstrap 5.3 & jQuery 3.7

## ⚙️ Configuration
1.  **Base de données** : Créer une base nommée `visa_db`.
2.  **Lancement** : `mvn spring-boot:run`
3.  **Accès** : [http://localhost:2025/visa](http://localhost:2025/visa)

## 📁 Structure
*   `controller`, `model`, `repository`, `services` : Code source Java.
*   `static` : Fichiers HTML/CSS/JS.

## 🇲🇬 Contexte
La loi malgache permet la transformation de certains types de visas sur place sous conditions strictes. Ce back-office vise à digitaliser et fluidifier ces démarches.
