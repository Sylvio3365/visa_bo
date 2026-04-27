<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="nt-page">
    <div class="nt-page-head mb-4">
        <h1>Créer une Carte de Résidence</h1>
        <p class="lead">Entrez les informations de la carte de résidence pour cette nouvelle demande.</p>
    </div>

    <!-- AFFICHAGE DES ERREURS DE VALIDATION -->
    <c:if test="${not empty validationErrors}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <h4 class="alert-heading">❌ Erreurs de validation</h4>
            <c:forEach var="error" items="${validationErrors}">
                <p class="mb-1"><i class="fas fa-exclamation-circle"></i> ${error}</p>
            </c:forEach>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="form-wrapper">
        <form method="post" action="<c:url value='/demande/etape8'/>">
            <div class="form-group">
                <label for="carteResidenceRef">Référence Carte de Résidence *</label>
                <input type="text" id="carteResidenceRef" name="carteResidenceRef" class="form-control" 
                       value="${demandeForm.carteResidenceRef}" required>
            </div>

            <div class="form-group">
                <label for="carteResidenceDateDebut">Date de Début *</label>
                <input type="date" id="carteResidenceDateDebut" name="carteResidenceDateDebut" class="form-control" 
                       value="${demandeForm.carteResidenceDateDebut}" required>
            </div>

            <div class="form-group">
                <label for="carteResidenceDateFin">Date de Fin *</label>
                <input type="date" id="carteResidenceDateFin" name="carteResidenceDateFin" class="form-control" 
                       value="${demandeForm.carteResidenceDateFin}" required>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-arrow-right"></i> Continuer
                </button>
                <a href="<c:url value='/demande/etape7'/>" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left"></i> Retour
                </a>
            </div>
        </form>
    </div>
</div>
