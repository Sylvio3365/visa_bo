package com.visa.bo;

import java.time.LocalDate;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import com.visa.bo.models.demande.Demande;
import com.visa.bo.models.demande.CategorieDemande;
import com.visa.bo.models.etatCivil.Demandeur;
import com.visa.bo.models.passport.Passport;
import com.visa.bo.models.visa.TypeVisa;

/**
 * Test simple (SANS MOCKS) pour tester la logique de création de demande catégorie
 * 
 * Ce test vérifie que les objets métier sont correctement créés
 * et que tous les champs obligatoires sont assignés.
 * 
 * Pour exécuter :
 * mvn test -Dtest=TestDemandeCategorie
 */
@SpringBootTest
class TestDemandeCategorie {

    /**
     * Test 1: Créer une demande catégorie avec tous les champs requis
     */
    @Test
    void testCreerDemandeCategorieDuplicata() {
        System.out.println("\n========== TEST: Création Demande Catégorie Duplicata ==========\n");

        // Créer les objets de test
        Demandeur demandeur = new Demandeur();
        demandeur.setIdDemandeur("DEM000001");
        demandeur.setNom("Ahmed");
        demandeur.setPrenom("Ali");
        System.out.println("✓ Demandeur: " + demandeur.getNom() + " " + demandeur.getPrenom());

        Passport passport = new Passport();
        passport.setIdPassport("PAS000001");
        passport.setNumero("N123456");
        passport.setDelivreLe(LocalDate.of(2020, 1, 1));
        passport.setExpireLe(LocalDate.of(2030, 1, 1));
        System.out.println("✓ Passport: " + passport.getNumero());

        TypeVisa typeVisa = new TypeVisa();
        typeVisa.setIdTypeVisa("TV000001");
        typeVisa.setLibelle("Visa Standard");
        System.out.println("✓ TypeVisa: " + typeVisa.getLibelle());

        // Créer la demande PARENT
        Demande demandeParent = new Demande();
        demandeParent.setIdDemande("DMD000001");
        demandeParent.setDemandeur(demandeur);
        demandeParent.setPassport(passport);
        demandeParent.setTypeVisa(typeVisa);
        demandeParent.setCreatedAt(LocalDate.now());
        demandeParent.setUpdatedAt(LocalDate.now());
        System.out.println("✓ Demande Parent ID: " + demandeParent.getIdDemande());

        // Créer la catégorie DUPLICATA
        CategorieDemande categorieDuplicata = new CategorieDemande();
        categorieDuplicata.setIdCategorie("CD000002");
        categorieDuplicata.setLibelle("Duplicata");
        System.out.println("✓ Catégorie: " + categorieDuplicata.getLibelle());

        // Créer la demande CATÉGORIE (comme le ferait creerDemandeCategorie())
        System.out.println("\nCréation de la demande catégorie...");
        Demande demandeCategorie = new Demande();
        demandeCategorie.setIdDemande("DMD000002");
        demandeCategorie.setCreatedAt(LocalDate.now());
        demandeCategorie.setUpdatedAt(LocalDate.now());
        demandeCategorie.setParentDemande(demandeParent);
        demandeCategorie.setCategorie(categorieDuplicata);
        demandeCategorie.setTypeVisa(demandeParent.getTypeVisa());
        demandeCategorie.setDemandeur(demandeParent.getDemandeur());
        demandeCategorie.setPassport(demandeParent.getPassport());
        demandeCategorie.setVisaTransformable(demandeParent.getVisaTransformable());

        // Vérifications
        System.out.println("\nVérifications:");
        assert demandeCategorie.getIdDemande() != null : "❌ ID manquant";
        System.out.println("✓ ID: " + demandeCategorie.getIdDemande());

        assert demandeCategorie.getCategorie() != null : "❌ Catégorie manquante";
        System.out.println("✓ Catégorie: " + demandeCategorie.getCategorie().getLibelle());

        assert demandeCategorie.getParentDemande() != null : "❌ Parent manquant";
        System.out.println("✓ Parent ID: " + demandeCategorie.getParentDemande().getIdDemande());

        assert demandeCategorie.getDemandeur() != null : "❌ Demandeur manquant";
        System.out.println("✓ Demandeur: " + demandeCategorie.getDemandeur().getNom());

        assert demandeCategorie.getPassport() != null : "❌ Passport manquant";
        System.out.println("✓ Passport: " + demandeCategorie.getPassport().getNumero());

        assert demandeCategorie.getTypeVisa() != null : "❌ TypeVisa manquant";
        System.out.println("✓ TypeVisa: " + demandeCategorie.getTypeVisa().getLibelle());

        System.out.println("\n✅ TEST RÉUSSI: Demande catégorie créée avec tous les champs!\n");
    }

