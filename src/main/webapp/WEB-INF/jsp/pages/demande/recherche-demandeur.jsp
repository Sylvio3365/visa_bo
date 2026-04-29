<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0/dist/css/select2.min.css" rel="stylesheet" />

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0/dist/js/select2.min.js"></script>

<div class="nt-page">
    <div class="search-container">
        <!-- En-tête -->
        <section class="hero nt-page-head mb-4">
            <div class="d-flex justify-content-between align-items-start gap-3">
                <div>
                    <div class="pill">
                        <c:choose>
                            <c:when test="${operationType == 'duplicata'}"><i class="fas fa-copy"></i> Duplicata</c:when>
                            <c:when test="${operationType == 'transfert-visa'}"><i class="fas fa-exchange-alt"></i> Transfert</c:when>
                            <c:otherwise><i class="fas fa-search"></i> Recherche</c:otherwise>
                        </c:choose>
                    </div>
                    <h1 class="mt-3">Recherche de Demandeur</h1>
                    <p class="lead mb-0">Trouvez rapidement un demandeur par son numéro de passport ou de visa.</p>
                </div>
            </div>
        </section>

        <!-- Formulaire de recherche -->
        <div class="search-card">
            <form method="get" action="<c:url value='/demande/recherche-demandeur'/>" class="search-form">
                <div class="form-group">
                    <label for="searchNumber">Numéro Passport ou Visa</label>
                    <input type="text" id="searchNumber" name="searchNumber" class="form-control" 
                           placeholder="Entrez le numéro..." value="${searchNumber}" required>
                </div>
                <input type="hidden" name="operationType" value="${operationType}">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-search"></i> Rechercher
                </button>
            </form>

            <!-- Message d'erreur -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger mt-3" style="background: rgba(220, 53, 69, 0.1); border: 1px solid rgba(220, 53, 69, 0.3); border-radius: 12px; color: #721c24; font-weight: 500;">
                    <i class="fas fa-exclamation-triangle me-2"></i> ${errorMessage}
                </div>
            </c:if>
        </div>

        <!-- Résultats -->
        <c:if test="${not empty searchResult}">
            <div class="result-section">
                <c:choose>
                    <c:when test="${searchResult.found}">
                        <!-- Demandeur trouvé -->
                        <div class="demandeur-card">
                            <h3><i class="fas fa-check-circle"></i> Demandeur Trouvé</h3>

                            <!-- Infos personelles -->
                            <div class="info-grid">
                                <div class="info-section">
                                    <h5>Informations personnelles</h5>
                                    <div class="info-row">
                                        <span class="info-label">ID Demandeur</span>
                                        <span class="info-value">${searchResult.demandeur.idDemandeur}</span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Nom</span>
                                        <span class="info-value">${searchResult.demandeur.nom}</span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Prénom</span>
                                        <span class="info-value">${searchResult.demandeur.prenom}</span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Date de naissance</span>
                                        <span class="info-value">${searchResult.demandeur.dtn}</span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Nationalité</span>
                                        <span class="info-value">${searchResult.demandeur.nationalite.libelle}</span>
                                    </div>
                                </div>
                                <div class="info-section">
                                    <h5>Informations de contact</h5>
                                    <div class="info-row">
                                        <span class="info-label">Téléphone</span>
                                        <span class="info-value">${searchResult.demandeur.telephone}</span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Email</span>
                                        <span class="info-value">${searchResult.demandeur.email}</span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Adresse Madagascar</span>
                                        <span class="info-value">${searchResult.demandeur.adresseMada}</span>
                                    </div>
                                    <div class="info-row">
                                        <span class="info-label">Situation familiale</span>
                                        <span class="info-value">${searchResult.demandeur.situationFamille.libelle}</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Documents et Visas -->
                            <div class="documents-area">
                                <h5>Documents et Visas</h5>
                                <div class="documents-grid">
                                    <c:if test="${not empty searchResult.lastPassport}">
                                        <div class="doc-card">
                                            <h6><i class="fas fa-passport me-2"></i>Dernier Passport</h6>
                                            <p><strong>Numéro:</strong><br>${searchResult.lastPassport.numero}</p>
                                            <p><strong>Délivré le:</strong><br>${searchResult.lastPassport.delivreLe}</p>
                                            <p><strong>Expire le:</strong><br>${searchResult.lastPassport.expireLe}</p>
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty searchResult.lastVisaTransformable}">
                                        <div class="doc-card">
                                            <h6><i class="fas fa-file-alt me-2"></i>Dernier Visa Transformable</h6>
                                            <p><strong>Référence:</strong><br>${searchResult.lastVisaTransformable.refVisa}</p>
                                            <p><strong>Du:</strong><br>${searchResult.lastVisaTransformable.dateDebut}</p>
                                            <p><strong>Au:</strong><br>${searchResult.lastVisaTransformable.dateFin}</p>
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty searchResult.lastVisa}">
                                        <div class="doc-card">
                                            <h6><i class="fas fa-stamp me-2"></i>Dernier Visa</h6>
                                            <p><strong>Référence:</strong><br>${searchResult.lastVisa.refVisa}</p>
                                            <p><strong>Du:</strong><br>${searchResult.lastVisa.dateDebut}</p>
                                            <p><strong>Au:</strong><br>${searchResult.lastVisa.dateFin}</p>
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty searchResult.lastCarteResidence}">
                                        <div class="doc-card">
                                            <h6><i class="fas fa-id-card me-2"></i>Dernière Carte de Résidence</h6>
                                            <p><strong>Référence:</strong><br>${searchResult.lastCarteResidence.refCarteResidence}</p>
                                            <p><strong>Du:</strong><br>${searchResult.lastCarteResidence.dateDebut}</p>
                                            <p><strong>Au:</strong><br>${searchResult.lastCarteResidence.dateFin}</p>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            <div class="action-btns">

                             <c:if test="${operationType == 'duplicata' || operationType == 'transfert-visa'}">

                                 <c:if test="${not empty searchResult.visas}">
                    <form class="visa-select-form" action="${pageContext.request.contextPath}/demande/creer-categorie" method="get">

                <input type="hidden" name="idDemandeur" value="${searchResult.demandeur.idDemandeur}">
                <input type="hidden" name="type" value="${operationType}">

              <label>Choisir un visa :</label>

