<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="nt-page">
    <div class="nt-page-head mb-4">
        <h1>Créer un Visa</h1>
        <p class="lead">Entrez les informations du visa pour cette nouvelle demande.</p>
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
        <form method="post" action="<c:url value='/demande/etape7'/>">
            <div class="form-group">
                <label for="visaRefVisa">Référence Visa *</label>
                <input type="text" id="visaRefVisa" name="visaRefVisa" class="form-control" 
                       value="${demandeForm.visaRefVisa}" required>
            </div>

            <div class="form-group">
                <label for="visaDateDebut">Date de Début *</label>
                <input type="date" id="visaDateDebut" name="visaDateDebut" class="form-control" 
                       value="${demandeForm.visaDateDebut}" required>
            </div>

            <div class="form-group">
                <label for="visaDateFin">Date de Fin *</label>
                <input type="date" id="visaDateFin" name="visaDateFin" class="form-control" 
                       value="${demandeForm.visaDateFin}" required>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-arrow-right"></i> Continuer
                </button>
                <a href="<c:url value='/demande/etape6'/>" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left"></i> Retour
                </a>
            </div>
        </form>
    </div>
</div>