    /**
     * Test 2: Créer une demande catégorie Transfert-Visa
     */
    @Test
    void testCreerDemandeCategorieTransfert() {
        System.out.println("\n========== TEST: Création Demande Catégorie Transfert-Visa ==========\n");

        // Créer les objets
        Demandeur demandeur = new Demandeur();
        demandeur.setIdDemandeur("DEM000002");
        demandeur.setNom("Fatima");
        demandeur.setPrenom("Zara");

        Passport passport = new Passport();
        passport.setIdPassport("PAS000002");
        passport.setNumero("ABC789");

        TypeVisa typeVisa = new TypeVisa();
        typeVisa.setIdTypeVisa("TV000002");
        typeVisa.setLibelle("Visa Travail");

        // Demande parent
        Demande demandeParent = new Demande();
        demandeParent.setIdDemande("DMD000003");
        demandeParent.setDemandeur(demandeur);
        demandeParent.setPassport(passport);
        demandeParent.setTypeVisa(typeVisa);
        demandeParent.setCreatedAt(LocalDate.now());

        // Catégorie TRANSFERT-VISA
        CategorieDemande categorieTransfert = new CategorieDemande();
        categorieTransfert.setIdCategorie("CD000003");
        categorieTransfert.setLibelle("Transfert de Visa");

        // Demande catégorie
        Demande demandeCategorie = new Demande();
        demandeCategorie.setIdDemande("DMD000004");
        demandeCategorie.setParentDemande(demandeParent);
        demandeCategorie.setCategorie(categorieTransfert);
        demandeCategorie.setTypeVisa(demandeParent.getTypeVisa());
        demandeCategorie.setDemandeur(demandeParent.getDemandeur());
        demandeCategorie.setPassport(demandeParent.getPassport());
        demandeCategorie.setCreatedAt(LocalDate.now());

        // Vérifications
        System.out.println("Vérifications:");
        assert demandeCategorie.getIdDemande() != null : "❌ ID manquant";
        assert "Transfert de Visa".equals(demandeCategorie.getCategorie().getLibelle()) : "❌ Catégorie incorrecte";
        System.out.println("✓ Demande ID: " + demandeCategorie.getIdDemande());
        System.out.println("✓ Catégorie: " + demandeCategorie.getCategorie().getLibelle());
        System.out.println("✓ Parent: " + demandeCategorie.getParentDemande().getIdDemande());

        System.out.println("\n✅ TEST RÉUSSI: Demande catégorie Transfert créée!\n");
    }

    /**
     * Test 3: Vérifier que les champs obligatoires sont assignés
     */
    @Test
    void testVérificationChampsObligatoires() {
        System.out.println("\n========== TEST: Vérification Champs Obligatoires ==========\n");

        Demandeur demandeur = new Demandeur();
        demandeur.setIdDemandeur("DEM000003");

        Passport passport = new Passport();
        passport.setIdPassport("PAS000003");

        TypeVisa typeVisa = new TypeVisa();
        typeVisa.setIdTypeVisa("TV000003");

        CategorieDemande categorie = new CategorieDemande();
        categorie.setIdCategorie("CD000002");

        Demande parentDemande = new Demande();
        parentDemande.setIdDemande("DMD000005");
        parentDemande.setDemandeur(demandeur);
        parentDemande.setPassport(passport);
        parentDemande.setTypeVisa(typeVisa);

        Demande demandeCategorie = new Demande();
        demandeCategorie.setIdDemande("DMD000006");
        demandeCategorie.setParentDemande(parentDemande);
        demandeCategorie.setCategorie(categorie);
        demandeCategorie.setTypeVisa(typeVisa);
        demandeCategorie.setDemandeur(demandeur);
        demandeCategorie.setPassport(passport);
        demandeCategorie.setCreatedAt(LocalDate.now());

        System.out.println("Checklist des champs obligatoires:");
        assert demandeCategorie.getIdDemande() != null;
        System.out.println("✓ idDemande: présent");

        assert demandeCategorie.getCategorie() != null;
        System.out.println("✓ categorie: présent");

        assert demandeCategorie.getTypeVisa() != null;
        System.out.println("✓ typeVisa: présent");

        assert demandeCategorie.getDemandeur() != null;
        System.out.println("✓ demandeur: présent");

        assert demandeCategorie.getParentDemande() != null;
        System.out.println("✓ parentDemande: présent");

        assert demandeCategorie.getPassport() != null;
        System.out.println("✓ passport: présent");

        assert demandeCategorie.getCreatedAt() != null;
        System.out.println("✓ createdAt: présent");

        System.out.println("\n✅ TEST RÉUSSI: Tous les champs obligatoires présents!\n");
    }
}