<select name="visaId" id="visaSelect" required class="form-control">
    <c:forEach var="visa" items="${searchResult.visas}">
        <option value="${visa.idVisa}">
            ${visa.refVisa} - ${visa.dateDebut} au ${visa.dateFin}
        </option>
    </c:forEach>
</select>

                <button type="submit" class="btn btn-primary">
                    <c:choose>
                        <c:when test="${operationType == 'duplicata'}">
                            <i class="fas fa-copy"></i> Continuer Duplicata
                        </c:when>
                        <c:when test="${operationType == 'transfert-visa'}">
                            <i class="fas fa-exchange-alt"></i> Continuer Transfert
                        </c:when>
                    </c:choose>
                </button>

            </form>
        </c:if>

        <c:if test="${empty searchResult.visas}">
            <p>Aucun visa trouvé pour ce passeport.</p>
        </c:if>

    </c:if>

    <!-- cas normal -->
    <c:if test="${operationType != 'duplicata' && operationType != 'transfert-visa'}">
        <a href="<c:url value='/demande/Nouvelle-demande?idDemandeur=${searchResult.demandeur.idDemandeur}'/>"
           class="btn btn-primary">
            <i class="fas fa-plus"></i> Nouvelle Demande
        </a>
    </c:if>

    <a href="<c:url value='/demandes'/>" class="btn btn-outline-secondary">
        <i class="fas fa-arrow-left"></i> Retour à la liste
    </a>

                        </div>
                        </div>

                    </c:when>
                    <c:otherwise>
                        <!-- Aucun résultat -->
                        <div class="no-result-card">
                            <h3><i class="fas fa-exclamation-circle"></i> Aucun Demandeur Trouvé</h3>
                            <p>Aucun demandeur n'a été trouvé avec le numéro: <strong>${searchNumber}</strong></p>
                            <div class="action-btns" style="justify-content: center; border-top: none; padding-top: 0; margin-top: 20px;">
                                <c:choose>
                                    <c:when test="${operationType == 'duplicata' || operationType == 'transfert-visa'}">
                                        <a href="<c:url value='/demande/Nouvelle-demande?createdFromSearch=true&type=${operationType}&needsVisaCarte=true'/>" class="btn btn-primary">
                                            <i class="fas fa-plus"></i> Créer une Nouvelle Demande
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="<c:url value='/demande/Nouvelle-demande?createdFromSearch=true'/>" class="btn btn-primary">
                                            <i class="fas fa-plus"></i> Créer une Nouvelle Demande
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                                <button onclick="location.reload();" class="btn btn-outline-secondary">
                                    <i class="fas fa-redo"></i> Nouvelle Recherche
                                </button>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
    </div>
</div>

<script>
    $(document).ready(function() {
    $('#visaSelect').select2({
        placeholder: "Rechercher un visa",
        width: '100%'
    });
});
</script>
