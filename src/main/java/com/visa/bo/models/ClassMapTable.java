package com.visa.bo.models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.visa.bo.exceptions.DataAccessException;
import com.visa.bo.util.UtilDB;

/**
 * Classe mère pour lier une classe à une table et générer des IDs métier (ex: USR0000001).
 * Utilise une table id_sequences pour une génération thread-safe/transactionnelle.
 */
public abstract class ClassMapTable {

    private static final Logger LOGGER = Logger.getLogger(ClassMapTable.class.getName());
    private static volatile UtilDB defaultUtilDB;

    private final UtilDB utilDB;
    private final String tableName;     // ex: utilisateur
    private final String idColumn;      // ex: id
    private final String prefix;        // ex: USR
    private final int numericLength;    // ex: 7 -> USR0000001

    /**
     * Constructeur.
     * @param utilDB instance UtilDB (pour tests/injection), si null un nouveau UtilDB sera instancié.
     */
    protected ClassMapTable(String tableName, String idColumn, String prefix, int numericLength, UtilDB utilDB) {
        validateIdentifier(tableName, "tableName");
        validateIdentifier(idColumn, "idColumn");
        if (prefix == null || prefix.isEmpty()) throw new IllegalArgumentException("prefix ne peut pas être vide");
        if (numericLength <= 0) throw new IllegalArgumentException("numericLength doit être > 0");

        this.utilDB = (utilDB != null) ? utilDB : null;
        this.tableName = tableName;
        this.idColumn = idColumn;
        this.prefix = prefix;
        this.numericLength = numericLength;
    }

    // Surcharge pratique si tu veux pas passer UtilDB
    protected ClassMapTable(String tableName, String idColumn, String prefix, int numericLength) {
        this(tableName, idColumn, prefix, numericLength, null);
    }

    public static void setDefaultUtilDB(UtilDB utilDB) {
        defaultUtilDB = utilDB;
    }

    /* ========== GETTERS ========== */
    public String getTableName() { return tableName; }
    public String getIdColumn() { return idColumn; }
    public String getPrefix() { return prefix; }
    public int getNumericLength() { return numericLength; }

    /* ========== Méthodes publiques ========== */

    /**
     * Génère un nouvel ID en utilisant la connexion fournie par UtilDB.
     * @return nouvel ID complet (prefix + padded number)
     * @throws DataAccessException si erreur DB
     */
    public String generateId() throws DataAccessException {
        UtilDB activeUtilDB = (utilDB != null) ? utilDB : defaultUtilDB;
        if (activeUtilDB == null) {
            throw new IllegalStateException("UtilDB non initialise pour ClassMapTable");
        }

        try (Connection conn = activeUtilDB.getConn()) {
            return generateId(conn);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Erreur lors de l'obtention de la connexion pour générer l'ID", e);
            throw new DataAccessException("Erreur de connexion à la base lors de la génération d'ID", e);
        }
    }

    /**
     * Génération transactionnelle basée sur la table id_sequences.
     * Utilise SELECT ... FOR UPDATE pour rendre l'opération atomique.
     */
    protected String generateId(Connection conn) throws DataAccessException {
        try {
            ensureSequencesTableExists(conn);

            // Début transaction
            boolean previousAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);

            try {
                Long lastValue = null;
                // 1) essayer de récupérer la séquence (verrouillée)
                String selectSeqSql = "SELECT last_value, numeric_length FROM id_sequences WHERE table_name = ? FOR UPDATE";
                try (PreparedStatement ps = conn.prepareStatement(selectSeqSql)) {
                    ps.setString(1, tableName);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            lastValue = rs.getLong("last_value");
                        }
                    }
                }

                if (lastValue == null) {
                    // 2) pas de séquence existante -> initialiser à partir du MAX(id) existant
                    long derived = deriveLastFromTable(conn);
                    // Insert initial row with derived value
                    String insertSql = "INSERT INTO id_sequences(table_name, prefix, last_value, numeric_length) VALUES (?, ?, ?, ?)";
                    try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                        psInsert.setString(1, tableName);
                        psInsert.setString(2, prefix);
                        psInsert.setLong(3, derived);
                        psInsert.setInt(4, numericLength);
                        psInsert.executeUpdate();
                    }
                    lastValue = derived;
                }

                long next = lastValue + 1L;

                // 3) mettre à jour la séquence
                String updateSql = "UPDATE id_sequences SET last_value = ? WHERE table_name = ?";
                try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                    psUpdate.setLong(1, next);
                    psUpdate.setString(2, tableName);
                    psUpdate.executeUpdate();
                }

                conn.commit();

                // formatage
                String numericPart = String.format("%0" + numericLength + "d", next);
                return prefix + numericPart;

            } catch (SQLException e) {
                try { conn.rollback(); } catch (SQLException ex) { LOGGER.log(Level.SEVERE, "Rollback failed", ex); }
                LOGGER.log(Level.SEVERE, "Erreur lors de la génération d'ID pour la table " + tableName, e);
                throw new DataAccessException("Erreur lors de la génération d'ID", e);
            } finally {
                try { conn.setAutoCommit(previousAutoCommit); } catch (SQLException e) { LOGGER.log(Level.WARNING, "Impossible de restaurer autoCommit", e); }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Erreur SQL inattendue", e);
            throw new DataAccessException("Erreur SQL inattendue lors de la génération d'ID", e);
        }
    }

    /* ========== Helpers privés ========== */

    /**
     * Crée la table id_sequences si elle n'existe pas.
     */
    private void ensureSequencesTableExists(Connection conn) throws SQLException {
        final String ddl = """
            CREATE TABLE IF NOT EXISTS id_sequences (
                table_name TEXT PRIMARY KEY,
                prefix TEXT NOT NULL,
                last_value BIGINT NOT NULL,
                numeric_length INT NOT NULL
            )
            """;
        try (Statement st = conn.createStatement()) {
            st.execute(ddl);
        }
    }

    /**
     * Lit la valeur MAX(idColumn) dans la table et en déduit la partie numérique.
     * Retourne 0 si aucun enregistrement existant.
     */
    private long deriveLastFromTable(Connection conn) throws SQLException {
        // construction SQL (identifiants validés plus haut)
        String sql = "SELECT MAX(" + idColumn + ") FROM " + tableName + " WHERE " + idColumn + " LIKE ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, prefix + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String maxId = rs.getString(1);
                    if (maxId != null && maxId.length() > prefix.length()) {
                        String numeric = maxId.substring(prefix.length());
                        try {
                            return Long.parseLong(numeric);
                        } catch (NumberFormatException nfe) {
                            LOGGER.log(Level.WARNING, "Impossible de parser la partie numérique de l'ID existant: " + maxId, nfe);
                            // Si parsing échoue, safer choice: start from 0 so next => 1
                            return 0L;
                        }
                    }
                }
            }
        }
        return 0L;
    }

    /**
     * Valide les identifiants SQL simples (nom de table/colonne).
     * Refuse les valeurs contenant espaces, ; ou caractères suspects.
     */
    private void validateIdentifier(String ident, String paramName) {
        if (ident == null || ident.trim().isEmpty()) {
            throw new IllegalArgumentException(paramName + " ne peut pas être vide");
        }
        // regex stricte: commence par lettre ou underscore, puis lettres/chiffres/underscore
        if (!ident.matches("^[A-Za-z_][A-Za-z0-9_]*$")) {
            throw new IllegalArgumentException("Identifiant SQL invalide pour " + paramName + ": " + ident);
        }
    }
}
